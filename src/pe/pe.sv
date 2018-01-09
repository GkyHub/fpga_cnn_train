import  GLOBAL_PARAM::DATA_W;
import  GLOBAL_PARAM::BATCH;
import  GLOBAL_PARAM::RES_W;
import  GLOBAL_PARAM::DATA_W;
import  GLOBAL_PARAM::TAIL_W;
import  GLOBAL_PARAM::IDX_W;
import  GLOBAL_PARAM::bw;

module pe#(
    parameter   GRP_ID_X    = 0,
    parameter   GRP_ID_Y    = 0,
    parameter   BUF_DEPTH   = 256,
    parameter   IDX_DEPTH   = 256,
    parameter   ADDR_W      = bw(BUF_DEPTH)
    )(
    input   clk,
    input   rst,
    
    input   switch_i,
    input   switch_d,
    input   switch_p,
    input   switch_a,
    
    input               start,
    output              done,
    input   [3  -1 : 0] mode,
    input   [8  -1 : 0] idx_cnt,  
    input   [8  -1 : 0] trip_cnt, 
    input               is_new,
    input   [4  -1 : 0] pad_code, 
    input               cut_y,
    
    input   [2 : 0][DATA_W * BATCH  -1 : 0] share_data_in,
    output  [DATA_W * BATCH -1 : 0] share_data_out,
    
    input   [IDX_W*2        -1 : 0] idx_wr_data,
    input   [bw(IDX_DEPTH)  -1 : 0] idx_wr_addr,
    input                           idx_wr_en,
    
    input   [bw(BUF_DEPTH)  -1 : 0] dbuf_wr_addr,
    input   [DATA_W * BATCH -1 : 0] dbuf_wr_data,
    input                           dbuf_wr_en,
    
    input   [bw(BUF_DEPTH)  -1 : 0] pbuf_wr_addr,
    input   [DATA_W * BATCH -1 : 0] pbuf_wr_data,
    input                           pbuf_wr_en,
    
    input   [ADDR_W         -1 : 0] abuf_wr_addr,
    input   [BATCH * DATA_W -1 : 0] abuf_wr_data,
    input                           abuf_wr_data_en,
    input   [BATCH * TAIL_W -1 : 0] abuf_wr_tail,
    input                           abuf_wr_tail_en,    
    input   [bw(BUF_DEPTH)  -1 : 0] abuf_rd_addr,
    output  [BATCH * RES_W  -1 : 0] abuf_rd_data,
    input                           abuf_rd_en
    );
    
//=============================================================================
// Address Generation Unit
//=============================================================================
    
    wire    [ADDR_W     -1 : 0] dbuf_addr;  
    wire                        dbuf_mask;  
    wire    [2          -1 : 0] dbuf_mux;   
    
    wire    [ADDR_W     -1 : 0] pbuf_addr;  
    wire    [bw(BATCH)  -1 : 0] pbuf_sel;

    wire                        mac_new_acc;
    
    wire    [ADDR_W     -1 : 0] abuf_addr;  
    wire    [BATCH      -1 : 0] abuf_acc_en;
    wire                        abuf_acc_new;
    
    wire    [2          -1 : 0] conf_mode;
    
    pe_agu#(
        .ADDR_W     (ADDR_W     ),
        .IDX_DEPTH  (IDX_DEPTH  ),
        .GRP_ID_X   (GRP_ID_X   ),
        .GRP_ID_Y   (GRP_ID_Y   )
    ) agu_inst (
        .clk            (clk            ),
        .rst            (rst            ),
    
        .switch_idx_buf (switch_i       ), 
    
        .start          (start          ),
        .mode           (mode           ),
        .done           (done           ),
        .idx_cnt        (idx_cnt        ),  
        .trip_cnt       (trip_cnt       ), 
        .is_new         (is_new         ),
        .pad_code       (pad_code       ), 
        .cut_y          (cut_y          ),
        .conf_mode      (conf_mode      ),
    
        .idx_wr_data    (idx_wr_data    ),
        .idx_wr_addr    (idx_wr_addr    ),
        .idx_wr_en      (idx_wr_en      ),
            
        .dbuf_addr      (dbuf_addr      ),
        .dbuf_mask      (dbuf_mask      ),
        .dbuf_mux       (dbuf_mux       ), 
            
        .pbuf_addr      (pbuf_addr      ),
        .pbuf_sel       (pbuf_sel       ),

        .mac_new_acc    (mac_new_acc    ),
    
        .abuf_addr      (abuf_addr      ),  
        .abuf_acc_en    (abuf_acc_en    ),
        .abuf_acc_new   (abuf_acc_new   )
    );
    
