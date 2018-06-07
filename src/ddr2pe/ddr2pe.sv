import GLOBAL_PARAM::*;
import INS_CONST::INST_W;

module ddr2pe#(
    parameter   BUF_DEPTH   = 256,
    parameter   IDX_DEPTH   = 256,
    parameter   PE_NUM      = 32,
    parameter   ADDR_W      = bw(BUF_DEPTH)
    )(
    input   clk,
    input   rst,
    
    // global registers
    input   [4      -1 : 0] layer_type,
    input   [8      -1 : 0] in_img_width,
    input   [8      -1 : 0] out_img_width,
    input   [4      -1 : 0] in_ch_seg,
    input   [4      -1 : 0] out_ch_seg,
    input                   depool,
    
    // instruction input
    input                   ins_valid,
    output                  ins_ready,
    input   [INST_W -1 : 0] ins,

    // instruction done information
    output  [6      -1 ：0] rx_done_buf_id,
    output  [4      -1 : 0] rx_done_opcode,
    output                  rx_done_pulse,
    
    // the 2 ddr ports
    input   [DDR_W      -1 : 0] ddr1_data,
    input                       ddr1_valid,
    output                      ddr1_ready,
    
    output  [DDR_ADDR_W -1 : 0] ddr1_addr,
    output  [BURST_W    -1 : 0] ddr1_size,
    output                      ddr1_addr_valid,
    input                       ddr1_addr_ready,
    
    input   [DDR_W      -1 : 0] ddr2_data,
    input                       ddr2_valid,
    output                      ddr2_ready,
    
    output  [DDR_ADDR_W -1 : 0] ddr2_addr,
    output  [BURST_W    -1 : 0] ddr2_size,
    output                      ddr2_addr_valid,
    input                       ddr2_addr_ready,
    
    // index buffer write port
    output  [IDX_W*2        -1 : 0] idx_wr_data,
    output  [bw(IDX_DEPTH)  -1 : 0] idx_wr_addr,
    output  [PE_NUM         -1 : 0] idx_wr_en,
    
    // data buffer write port
    output  [ADDR_W  -1 : 0]               dbuf_wr_addr,
    output  [3 : 0][DATA_W * BATCH -1 : 0] dbuf_wr_data,
    output  [PE_NUM -1 : 0]                dbuf_wr_en,
    
    // parameter buffer write port
    output  [ADDR_W  -1 : 0]               pbuf_wr_addr,
    output  [3 : 0][DATA_W * BATCH -1 : 0] pbuf_wr_data,
    output  [PE_NUM -1 : 0]                pbuf_wr_en,
    
    output                  bbuf_acc_en,
    output                  bbuf_acc_new,
    output  [ADDR_W -1 : 0] bbuf_acc_addr,
    output  [RES_W  -1 : 0] bbuf_acc_data,
    
    // accum and bias buf port
    output  [ADDR_W         -1 : 0] abuf_wr_addr,
    output  [BATCH * DATA_W -1 : 0] abuf_wr_data,
    output  [PE_NUM         -1 : 0] abuf_wr_data_en,
    output  [BATCH * TAIL_W -1 : 0] abuf_wr_tail,
    output  [PE_NUM         -1 : 0] abuf_wr_tail_en,
    
    output  [ADDR_W -1 : 0] bbuf_wr_addr,
    output  [DATA_W -1 : 0] bbuf_wr_data,
    output                  bbuf_wr_data_en,
    output  [TAIL_W -1 : 0] bbuf_wr_tail,
    output                  bbuf_wr_tail_en
    );

    wire                    m_rx_ins_valid;
    wire                    m_rx_ins_ready;
    wire    [INST_W -1 : 0] m_rx_ins;

    wire                    s_rx_ins_valid;
    wire                    s_rx_ins_ready;
    wire    [INST_W -1 : 0] s_rx_ins;
    
    wire                    ibuf_conf_valid;
    wire                    ibuf_conf_ready;
    wire    [4      -1 : 0] ibuf_conf_mode;
    wire    [8      -1 : 0] ibuf_conf_idx_num;
    wire    [PE_NUM -1 : 0] ibuf_conf_mask;
    
    wire                    dbuf_conf_valid;
    wire                    dbuf_conf_ready;
    wire    [4      -1 : 0] dbuf_conf_mode;
    wire    [4      -1 : 0] dbuf_conf_ch_num;
    wire    [4      -1 : 0] dbuf_conf_row_num;
    wire    [4      -1 : 0] dbuf_conf_pix_num;
    wire    [PE_NUM -1 : 0] dbuf_conf_mask;
    wire                    dbuf_conf_depool;
    
    wire                    pbuf_conf_valid;
    wire                    pbuf_conf_ready;
    wire    [16     -1 : 0] pbuf_conf_trans_num;
    wire    [4      -1 : 0] pbuf_conf_mode;     
    wire    [4      -1 : 0] pbuf_conf_ch_num;   
    wire    [4      -1 : 0] pbuf_conf_pix_num;  
    wire    [2      -1 : 0] pbuf_conf_row_num;  
    wire                    pbuf_conf_depool;
    wire    [PE_NUM -1 : 0] pbuf_conf_mask;

    wire                    abuf_conf_valid;
    wire                    abuf_conf_ready;
    wire    [2      -1 : 0] abuf_conf_trans_type;
    wire    [16     -1 : 0] abuf_conf_trans_num;
    wire    [PE_NUM -1 : 0] abuf_conf_mask;
    
    wire            dbuf_ddr1_ready;
    wire            dbuf_ddr2_ready;
    wire            ibuf_ddr1_ready;
    wire            pbuf_ddr1_ready;
    wire            pbuf_ddr2_ready;    
    wire            abuf_ddr2_ready;
    
    wire                        ddr1_conf_valid;
    wire                        ddr1_conf_ready;
    wire    [DDR_ADDR_W -1 : 0] ddr1_st_addr;
    wire    [BURST_W    -1 : 0] ddr1_burst;
    wire    [DDR_ADDR_W -1 : 0] ddr1_step;
    wire    [BURST_W    -1 : 0] ddr1_burst_num;
    
    wire                        ddr2_conf_valid;
    wire                        ddr2_conf_ready;
    wire    [DDR_ADDR_W -1 : 0] ddr2_st_addr;
    wire    [BURST_W    -1 : 0] ddr2_burst;
    wire    [DDR_ADDR_W -1 : 0] ddr2_step;
    wire    [BURST_W    -1 : 0] ddr2_burst_num;
    
    wire    [1 : 0] ddr1_ready_mux;
    wire    [1 : 0] ddr2_ready_mux;
    
    wire    [1 : 0] dbuf_ddr_sel;
    wire            ibuf_ddr_sel;
    wire    [1 : 0] pbuf_ddr_sel;
    wire            abuf_ddr_sel;

    ddr_read_config ddr_read_config_inst (
        .clk            (clk            ),
        .rst            (rst            ),
        
        .in_img_width   (in_img_width   ),
        .out_img_width  (out_img_width  ),
        .in_ch_seg      (in_ch_seg      ),
        .out_ch_set     (out_ch_seg     ),
    
        .ins_valid      (ins_valid      ),
        .ins_ready      (ins_ready      ),
        .ins            (ins            ),

        .rx_ins_valid   (m_rx_ins_valid ),
        .rx_ins_ready   (m_rx_ins_ready ),
        .rx_ins         (m_rx_ins       ),

        .ddr1_conf_valid(ddr1_conf_valid),
        .ddr1_conf_ready(ddr1_conf_ready),
        .ddr1_st_addr   (ddr1_st_addr   ),
        .ddr1_burst     (ddr1_burst     ),
        .ddr1_step      (ddr1_step      ),
        .ddr1_burst_num (ddr1_burst_num ),

        .ddr2_conf_valid(ddr2_conf_valid),
        .ddr2_conf_ready(ddr2_conf_ready),
        .ddr2_st_addr   (ddr2_st_addr   ),
        .ddr2_burst     (ddr2_burst     ),
        .ddr2_step      (ddr2_step      ),
        .ddr2_burst_num (ddr2_burst_num )
    );

    short_fifo#(
        .DATA_W (INST_W ),
        .DEPTH  (32     )
    ) ins_fifo (
        .clk        (clk            ),
        .rst        (rst            ),
        .wr_data    (m_rx_ins       ),
        .wr_valid   (m_rx_ins_valid ),
        .wr_ready   (m_rx_ins_ready ),
        .rd_data    (s_rx_ins       ),
        .rd_valid   (s_rx_ins_valid ),
        .rd_ready   (s_rx_ins_ready )
    );

    rx_config#(
        .PE_NUM (PE_NUM ),
    ) rx_config_inst (
        .clk                    (clk                    ),
        .rst                    (rst                    ),

        .layer_type             (layer_type             ),
        .in_img_width           (in_img_width           ),
        .out_img_width          (out_img_width          ),
        .in_ch_seg              (in_ch_seg              ),
        .out_ch_seg             (out_ch_seg             ),
        .depool                 (depool                 ),

        .ins_valid              (s_rx_ins               ),
        .ins_ready              (s_rx_ins_valid         ),
        .ins                    (s_rx_ins_ready         ),

        .rx_done_buf_id         (rx_done_buf_id         ),
        .rx_done_opcode         (rx_done_opcode         ),
        .rx_done_pulse          (rx_done_pulse          ),

        .ibuf_conf_valid        (ibuf_conf_valid        ),
        .ibuf_conf_ready        (ibuf_conf_ready        ),
        .ibuf_conf_mode         (ibuf_conf_mode         ),
        .ibuf_conf_idx_num      (ibuf_conf_idx_num      ),
        .ibuf_conf_mask         (ibuf_conf_mask         ),

        .dbuf_conf_valid        (dbuf_conf_valid        ),
        .dbuf_conf_ready        (dbuf_conf_ready        ),
        .dbuf_conf_mode         (dbuf_conf_mode         ),
        .dbuf_conf_ch_num       (dbuf_conf_ch_num       ),
        .dbuf_conf_row_num      (dbuf_conf_row_num      ),
        .dbuf_conf_pix_num      (dbuf_conf_pix_num      ),
        .dbuf_conf_mask         (dbuf_conf_mask         ),
        .dbuf_conf_depool       (dbuf_conf_depool       ),

        .pbuf_conf_valid        (pbuf_conf_valid        ),
        .pbuf_conf_ready        (pbuf_conf_ready        ),
        .pbuf_conf_trans_num    (pbuf_conf_trans_num    ),
        .pbuf_conf_mode         (pbuf_conf_mode         ),     
        .pbuf_conf_ch_num       (pbuf_conf_ch_num       ),   
        .pbuf_conf_pix_num      (pbuf_conf_pix_num      ),  
        .pbuf_conf_row_num      (pbuf_conf_row_num      ),  
        .pbuf_conf_depool       (pbuf_conf_depool       ),
        .pbuf_conf_mask         (pbuf_conf_mask         ),

        .abuf_conf_valid        (abuf_conf_valid        ),
        .abuf_conf_ready        (abuf_conf_ready        ),
        .abuf_conf_trans_type   (abuf_conf_trans_type   ),
        .abuf_conf_trans_num    (abuf_conf_trans_num    ),
        .abuf_conf_mask         (abuf_conf_mask         ),

        .ddr1_ready_mux         (ddr1_ready_mux         ),
        .ddr2_ready_mux         (ddr2_ready_mux         ),

        .dbuf_ddr_sel           (dbuf_ddr_sel           ),
        .ibuf_ddr_sel           (ibuf_ddr_sel           ),
        .pbuf_ddr_sel           (pbuf_ddr_sel           ),
        .abuf_ddr_sel           (abuf_ddr_sel           ) 
    );
    
    ddr2ibuf#(
        .IDX_DEPTH  (IDX_DEPTH  )
    ) ddr2ibuf_inst (
<<<<<<< HEAD
        .clk            (clk                ),
        .rst            (rst                ),
    
        .conf_valid     (ibuf_start         ),
        .conf_ready     (ibuf_ready         ),
        .conf_mode      (ibuf_conf_mode     ),
        .conf_idx_num   (ibuf_conf_idx_num  ),
        .conf_mask      (ibuf_conf_mask     ),
=======
        .clk            (clk                    ),
        .rst            (rst                    ),
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
    
        .conf_valid     (ibuf_conf_valid        ),
        .conf_ready     (ibuf_conf_ready        ),
        .conf_mode      (ibuf_conf_mode         ),
        .conf_idx_num   (ibuf_conf_idx_num      ),
        .conf_mask      (ibuf_conf_mask         ),

        .ddr_data       (ddr1_data              ),
        .ddr_valid      (ddr1_valid && ibuf_ddr_sel),
        .ddr_ready      (ibuf_ddr1_ready        ),

        .idx_wr_data    (idx_wr_data            ),
        .idx_wr_addr    (idx_wr_addr            ),
        .idx_wr_en      (idx_wr_en              )
    );

    ddr2dbuf#(
        .BUF_DEPTH  (BUF_DEPTH  )
    ) ddr2dbuf_inst (
        .clk            (clk                    ),
        .rst            (rst                    ),

<<<<<<< HEAD
        .conf_valid     (dbuf_start         ),
        .conf_ready     (dbuf_ready         ),
        .conf_mode      (dbuf_mode          ),
        .conf_ch_num    (dbuf_ch_num        ),
        .conf_row_num   (dbuf_row_num       ),
        .conf_pix_num   (dbuf_pix_num       ),
        .conf_mask      (dbuf_mask          ),
        .conf_depool    (dbuf_depool        ),
    
        .ddr1_data      (ddr1_data          ),
=======
        .conf_valid     (dbuf_conf_valid        ),
        .conf_ready     (dbuf_conf_ready        ),
        .conf_mode      (dbuf_conf_mode         ),
        .conf_ch_num    (dbuf_conf_ch_num       ),
        .conf_row_num   (dbuf_conf_row_num      ),
        .conf_pix_num   (dbuf_conf_pix_num      ),
        .conf_mask      (dbuf_conf_mask         ),
        .conf_depool    (dbuf_conf_depool       ),
    
        .ddr1_data      (ddr1_data              ),
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
        .ddr1_valid     (ddr1_valid && dbuf_ddr_sel[0]),
        .ddr1_ready     (dbuf_ddr1_ready        ),

        .ddr2_data      (ddr2_data              ),
        .ddr2_valid     (ddr2_valid && dbuf_ddr_sel[1]),
        .ddr2_ready     (dbuf_ddr2_ready        ),

        .dbuf_wr_addr   (dbuf_wr_addr           ),
        .dbuf_wr_data   (dbuf_wr_data           ),
        .dbuf_wr_en     (dbuf_wr_en             )
    );
    
    ddr2pbuf#(
        .BUF_DEPTH  (BUF_DEPTH  )
    ) ddr2pbuf_inst (
<<<<<<< HEAD
        .clk            (clk                ),
        .rst            (rst                ),
    
        .conf_valid     (pbuf_start         ),
        .conf_ready     (pbuf_ready         ),
        .conf_trans_num (pbuf_trans_num     ),
        .conf_mode      (pbuf_mode          ),
        .conf_ch_num    (pbuf_ch_num        ),
        .conf_pix_num   (pbuf_pix_num       ),
        .conf_row_num   (pbuf_row_num       ),
        .conf_depool    (pbuf_depool        ),
        .conf_mask      (pbuf_mask          ),
    
        .ddr1_data      (ddr1_data          ),
=======
        .clk            (clk                    ),
        .rst            (rst                    ),
    
        .conf_valid     (pbuf_conf_valid        ),
        .conf_ready     (pbuf_conf_ready        ),
        .conf_trans_num (pbuf_conf_trans_num    ),
        .conf_mode      (pbuf_conf_mode         ),     
        .conf_ch_num    (pbuf_conf_ch_num       ),   
        .conf_pix_num   (pbuf_conf_pix_num      ),  
        .conf_row_num   (pbuf_conf_row_num      ),  
        .conf_depool    (pbuf_conf_depool       ),
        .conf_mask      (pbuf_conf_mask         ),
    
        .ddr1_data      (ddr1_data              ),
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
        .ddr1_valid     (ddr1_valid && pbuf_ddr_sel[0]),
        .ddr1_ready     (pbuf_ddr1_ready        ),

        .ddr2_data      (ddr2_data              ),
        .ddr2_valid     (ddr2_valid && pbuf_ddr_sel[1]),
        .ddr2_ready     (pbuf_ddr2_ready        ),

        .pbuf_wr_addr   (pbuf_wr_addr           ),
        .pbuf_wr_data   (pbuf_wr_data           ),
        .pbuf_wr_en     (pbuf_wr_en             ),

        .bbuf_acc_en    (bbuf_acc_en            ),
        .bbuf_acc_new   (bbuf_acc_new           ),
        .bbuf_acc_addr  (bbuf_acc_addr          ),
        .bbuf_acc_data  (bbuf_acc_data          )
    );

    ddr2abuf#(
        .BUF_DEPTH  (BUF_DEPTH  ),
        .PE_NUM     (PE_NUM     )
    ) ddr2abuf_inst (
        .clk            (clk                    ),
        .rst            (rst                    ),
    
<<<<<<< HEAD
        .conf_valid     (abuf_start             ),
        .conf_ready     (abuf_ready             ),
        .conf_trans_type(abuf_trans_type        ),
        .conf_trans_num (abuf_trans_num         ),
        .conf_mask      (abuf_mask              ),
=======
        .conf_valid     (abuf_conf_valid        ),
        .conf_ready     (abuf_conf_ready        ),
        .conf_trans_type(abuf_conf_trans_type   ),
        .conf_trans_num (abuf_conf_trans_num    ),
        .conf_mask      (abuf_conf_mask         ),
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
    
        .ddr_data       (ddr2_data              ),
        .ddr_valid      (ddr2_valid && abuf_ddr_sel),
        .ddr_ready      (abuf_ddr2_ready        ),
    
        .abuf_wr_addr   (abuf_wr_addr           ),
        .abuf_wr_data   (abuf_wr_data           ),
        .abuf_wr_data_en(abuf_wr_data_en        ),
        .abuf_wr_tail   (abuf_wr_tail           ),
        .abuf_wr_tail_en(abuf_wr_tail_en        ),
    
        .bbuf_wr_addr   (bbuf_wr_addr           ),
        .bbuf_wr_data   (bbuf_wr_data           ),
        .bbuf_wr_data_en(bbuf_wr_data_en        ),
        .bbuf_wr_tail   (bbuf_wr_tail           ),
        .bbuf_wr_tail_en(bbuf_wr_tail_en        )
    );
    
    ddr_addr_gen#(
        .DDR_ADDR_W (DDR_ADDR_W ),
        .BURST_W    (BURST_W    )
    ) ddr1_addr_gen_inst (
        .clk            (clk            ),
        .rst            (rst            ),
        
        .start          (ddr1_conf_valid),
        .done           (ddr1_conf_ready),
        .st_addr        (ddr1_st_addr   ),
        .burst          (ddr1_burst     ),
        .step           (ddr1_step      ),
        .burst_num      (ddr1_burst_num ),

        .ddr_addr       (ddr1_addr      ),
        .ddr_size       (ddr1_size      ),
        .ddr_addr_valid (ddr1_addr_valid),
        .ddr_addr_ready (ddr1_addr_ready)
    );
    
    ddr_addr_gen#(
        .DDR_ADDR_W (DDR_ADDR_W ),
        .BURST_W    (BURST_W    )
    ) ddr2_addr_gen_inst (
        .clk            (clk            ),
        .rst            (rst            ),
        
        .start          (ddr2_conf_valid),
        .done           (ddr2_conf_ready),
        .st_addr        (ddr2_st_addr   ),
        .burst          (ddr2_burst     ),
        .step           (ddr2_step      ),
        .burst_num      (ddr2_burst_num ),
    
        .ddr_addr       (ddr2_addr      ),
        .ddr_size       (ddr2_size      ),
        .ddr_addr_valid (ddr2_addr_valid),
        .ddr_addr_ready (ddr2_addr_ready)
    );
    
    assign  ddr1_ready = ddr1_ready_mux[1] ? pbuf_ddr1_ready : 
                        (ddr1_ready_mux[0] ? ibuf_ddr1_ready : dbuf_ddr1_ready);
    assign  ddr2_ready = ddr2_ready_mux[1] ? abuf_ddr2_ready :
                        (ddr2_ready_mux[0] ? pbuf_ddr2_ready : dbuf_ddr2_ready);
    
endmodule