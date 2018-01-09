import  GLOBAL_PARAM::DATA_W;
import  GLOBAL_PARAM::TAIL_W;
import  GLOBAL_PARAM::BATCH;
import  GLOBAL_PARAM::RES_W;
import  GLOBAL_PARAM::IDX_W;
import  GLOBAL_PARAM::bw;
import  INS_CONST::INST_W;

(* dont_touch = "true" *)
module pe_array#(
    parameter   PE_NUM      = 32,
    parameter   BUF_DEPTH   = 256,
    parameter   IDX_DEPTH   = 256,
    parameter   ADDR_W      = bw(BUF_DEPTH)
    )(
    input   clk,
    input   rst,
    
    // layer type
    input   [3 : 0] layer_type,
    
    // PE control interface
    input   [PE_NUM -1 : 0] switch_d,   // switch the ping pong buffer data
    input   [PE_NUM -1 : 0] switch_p,   // switch the ping pong buffer param
    input   [PE_NUM -1 : 0] switch_i,   // switch the ping pong buffer idx
    input   [PE_NUM -1 : 0] switch_a,   // switch the ping pong buffer accum
    input                   switch_b,
    
    input   [INST_W -1 : 0] ins,
    output                  ins_ready,
    input                   ins_valid,
    
    output  [PE_NUM -1 : 0] done,
    
    input   [bw(PE_NUM / 4) -1 : 0] rd_sel,
    
    input   [IDX_W*2        -1 : 0] idx_wr_data,
    input   [bw(IDX_DEPTH)  -1 : 0] idx_wr_addr,
    input   [PE_NUM         -1 : 0] idx_wr_en,
    
    input          [ADDR_W         -1 : 0] dbuf_wr_addr,
    input   [3 : 0][DATA_W * BATCH -1 : 0] dbuf_wr_data,
    input   [PE_NUM -1 : 0]                dbuf_wr_en,
    
    input          [ADDR_W         -1 : 0] pbuf_wr_addr,
    input   [3 : 0][DATA_W * BATCH -1 : 0] pbuf_wr_data,
    input   [PE_NUM -1 : 0]                pbuf_wr_en,
    
    input   [ADDR_W         -1 : 0] abuf_wr_addr,
    input   [BATCH * DATA_W -1 : 0] abuf_wr_data,
    input   [PE_NUM         -1 : 0] abuf_wr_data_en,
    input   [BATCH * TAIL_W -1 : 0] abuf_wr_tail,
    input   [PE_NUM         -1 : 0] abuf_wr_tail_en,
    input   [ADDR_W         -1 : 0] abuf_rd_addr,
    output  [3 : 0][BATCH * RES_W  -1 : 0] abuf_rd_data,
    input                           abuf_rd_en,
    
    input                   bbuf_acc_en,
    input                   bbuf_acc_new,
    input   [ADDR_W -1 : 0] bbuf_acc_addr,
    input   [RES_W  -1 : 0] bbuf_acc_data,
    
    input   [ADDR_W -1 : 0] bbuf_wr_addr,
    input   [DATA_W -1 : 0] bbuf_wr_data,
    input                   bbuf_wr_data_en,
    input   [TAIL_W -1 : 0] bbuf_wr_tail,
    input                   bbuf_wr_tail_en,     
    input   [ADDR_W -1 : 0] bbuf_rd_addr,
    output  [RES_W  -1 : 0] bbuf_rd_data,
    input                   bbuf_rd_en
    );
    
//=============================================================================
// receive instruction
//=============================================================================

    assign  ins_ready = 1'b1;

    reg     [8      -1 : 0] idx_cnt_r;
    reg     [8      -1 : 0] trip_cnt_r; 
    reg                     is_new_r;
    reg     [4      -1 : 0] pad_code_r; 
    reg                     cut_y_r;

    wire    [5 : 0] pe_id = ins[57:52];
    
    always @ (posedge clk) begin
        if (ins_valid) begin
            idx_cnt_r   <= ins[39:32];
            trip_cnt_r  <= ins[47:40];
            is_new_r    <= ins[58];
            pad_code_r  <= ins[51:48];
            cut_y_r     <= ins[59];
        end
    end
    
    reg     [PE_NUM -1 : 0] start_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            start_r <= '0;
        end
        else if (ins_valid) begin
            if (layer_type[0]) begin
                start_r <= 1 << pe_id;
            end
            else begin
                start_r <= 15 << (pe_id << 2);
            end
        end
        else begin
            start_r <= '0;
        end
    end
    