//=============================================================================
// Datapath
//=============================================================================
    
    wire    [BATCH  -1 : 0][DATA_W -1 : 0] data_vec;
    wire    [BATCH  -1 : 0][DATA_W -1 : 0] param_vec;
    wire    [BATCH  -1 : 0][RES_W  -1 : 0] res_vec;
    wire    [RES_W  -1 : 0] res_sca;
    
    // parameter selection
    reg     [BATCH  -1 : 0][DATA_W -1 : 0] param_vec_sel_r;
    wire    [bw(BATCH)  -1 : 0] pbuf_sel_d;
    
    Pipe#(.DW(bw(BATCH)), .L(2)) pbuf_sel_pipe (.clk, .s(pbuf_sel), .d(pbuf_sel_d));
    
    genvar i;
    generate
        for (i = 0; i < BATCH; i = i + 1) begin: PARAM_SEL
            always @ (posedge clk) begin
                if (~conf_mode[1]) begin
                    param_vec_sel_r[i] <= param_vec[pbuf_sel_d];
                end
                else begin
                    param_vec_sel_r[i] <= param_vec[i];
                end
            end
        end
    endgenerate
    
    
    // data selection
    wire                dbuf_mask_d;  
    wire    [2  -1 : 0] dbuf_mux_d;
    reg     [BATCH  -1 : 0][DATA_W -1 : 0] data_vec_sel_r;
    
    assign  share_data_out = data_vec;
    
    Pipe#(.DW(3), .L(3)) dbuf_sel_pipe (.clk, 
        .s({dbuf_mask, dbuf_mux}), .d({dbuf_mask_d, dbuf_mux_d}));
    
    always @ (posedge clk) begin
        if (dbuf_mask_d) begin
            case(dbuf_mux)
            2'b00: data_vec_sel_r <= share_data_out;
            2'b01: data_vec_sel_r <= share_data_in[0];
            2'b10: data_vec_sel_r <= share_data_in[1];
            2'b11: data_vec_sel_r <= share_data_in[2];
            endcase
        end
        else begin
            data_vec_sel_r <= '0;
        end
    end    
    
    mac_array#(
        .BATCH  (BATCH  ),
        .DATA_W (DATA_W ),
        .RES_W  (RES_W  )
    ) mac_array_inst (
        .clk        (clk            ),
        .rst        (rst            ),
        
        .new_acc    (mac_new_acc    ),
        .vec_a      (data_vec_sel_r ),
        .vec_b      (param_vec_sel_r),
        
        .vec_out    (res_vec        ),
        .sca_out    (res_sca        )
    );
    
    reg     [BATCH  -1 : 0][RES_W  -1 : 0 ] res_vec_sel_r;
    
    generate
        for (i = 0; i < BATCH; i = i + 1) begin: RES_SEL
            always @ (posedge clk) begin
                if (conf_mode[1]) begin
                    res_vec_sel_r[i] <= res_sca;
                end
                else begin
                    res_vec_sel_r[i] <= res_vec[i];
                end
            end
        end
    endgenerate
    
    
//=============================================================================
// Buffers
//=============================================================================
    
    ping_pong_ram#(
        .DEPTH      (BUF_DEPTH      ),  
        .WIDTH      (DATA_W * BATCH ),   
        .RAM_TYPE   ("block"        )
    ) data_buffer (
        .clk    (clk            ),
        .rst    (rst            ),
        
        .switch (switch_d       ),
    
        .wr_addr(dbuf_wr_addr   ),
        .wr_data(dbuf_wr_data   ),
        .wr_en  (dbuf_wr_en     ),
    
        .rd_addr(dbuf_addr      ),
        .rd_data(data_vec       )
    );
    
    ping_pong_ram#(
        .DEPTH      (BUF_DEPTH      ),  
        .WIDTH      (DATA_W * BATCH ),   
        .RAM_TYPE   ("block"        )
    ) param_buffer (
        .clk    (clk            ),
        .rst    (rst            ),
        
        .switch (switch_p       ),
    
        .wr_addr(pbuf_wr_addr   ),
        .wr_data(pbuf_wr_data   ),
        .wr_en  (pbuf_wr_en     ),
    
        .rd_addr(pbuf_addr      ),
        .rd_data(param_vec      )
    );
    
    accum_buf#(
        .DEPTH      (BUF_DEPTH  ),
        .BATCH      (BATCH      ),
        .RAM_TYPE   ("block"    )
    ) acc_buffer (
        .clk    (clk            ),
        .rst    (rst            ),
    
        .switch (switch_a       ),
    
        .accum_en   (abuf_acc_en    ),
        .accum_new  ({BATCH{abuf_acc_new}}),
        .accum_addr (abuf_addr      ),
        .accum_data (res_vec_sel_r  ),
    
        .wr_addr    (abuf_wr_addr   ),
        .wr_data    (abuf_wr_data   ),
        .wr_data_en (abuf_wr_data_en),
        .wr_tail    (abuf_wr_tail   ),
        .wr_tail_en (abuf_wr_tail_en),
    
        .rd_addr    (abuf_rd_addr   ),
        .rd_data    (abuf_rd_data   ),
        .rd_en      (abuf_rd_en     )
    );
        
endmodule