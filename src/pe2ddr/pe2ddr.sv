import  INS_CONST::INST_W;
import  GLOBAL_PARAM::*;

module pe2ddr#(
    parameter   BUF_DEPTH   = 256,
    parameter   PE_NUM      = 32,
    parameter   ADDR_W      = bw(BUF_DEPTH)
    )(
    input   clk,
    input   rst,
    
    input   [4      -1 : 0] layer_type,
    input   [4      -1 : 0] out_ch_seg,
    input   [8      -1 : 0] img_width,
    input                   pooling,
    input                   relu,
    
    input   [INST_W -1 : 0] ins,
    output                  ins_ready,
    input                   ins_valid,
    
    output  [bw(PE_NUM / 4) -1 : 0] rd_sel,
    
    output  [ADDR_W         -1 : 0] abuf_rd_addr,
    input   [3 : 0][BATCH * RES_W  -1 : 0] abuf_rd_data,
    output  abuf_rd_en,
    
    input   [ADDR_W -1 : 0] bbuf_rd_addr,
    output  [RES_W  -1 : 0] bbuf_rd_data,
    output  bbuf_rd_en,
    
    output  [DDR_W      -1 : 0] ddr1_data,
    output                      ddr1_valid,
    input                       ddr1_ready,
                                    
    output  [DDR_ADDR_W -1 : 0] ddr1_addr,
    output  [BURST_W    -1 : 0] ddr1_size,
    output                      ddr1_addr_valid,
    input                       ddr1_addr_ready,
                                    
    output  [DDR_W      -1 : 0] ddr2_data,
    output                      ddr2_valid,
    input                       ddr2_ready,
                                    
    output  [DDR_ADDR_W -1 : 0] ddr2_addr,
    output  [BURST_W    -1 : 0] ddr2_size,
    output                      ddr2_addr_valid,
    input                       ddr2_addr_ready
    );
    
    wire            dg_start;
    wire            dg_done;
    wire    [3 : 0] dg_conf_pix_num;
    wire    [3 : 0] dg_conf_row_num;
    wire    [5 : 0] dg_conf_shift;
    wire    [1 : 0] dg_conf_pe_sel;
    
    wire    [ADDR_W -1 : 0] dg_abuf_rd_addr;
    wire                    dg_abuf_rd_en;
    wire    [ADDR_W -1 : 0] dg_bbuf_rd_addr;
    wire                    dg_bbuf_rd_en;
    
    wire    [DDR_W  -1 : 0] dg_ddr2_data;
    wire                    dg_ddr2_valid;
    
    wire            ab_start;
    wire            ab_done;
    wire    [1 : 0] ab_conf_trans_type;
    wire    [7 : 0] ab_conf_trans_num;
    wire    [1 : 0] ab_conf_grp_sel;
    
    wire    [ADDR_W -1 : 0] ab_abuf_rd_addr;
    wire                    ab_abuf_rd_en;
    wire    [ADDR_W -1 : 0] ab_bbuf_rd_addr;
    wire                    ab_bbuf_rd_en;
    
    wire    [DDR_W  -1 : 0] ab_ddr2_data;
    wire                    ab_ddr2_valid;
    

    wire    path_sel;
    
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

//=============================================================================
// configuration
//=============================================================================
    
    pe2ddr_config#(
        .PE_NUM (PE_NUM )  
    ) pe2ddr_config_inst (
        .clk        (clk        ),
        .rst        (rst        ),
    
        .layer_type (layer_type ),
        .out_ch_seg (out_ch_seg ),
        .img_width  (img_width  ),
    
        .ins        (ins        ),
        .ins_ready  (ins_ready  ),
        .ins_valid  (ins_valid  ),
    
        .rd_sel     (rd_sel     ),
        .path_sel   (path_sel   ),
    
        .dg_start           (dg_start           ),
        .dg_done            (dg_done            ),
        .dg_conf_pix_num    (dg_conf_pix_num    ),
        .dg_conf_row_num    (dg_conf_row_num    ),
        .dg_conf_shift      (dg_conf_shift      ),
        .dg_conf_pe_sel     (dg_conf_pe_sel     ),

        .ab_start           (ab_start           ),
        .ab_done            (ab_done            ),
        .ab_conf_trans_type (ab_conf_trans_type ),
        .ab_conf_trans_num  (ab_conf_trans_num  ),
        .ab_conf_grp_sel    (ab_conf_grp_sel    ),
    
        .ddr1_start         (ddr1_start         ),
        .ddr1_done          (ddr1_done          ),
        .ddr1_st_addr       (ddr1_st_addr       ),
        .ddr1_burst         (ddr1_burst         ),
        .ddr1_step          (ddr1_step          ),
        .ddr1_burst_num     (ddr1_burst_num     ),
                             
        .ddr2_start         (ddr2_start         ),
        .ddr2_done          (ddr2_done          ),
        .ddr2_st_addr       (ddr2_st_addr       ),
        .ddr2_burst         (ddr2_burst         ),
        .ddr2_step          (ddr2_step          ),
        .ddr2_burst_num     (ddr2_burst_num     )
    );

