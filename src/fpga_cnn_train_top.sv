import  GLOBAL_PARAM::*;
import  INS_CONST::*;

//(* dont_touch = "true" *)
module fpga_cnn_train_top#(
    parameter   PE_NUM  = 32
    )(
    input   clk,
    input   rst,
    
    input                   ins_valid,
    output                  ins_ready,
    input   [INST_W -1 : 0] ins,
    
    output                  working,
    
    input   [DDR_W      -1 : 0] ddr1_in_data,
    input                       ddr1_in_valid,
    output                      ddr1_in_ready,
    
    output  [DDR_ADDR_W -1 : 0] ddr1_in_addr,
    output  [BURST_W    -1 : 0] ddr1_in_size,
    output                      ddr1_in_addr_valid,
    input                       ddr1_in_addr_ready,
    
    input   [DDR_W      -1 : 0] ddr2_in_data,
    input                       ddr2_in_valid,
    output                      ddr2_in_ready,
    
    output  [DDR_ADDR_W -1 : 0] ddr2_in_addr,
    output  [BURST_W    -1 : 0] ddr2_in_size,
    output                      ddr2_in_addr_valid,
    input                       ddr2_in_addr_ready,
    
    output  [DDR_W      -1 : 0] ddr1_out_data,
    output                      ddr1_out_valid,
    input                       ddr1_out_ready,
                                     
    output  [DDR_ADDR_W -1 : 0] ddr1_out_addr,
    output  [BURST_W    -1 : 0] ddr1_out_size,
    output                      ddr1_out_addr_valid,
    input                       ddr1_out_addr_ready,
                                     
    output  [DDR_W      -1 : 0] ddr2_out_data,
    output                      ddr2_out_valid,
    input                       ddr2_out_ready,
                                     
    output  [DDR_ADDR_W -1 : 0] ddr2_out_addr,
    output  [BURST_W    -1 : 0] ddr2_out_size,
    output                      ddr2_out_addr_valid,
    input                       ddr2_out_addr_ready
    );
    
    localparam BUF_DEPTH = 256;
    localparam IDX_DEPTH = 256;
    localparam ADDR_W    = bw(BUF_DEPTH);
    
    wire                    ddr2pe_ins_valid;
    wire                    ddr2pe_ins_ready;
    wire    [INST_W -1 : 0] ddr2pe_ins;
    
    wire                    pe_ins_valid;
    wire                    pe_ins_ready;
    wire    [INST_W -1 : 0] pe_ins;
    
    wire                    pe2ddr_ins_valid;
    wire                    pe2ddr_ins_ready;
    wire    [INST_W -1 : 0] pe2ddr_ins;

    wire    [6      -1 : 0] rx_done_buf_id;
    wire    [4      -1 : 0] rx_done_opcode;
    wire                    rx_done_pulse;
    
    wire    [IDX_W*2        -1 : 0] idx_wr_data;
    wire    [bw(IDX_DEPTH)  -1 : 0] idx_wr_addr;
    wire    [PE_NUM         -1 : 0] idx_wr_en;

    wire           [ADDR_W         -1 : 0] dbuf_wr_addr;
    wire    [3 : 0][DATA_W * BATCH -1 : 0] dbuf_wr_data;
    wire    [PE_NUM -1 : 0]                dbuf_wr_en;

    wire    [ADDR_W         -1 : 0]        pbuf_wr_addr;
    wire    [3 : 0][DATA_W * BATCH -1 : 0] pbuf_wr_data;
    wire    [PE_NUM -1 : 0]                pbuf_wr_en;

    wire    [ADDR_W         -1 : 0] abuf_wr_addr;
    wire    [BATCH * DATA_W -1 : 0] abuf_wr_data;
    wire    [PE_NUM         -1 : 0] abuf_wr_data_en;
    wire    [BATCH * TAIL_W -1 : 0] abuf_wr_tail;
    wire    [PE_NUM         -1 : 0] abuf_wr_tail_en;
    
    wire                    bbuf_acc_en;
    wire                    bbuf_acc_new;
    wire    [ADDR_W -1 : 0] bbuf_acc_addr;
    wire    [RES_W  -1 : 0] bbuf_acc_data;
 
    wire    [ADDR_W -1 : 0] bbuf_wr_addr;
    wire    [DATA_W -1 : 0] bbuf_wr_data;
    wire                    bbuf_wr_data_en;
    wire    [TAIL_W -1 : 0] bbuf_wr_tail;
    wire                    bbuf_wr_tail_en;
    
    wire           [ADDR_W         -1 : 0] abuf_rd_addr;
    wire    [3 : 0][BATCH * RES_W  -1 : 0] abuf_rd_data;
    wire                                   abuf_rd_en;
    
    wire    [ADDR_W -1 : 0] bbuf_rd_addr;
    wire    [RES_W  -1 : 0] bbuf_rd_data;
    wire                    bbuf_rd_en;
    
    wire    [PE_NUM -1 : 0] switch_d;
    wire    [PE_NUM -1 : 0] switch_p;
    wire    [PE_NUM -1 : 0] switch_i;
    wire    [PE_NUM -1 : 0] switch_a;
    wire                    switch_b;

    wire    [PE_NUM -1 : 0] pe_done;

    wire    [bw(PE_NUM / 4) -1 : 0] rd_sel;
    
    wire    [3 : 0] conf_layer_type;
    wire    [3 : 0] conf_in_ch_seg;
    wire    [3 : 0] conf_out_ch_seg;
    wire    [7 : 0] conf_in_img_width;
    wire    [7 : 0] conf_out_img_width;
    wire            conf_pooling; 
    wire            conf_relu;
    wire            conf_depool;
    
    top_control#(
        .PE_NUM (PE_NUM )
    ) control_inst (
        .clk    (clk    ),
        .rst    (rst    ),

        .ins_valid  (ins_valid  ),
        .ins_ready  (ins_ready  ),
        .ins        (ins        ),

        .working    (working    ),

        .ddr2pe_ins_valid   (ddr2pe_ins_valid   ),
        .ddr2pe_ins_ready   (ddr2pe_ins_ready   ),
        .ddr2pe_ins         (ddr2pe_ins         ),

        .pe_ins_valid       (pe_ins_valid       ),
        .pe_ins_ready       (pe_ins_ready       ),
        .pe_ins             (pe_ins             ),

        .pe2ddr_ins_valid   (pe2ddr_ins_valid   ),
        .pe2ddr_ins_ready   (pe2ddr_ins_ready   ),
        .pe2ddr_ins         (pe2ddr_ins         ),

        .rx_done_buf_id (rx_done_buf_id     ),
        .rx_done_opcode (rx_done_opcode     ),
        .rx_done_pulse  (rx_done_pulse      ),
    
        .conf_layer_type    (conf_layer_type    ),
        .conf_in_ch_seg     (conf_in_ch_seg     ),
        .conf_out_ch_seg    (conf_out_ch_seg    ),
        .conf_in_img_width  (conf_in_img_width  ),
        .conf_out_img_width (conf_out_img_width ),
        .conf_pooling       (conf_pooling       ), 
        .conf_relu          (conf_relu          ),
        .conf_depool        (conf_depool        ),
    
        .switch_d           (switch_d           ),
        .switch_p           (switch_p           ),
        .switch_i           (switch_i           ),
        .switch_a           (switch_a           ),
        .switch_b           (switch_b           ),
                
        .pe_done            (pe_done            )
    );
 
    ddr2pe#(
        .BUF_DEPTH  (BUF_DEPTH  ),
        .IDX_DEPTH  (IDX_DEPTH  ),
        .PE_NUM     (PE_NUM     )
    ) ddr2pe_inst (
        .clk            (clk                ),
        .rst            (rst                ),
    
        .layer_type     (conf_layer_type    ),
        .in_img_width   (conf_in_img_width  ),
        .out_img_width  (conf_out_img_width ),
        .in_ch_seg      (conf_in_ch_seg     ),
        .out_ch_seg     (conf_out_ch_seg    ),
        .depool         (conf_depool        ),
    
        .ins_valid      (ddr2pe_ins_valid   ),
        .ins_ready      (ddr2pe_ins_ready   ),
        .ins            (ddr2pe_ins         ),

        .rx_done_buf_id (rx_done_buf_id     ),
        .rx_done_opcode (rx_done_opcode     ),
        .rx_done_pulse  (rx_done_pulse      ),
    
        .ddr1_data      (ddr1_in_data       ),
        .ddr1_valid     (ddr1_in_valid      ),
        .ddr1_ready     (ddr1_in_ready      ),

        .ddr1_addr      (ddr1_in_addr       ),
        .ddr1_size      (ddr1_in_size       ),
        .ddr1_addr_valid(ddr1_in_addr_valid ),
        .ddr1_addr_ready(ddr1_in_addr_ready ),

        .ddr2_data      (ddr2_in_data       ),
        .ddr2_valid     (ddr2_in_valid      ),
        .ddr2_ready     (ddr2_in_ready      ),

        .ddr2_addr      (ddr2_in_addr       ),
        .ddr2_size      (ddr2_in_size       ),
        .ddr2_addr_valid(ddr2_in_addr_valid ),
        .ddr2_addr_ready(ddr2_in_addr_ready ),
    
        .idx_wr_data    (idx_wr_data        ),
        .idx_wr_addr    (idx_wr_addr        ),
        .idx_wr_en      (idx_wr_en          ),
    
        .dbuf_wr_addr   (dbuf_wr_addr       ),
        .dbuf_wr_data   (dbuf_wr_data       ),
        .dbuf_wr_en     (dbuf_wr_en         ),
    
        .pbuf_wr_addr   (pbuf_wr_addr       ),
        .pbuf_wr_data   (pbuf_wr_data       ),
        .pbuf_wr_en     (pbuf_wr_en         ),
    
        .bbuf_acc_en    (bbuf_acc_en        ),
        .bbuf_acc_new   (bbuf_acc_new       ),
        .bbuf_acc_addr  (bbuf_acc_addr      ),
        .bbuf_acc_data  (bbuf_acc_data      ),
    
        .abuf_wr_addr   (abuf_wr_addr       ),
        .abuf_wr_data   (abuf_wr_data       ),
        .abuf_wr_data_en(abuf_wr_data_en    ),
        .abuf_wr_tail   (abuf_wr_tail       ),
        .abuf_wr_tail_en(abuf_wr_tail_en    ),
    
        .bbuf_wr_addr   (bbuf_wr_addr       ),
        .bbuf_wr_data   (bbuf_wr_data       ),
        .bbuf_wr_data_en(bbuf_wr_data_en    ),
        .bbuf_wr_tail   (bbuf_wr_tail       ),
        .bbuf_wr_tail_en(bbuf_wr_tail_en    )
    );
    
    pe_array#(
        .BUF_DEPTH  (BUF_DEPTH  ),
        .IDX_DEPTH  (IDX_DEPTH  ),
        .PE_NUM     (PE_NUM     )
    ) pe_array_inst (
        .clk        (clk            ),
        .rst        (rst            ),
        
        .layer_type (conf_layer_type),
    
        .switch_d   (switch_d       ),
        .switch_p   (switch_p       ),
        .switch_i   (switch_i       ),
        .switch_a   (switch_a       ),
        .switch_b   (switch_b       ),
    
        .ins_valid  (pe_ins_valid   ),
        .ins_ready  (pe_ins_ready   ),
        .ins        (pe_ins         ),
        .done       (pe_done        ),
    
        .rd_sel     (rd_sel         ),
    
        .idx_wr_data    (idx_wr_data        ),
        .idx_wr_addr    (idx_wr_addr        ),
        .idx_wr_en      (idx_wr_en          ),
    
        .dbuf_wr_addr   (dbuf_wr_addr       ),
        .dbuf_wr_data   (dbuf_wr_data       ),
        .dbuf_wr_en     (dbuf_wr_en         ),
    
        .pbuf_wr_addr   (pbuf_wr_addr       ),
        .pbuf_wr_data   (pbuf_wr_data       ),
        .pbuf_wr_en     (pbuf_wr_en         ),
    
        .bbuf_acc_en    (bbuf_acc_en        ),
        .bbuf_acc_new   (bbuf_acc_new       ),
        .bbuf_acc_addr  (bbuf_acc_addr      ),
        .bbuf_acc_data  (bbuf_acc_data      ),
    
        .abuf_wr_addr   (abuf_wr_addr       ),
        .abuf_wr_data   (abuf_wr_data       ),
        .abuf_wr_data_en(abuf_wr_data_en    ),
        .abuf_wr_tail   (abuf_wr_tail       ),
        .abuf_wr_tail_en(abuf_wr_tail_en    ),
        
        .abuf_rd_addr   (abuf_rd_addr       ),
        .abuf_rd_data   (abuf_rd_data       ),
        .abuf_rd_en     (abuf_rd_en         ),
    
        .bbuf_wr_addr   (bbuf_wr_addr       ),
        .bbuf_wr_data   (bbuf_wr_data       ),
        .bbuf_wr_data_en(bbuf_wr_data_en    ),
        .bbuf_wr_tail   (bbuf_wr_tail       ),
        .bbuf_wr_tail_en(bbuf_wr_tail_en    ),
        
        .bbuf_rd_addr   (bbuf_rd_addr       ),
        .bbuf_rd_data   (bbuf_rd_data       ),
        .bbuf_rd_en     (bbuf_rd_en         )
    );
    
    pe2ddr#(
        .BUF_DEPTH  (BUF_DEPTH  ),
        .PE_NUM     (PE_NUM     )
    ) pe2ddr_inst (
        .clk            (clk                ),
        .rst            (rst                ),
        
        .layer_type     (conf_layer_type    ),
        .out_ch_seg     (conf_out_ch_seg    ),
        .img_width      (conf_out_img_width ),
        .pooling        (conf_pooling       ),
        .relu           (conf_relu          ),
        
        .ins            (pe2ddr_ins         ),
        .ins_ready      (pe2ddr_ins_ready   ),
        .ins_valid      (pe2ddr_ins_valid   ),
        
        .rd_sel         (rd_sel             ),
    
        .abuf_rd_addr   (abuf_rd_addr       ),
        .abuf_rd_data   (abuf_rd_data       ),
        .abuf_rd_en     (abuf_rd_en         ),
        
        .bbuf_rd_addr   (bbuf_rd_addr       ),
        .bbuf_rd_data   (bbuf_rd_data       ),
        .bbuf_rd_en     (bbuf_rd_en         ),
    
        .ddr1_data      (ddr1_out_data      ),
        .ddr1_valid     (ddr1_out_valid     ),
        .ddr1_ready     (ddr1_out_ready     ),
                         
        .ddr1_addr      (ddr1_out_addr      ),
        .ddr1_size      (ddr1_out_size      ),
        .ddr1_addr_valid(ddr1_out_addr_valid),
        .ddr1_addr_ready(ddr1_out_addr_ready),

        .ddr2_data      (ddr2_out_data      ),
        .ddr2_valid     (ddr2_out_valid     ),
        .ddr2_ready     (ddr2_out_ready     ),

        .ddr2_addr      (ddr2_out_addr      ),
        .ddr2_size      (ddr2_out_size      ),
        .ddr2_addr_valid(ddr2_out_addr_valid),
        .ddr2_addr_ready(ddr2_out_addr_ready)
    );
    
endmodule