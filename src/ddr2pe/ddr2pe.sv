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
    
    input   [4      -1 : 0] layer_type,
    input   [8      -1 : 0] in_img_width,
    input   [8      -1 : 0] out_img_width,
    input   [4      -1 : 0] in_ch_seg,
    input   [4      -1 : 0] out_ch_seg,
    input                   depool,
    
    input                   ins_valid,
    output                  ins_ready,
    input   [INST_W -1 : 0] ins,
    
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
    
    output  [IDX_W*2        -1 : 0] idx_wr_data,
    output  [bw(IDX_DEPTH)  -1 : 0] idx_wr_addr,
    output  [PE_NUM         -1 : 0] idx_wr_en,
    
    output  [ADDR_W  -1 : 0]               dbuf_wr_addr,
    output  [3 : 0][DATA_W * BATCH -1 : 0] dbuf_wr_data,
    output  [PE_NUM -1 : 0]                dbuf_wr_en,
    
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
    
    wire                    ibuf_start;
    wire                    ibuf_done;
    wire    [4      -1 : 0] ibuf_conf_mode;
    wire    [8      -1 : 0] ibuf_conf_idx_num;
    wire    [PE_NUM -1 : 0] ibuf_conf_mask;
    
    wire                    dbuf_start;
    wire                    dbuf_done;
    wire    [4      -1 : 0] dbuf_conf_mode;
    wire    [4      -1 : 0] dbuf_conf_ch_num;
    wire    [4      -1 : 0] dbuf_conf_row_num;
    wire    [4      -1 : 0] dbuf_conf_pix_num;
    wire    [PE_NUM -1 : 0] dbuf_conf_mask;
    wire                    dbuf_conf_depool;
    
    wire                    pbuf_start;
    wire                    pbuf_done;
    wire    [16     -1 : 0] pbuf_conf_trans_num;
    wire    [4      -1 : 0] pbuf_conf_mode;     
    wire    [4      -1 : 0] pbuf_conf_ch_num;   
    wire    [4      -1 : 0] pbuf_conf_pix_num;  
    wire    [2      -1 : 0] pbuf_conf_row_num;  
    wire                    pbuf_conf_depool;
    wire    [PE_NUM -1 : 0] pbuf_conf_mask;

    wire                    abuf_start;
    wire                    abuf_done;
    wire    [2      -1 : 0] abuf_conf_trans_type;
    wire    [16     -1 : 0] abuf_conf_trans_num;
    wire    [PE_NUM -1 : 0] abuf_conf_mask;
    
    wire            dbuf_ddr1_ready;
    wire            dbuf_ddr2_ready;
    wire            ibuf_ddr1_ready;
    wire            pbuf_ddr1_ready;
    wire            pbuf_ddr2_ready;
    
    wire            abuf_ddr2_ready;
    
    wire                        ddr1_start;
    wire                        ddr1_done;
    wire    [DDR_ADDR_W -1 : 0] ddr1_st_addr;
    wire    [BURST_W    -1 : 0] ddr1_burst;
    wire    [DDR_ADDR_W -1 : 0] ddr1_step;
    wire    [BURST_W    -1 : 0] ddr1_burst_num;
    
    wire                        ddr2_start;
    wire                        ddr2_done;
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
    
    ddr2pe_config#(
        .PE_NUM (PE_NUM )
    ) ddr2pe_config_inst (
        .clk        (clk        ),
        .rst        (rst        ),
        
        .layer_type     (layer_type     ),
        .in_img_width   (in_img_width   ),
        .out_img_width  (out_img_width  ),
        .in_ch_seg      (in_ch_seg      ),
        .depool         (depool         ),
    
        .ins_valid  (ins_valid  ),
        .ins_ready  (ins_ready  ),
        .ins        (ins        ),
    
        .ibuf_start         (ibuf_start         ),
        .ibuf_done          (ibuf_done          ),
        .ibuf_conf_mode     (ibuf_conf_mode     ),
        .ibuf_conf_idx_num  (ibuf_conf_idx_num  ),
        .ibuf_conf_mask     (ibuf_conf_mask     ),
    
        .dbuf_start         (dbuf_start         ),
        .dbuf_done          (dbuf_done          ),
        .dbuf_conf_mode     (dbuf_conf_mode     ),
        .dbuf_conf_ch_num   (dbuf_conf_ch_num   ),
        .dbuf_conf_row_num  (dbuf_conf_row_num  ),
        .dbuf_conf_pix_num  (dbuf_conf_pix_num  ),
        .dbuf_conf_mask     (dbuf_conf_mask     ),
        .dbuf_conf_depool   (dbuf_conf_depool   ),
    
        .pbuf_start         (pbuf_start         ),
        .pbuf_done          (pbuf_done          ),
        .pbuf_conf_trans_num(pbuf_conf_trans_num),
        .pbuf_conf_mode     (pbuf_conf_mode     ),     
        .pbuf_conf_ch_num   (pbuf_conf_ch_num   ),   
        .pbuf_conf_pix_num  (pbuf_conf_pix_num  ),  
        .pbuf_conf_row_num  (pbuf_conf_row_num  ),  
        .pbuf_conf_depool   (pbuf_conf_depool   ),
        .pbuf_conf_mask     (pbuf_conf_mask     ),

        .abuf_start             (abuf_start             ),
        .abuf_done              (abuf_done              ),
        .abuf_conf_trans_type   (abuf_conf_trans_type   ),
        .abuf_conf_trans_num    (abuf_conf_trans_num    ),
        .abuf_conf_mask         (abuf_conf_mask         ),
    
        .ddr1_start     (ddr1_start     ),
        .ddr1_done      (ddr1_done      ),
        .ddr1_st_addr   (ddr1_st_addr   ),
        .ddr1_burst     (ddr1_burst     ),
        .ddr1_step      (ddr1_step      ),
        .ddr1_burst_num (ddr1_burst_num ),
    
        .ddr2_start     (ddr2_start     ),
        .ddr2_done      (ddr2_done      ),
        .ddr2_st_addr   (ddr2_st_addr   ),
        .ddr2_burst     (ddr2_burst     ),
        .ddr2_step      (ddr2_step      ),
        .ddr2_burst_num (ddr2_burst_num ),
        
        .ddr1_ready_mux (ddr1_ready_mux ),
        .ddr2_ready_mux (ddr2_ready_mux ),
        
        .dbuf_ddr_sel   (dbuf_ddr_sel   ),
        .ibuf_ddr_sel   (ibuf_ddr_sel   ),
        .pbuf_ddr_sel   (pbuf_ddr_sel   ),
        .abuf_ddr_sel   (abuf_ddr_sel   )        
    );
    
    ddr2ibuf#(
        .IDX_DEPTH  (IDX_DEPTH  )
    ) ddr2ibuf_inst (
        .clk            (clk                ),
        .rst            (rst                ),
    
        .start          (ibuf_start         ),
        .done           (ibuf_done          ),
        .conf_mode      (ibuf_conf_mode     ),
        .conf_idx_num   (ibuf_conf_idx_num  ),
        .conf_mask      (ibuf_conf_mask     ),
    
        .ddr_data       (ddr1_data          ),
        .ddr_valid      (ddr1_valid && ibuf_ddr_sel),
        .ddr_ready      (ibuf_ddr1_ready    ),
    
        .idx_wr_data    (idx_wr_data        ),
        .idx_wr_addr    (idx_wr_addr        ),
        .idx_wr_en      (idx_wr_en          )
    );
    
    ddr2dbuf#(
        .BUF_DEPTH  (BUF_DEPTH  )
    ) ddr2dbuf_inst (
        .clk            (clk                ),
        .rst            (rst                ),

        .start          (dbuf_start         ),
        .done           (dbuf_done          ),
        .conf_mode      (dbuf_conf_mode     ),
        .conf_ch_num    (dbuf_conf_ch_num   ),
        .conf_row_num   (dbuf_conf_row_num  ),
        .conf_pix_num   (dbuf_conf_pix_num  ),
        .conf_mask      (dbuf_conf_mask     ),
        .conf_depool    (dbuf_conf_depool   ),
    
        .ddr1_data      (ddr1_data          ),
        .ddr1_valid     (ddr1_valid && dbuf_ddr_sel[0]),
        .ddr1_ready     (dbuf_ddr1_ready    ),
        
        .ddr2_data      (ddr2_data          ),
        .ddr2_valid     (ddr2_valid && dbuf_ddr_sel[1]),
        .ddr2_ready     (dbuf_ddr2_ready    ),
        
        .dbuf_wr_addr   (dbuf_wr_addr       ),
        .dbuf_wr_data   (dbuf_wr_data       ),
        .dbuf_wr_en     (dbuf_wr_en         )
    );
    
    ddr2pbuf#(
        .BUF_DEPTH  (BUF_DEPTH  )
    ) ddr2pbuf_inst (
        .clk            (clk                ),
        .rst            (rst                ),
    
        .start          (pbuf_start         ),
        .done           (pbuf_done          ),
        .conf_trans_num (pbuf_conf_trans_num),
        .conf_mode      (pbuf_conf_mode     ),
        .conf_ch_num    (pbuf_conf_ch_num   ),
        .conf_pix_num   (pbuf_conf_pix_num  ),
        .conf_row_num   (pbuf_conf_row_num  ),
        .conf_depool    (pbuf_conf_depool   ),
        .conf_mask      (pbuf_conf_mask     ),
    
        .ddr1_data      (ddr1_data          ),
        .ddr1_valid     (ddr1_valid && pbuf_ddr_sel[0]),
        .ddr1_ready     (pbuf_ddr1_ready    ),
        
        .ddr2_data      (ddr2_data          ),
        .ddr2_valid     (ddr2_valid && pbuf_ddr_sel[1]),
        .ddr2_ready     (pbuf_ddr2_ready    ),
        
        .pbuf_wr_addr   (pbuf_wr_addr       ),
        .pbuf_wr_data   (pbuf_wr_data       ),
        .pbuf_wr_en     (pbuf_wr_en         ),
    
        .bbuf_acc_en    (bbuf_acc_en        ),
        .bbuf_acc_new   (bbuf_acc_new       ),
        .bbuf_acc_addr  (bbuf_acc_addr      ),
        .bbuf_acc_data  (bbuf_acc_data      )
    );
    
    ddr2abuf#(
        .BUF_DEPTH  (BUF_DEPTH  ),
        .PE_NUM     (PE_NUM     )
    ) ddr2abuf_inst (
        .clk            (clk                    ),
        .rst            (rst                    ),
    
        .start          (abuf_start             ),
        .done           (abuf_done              ),
        .conf_trans_type(abuf_conf_trans_type   ),
        .conf_trans_num (abuf_conf_trans_num    ),
        .conf_mask      (abuf_conf_mask         ),
    
        // ddr data stream port
        .ddr_data       (ddr2_data              ),
        .ddr_valid      (ddr2_valid && abuf_ddr_sel),
        .ddr_ready      (abuf_ddr2_ready        ),
    
        // accum and bias buf port
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
        
        .start          (ddr1_start     ),
        .done           (ddr1_done      ),
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
        
        .start          (ddr2_start     ),
        .done           (ddr2_done      ),
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