//=============================================================================
// datapath
//=============================================================================

    pe2ddr_dg#(
        .BUF_DEPTH  (BUF_DEPTH  )
    ) ddr2pe_dg_inst (
        .clk            (clk                ),
        .rst            (rst                ),
    
        .start          (dg_start           ),
        .done           (dg_done            ),
        .conf_layer_type(layer_type         ),
        .conf_pooling   (pooling            ),
        .conf_relu      (relu               ),
        .conf_ch_num    (out_ch_seg         ),
        .conf_pix_num   (dg_conf_pix_num    ),
        .conf_row_num   (dg_conf_row_num    ),
        .conf_shift     (dg_conf_shift      ),
        .conf_pe_sel    (dg_conf_pe_sel     ),
    
        .abuf_rd_addr   (dg_abuf_rd_addr    ),
        .abuf_rd_data   (abuf_rd_data       ),
        .abuf_rd_en     (dg_abuf_rd_en      ),
        
        .bbuf_rd_addr   (dg_bbuf_rd_addr    ),
        .bbuf_rd_data   (bbuf_rd_data       ),
        .bbuf_rd_en     (dg_bbuf_rd_en      ),
        
        .ddr1_data      (ddr1_data          ),
        .ddr1_valid     (ddr1_valid         ),
        .ddr1_ready     (ddr1_ready         ),
        
        .ddr2_data      (dg_ddr2_data       ),
        .ddr2_valid     (dg_ddr2_valid      ),
        .ddr2_ready     (ddr2_ready         )
    );
    
    pe2ddr_ab#(
        .BUF_DEPTH  (BUF_DEPTH)
    ) pe2ddr_ab_inst (
        .clk            (clk                ),
        .rst            (rst                ),
    
        .start          (ab_start           ),
        .done           (ab_done            ),
        .conf_layer_type(layer_type         ),
        .conf_trans_type(ab_conf_trans_type ),
        .conf_trans_num (ab_conf_trans_num  ),
        .conf_grp_sel   (ab_conf_grp_sel    ),
    
        .abuf_rd_addr   (ab_abuf_rd_addr    ),
        .abuf_rd_data   (abuf_rd_data       ),
        .abuf_rd_en     (ab_abuf_rd_en      ),
    
        .bbuf_rd_addr   (ab_bbuf_rd_addr    ),
        .bbuf_rd_data   (bbuf_rd_data       ),
        .bbuf_rd_en     (ab_bbuf_rd_en      ),
    
        .ddr2_data      (ab_ddr2_data       ),
        .ddr2_valid     (ab_ddr2_valid      ),
        .ddr2_ready     (ddr2_ready         )
    );
    
//=============================================================================
// DDR addr generators
//============================================================================= 
    
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

//=============================================================================
// data and address mux
//=============================================================================
    
    reg     [DDR_W  -1 : 0] ddr2_data_r;
    reg                     ddr2_valid_r;
    
    always @ (posedge clk) begin
        if (ddr2_ready) begin
            ddr2_data_r <= path_sel ? ab_ddr2_data : dg_ddr2_data;
            ddr2_valid_r<= path_sel ? ab_ddr2_valid : dg_ddr2_valid;
        end
    end
    
    assign  ddr2_data = ddr2_data_r;
    assign  ddr2_valid = ddr2_valid_r;
    
    reg     [ADDR_W -1 : 0] abuf_rd_addr_r;
    reg     [ADDR_W -1 : 0] bbuf_rd_addr_r;
    
    assign  abuf_rd_en = path_sel ? ab_abuf_rd_en : dg_abuf_rd_en;
    assign  bbuf_rd_en = path_sel ? ab_bbuf_rd_en : dg_bbuf_rd_en;
    
    always @ (posedge clk) begin
        if (abuf_rd_en) begin
            abuf_rd_addr_r <= path_sel ? ab_abuf_rd_addr : dg_abuf_rd_addr;
        end
        if (bbuf_rd_en) begin
            bbuf_rd_addr_r <= path_sel ? ab_bbuf_rd_addr : dg_bbuf_rd_addr;
        end
    end
    
    assign  abuf_rd_addr = abuf_rd_addr_r;
    assign  bbuf_rd_addr = bbuf_rd_addr_r;
    
endmodule