//=============================================================================
// pe array
//=============================================================================
    
    localparam GRP_NUM = PE_NUM / 4;
    
    wire    [GRP_NUM - 1 : 0][3 : 0][BATCH * RES_W - 1 : 0] grp_abuf_rd_data;
    reg     [3 : 0][BATCH * RES_W - 1 : 0] abuf_rd_data_r;
    
    always @ (posedge clk) begin
        if (abuf_rd_en) begin
            abuf_rd_data_r <= grp_abuf_rd_data[rd_sel];
        end
    end
    
    assign  abuf_rd_data = abuf_rd_data_r;
    
    genvar i, j;
    generate
        for (i = 0; i < GRP_NUM; i = i + 1) begin: GROUP
            wire    [1 : 0][1 : 0][DATA_W*BATCH -1 : 0] share_data;
        
            for (j = 0; j < 4; j = j + 1) begin: UNIT
                localparam x = j % 2;
                localparam y = j / 2;
            
                pe#(
                    .GRP_ID_X   (x          ),
                    .GRP_ID_Y   (y          ),
                    .BUF_DEPTH  (BUF_DEPTH  ),
                    .IDX_DEPTH  (IDX_DEPTH  )
                ) pe_inst (
                    .clk        (clk              ),
                    .rst        (rst              ),
                
                    .switch_i   (switch_i[i*4+j]  ),
                    .switch_d   (switch_d[i*4+j]  ),
                    .switch_p   (switch_p[i*4+j]  ),
                    .switch_a   (switch_a[i*4+j]  ),
                
                    .start      (start_r[i*4+j]   ),
                    .done       (done[i*4+j]      ),
                    .mode       (layer_type[2:0]  ),
                    .idx_cnt    (idx_cnt_r        ),  
                    .trip_cnt   (trip_cnt_r       ), 
                    .is_new     (is_new_r         ),
                    .pad_code   (pad_code_r       ), 
                    .cut_y      (cut_y_r          ),
                    
                    .share_data_in  ({share_data[1-y][1-x],
                                      share_data[1-y][x  ],
                                      share_data[y  ][1-x]} ),
                    .share_data_out (share_data[y][x]       ),
                
                    .idx_wr_data    (idx_wr_data                ),
                    .idx_wr_addr    (idx_wr_addr                ),
                    .idx_wr_en      (idx_wr_en[i*4+j]           ),
                
                    .dbuf_wr_addr   (dbuf_wr_addr               ),
                    .dbuf_wr_data   (dbuf_wr_data[j]            ),
                    .dbuf_wr_en     (dbuf_wr_en[i*4+j]          ),
                
                    .pbuf_wr_addr   (pbuf_wr_addr               ),
                    .pbuf_wr_data   (pbuf_wr_data[j]            ),
                    .pbuf_wr_en     (pbuf_wr_en[i*4+j]          ),
                
                    .abuf_wr_addr   (abuf_wr_addr               ),
                    .abuf_wr_data   (abuf_wr_data               ),
                    .abuf_wr_data_en(abuf_wr_data_en[i*4+j]     ),
                    .abuf_wr_tail   (abuf_wr_tail               ),
                    .abuf_wr_tail_en(abuf_wr_tail_en[i*4+j]     ),
                    .abuf_rd_addr   (abuf_rd_addr               ),
                    .abuf_rd_data   (grp_abuf_rd_data[i][j]     ),
                    .abuf_rd_en     (abuf_rd_en                 )
                );
            end
        end
    endgenerate

    accum_buf#(
        .DEPTH      (BUF_DEPTH      ),
        .BATCH      (1              ),
        .RAM_TYPE   ("distributed"  )
    ) bias_buf (
        .clk        (clk            ),
        .rst        (rst            ),
        
        .switch     (switch_b       ),
    
        .accum_en   (bbuf_acc_en    ),
        .accum_new  (bbuf_acc_new   ),
        .accum_addr (bbuf_acc_addr  ),
        .accum_data (bbuf_acc_data  ),
    
        .wr_addr    (bbuf_wr_addr   ),
        .wr_data    (bbuf_wr_data   ),
        .wr_data_en (bbuf_wr_data_en),
        .wr_tail    (bbuf_wr_tail   ),
        .wr_tail_en (bbuf_wr_tail_en),

        .rd_addr    (bbuf_rd_addr   ),
        .rd_data    (bbuf_rd_data   ),
        .rd_en      (bbuf_rd_en     )
    );
    
endmodule