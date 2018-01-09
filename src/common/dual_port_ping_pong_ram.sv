import GLOBAL_PARAM::bw;

module dual_port_ping_pong_ram#(
    parameter   DEPTH   = 256,
    parameter   ADDR_W  = bw(DEPTH),    // please do not change this parameter
    parameter   WIDTH   = 512,
    parameter   RAM_TYPE= "block"
    )(
    input   clk,
    input   rst,
    
    input   switch,
    
    // port A
    input   [ADDR_W -1 : 0] a_wr_addr,
    input   [WIDTH  -1 : 0] a_wr_data,
    input                   a_wr_en,    
    input   [ADDR_W -1 : 0] a_rd_addr,
    output  [WIDTH  -1 : 0] a_rd_data,
    input                   a_rd_en,
    
    // port B
    input   [ADDR_W -1 : 0] b_wr_addr,
    input   [WIDTH  -1 : 0] b_wr_data,
    input                   b_wr_en,    
    input   [ADDR_W -1 : 0] b_rd_addr,
    output  [WIDTH  -1 : 0] b_rd_data,
    input                   b_rd_en
    );
    
    reg     flag_r = 1'b0;
    
    always @ (posedge clk) begin
        if (switch) begin
            flag_r <= ~flag_r;
        end
    end
    
    reg     [ADDR_W -1 : 0] wr_addr_1_r, wr_addr_2_r;
    reg     [ADDR_W -1 : 0] rd_addr_1_r, rd_addr_2_r;
    reg     [WIDTH  -1 : 0] wr_data_1_r, wr_data_2_r;
    reg     [WIDTH  -1 : 0] a_rd_data_r, b_rd_data_r;
    reg     wr_en_1_r, wr_en_2_r;
    
    wire    [WIDTH  -1 : 0] rd_data_1, rd_data_2;
    
    always @ (posedge clk) begin
        wr_addr_1_r <= flag_r ? a_wr_addr : b_wr_addr;
        wr_addr_2_r <= flag_r ? b_wr_addr : a_wr_addr;
        
        wr_data_1_r <= flag_r ? a_wr_data : b_wr_data;
        wr_data_2_r <= flag_r ? b_wr_data : a_wr_data;
        
        wr_en_1_r   <= flag_r ? a_wr_en : b_wr_en;
        wr_en_2_r   <= flag_r ? b_wr_en : a_wr_en;
    end
    
    always @ (posedge clk) begin
        if (flag_r) begin
            rd_addr_1_r <= a_rd_en ? a_rd_addr : rd_addr_1_r;
            rd_addr_2_r <= b_rd_en ? b_rd_addr : rd_addr_2_r;
        end
        else begin
            rd_addr_2_r <= a_rd_en ? a_rd_addr : rd_addr_2_r;
            rd_addr_1_r <= b_rd_en ? b_rd_addr : rd_addr_1_r;
        end
        
        if (a_rd_en) begin
             a_rd_data_r <= flag_r ? rd_data_1 : rd_data_2;
        end
        
        if (b_rd_en) begin
            b_rd_data_r <= flag_r ? rd_data_2 : rd_data_1;
        end
    end
    
    sdp_sync_ram #(
        .NB_COL         (1                  ),  
        .COL_WIDTH      (WIDTH              ),  
        .RAM_DEPTH      (DEPTH * 2          ),  
        .RAM_PERFORMANCE("HIGH_PERFORMANCE" ), 
        .RAM_TYPE       (RAM_TYPE           ), 
        .INIT_FILE      (""                 )  
    ) ram_inst_1 (
        .addra  ({flag_r, wr_addr_1_r}  ),
        .addrb  ({~flag_r, rd_addr_1_r} ),
        .dina   (wr_data_1_r            ), 
        .clka   (clk                    ), 
        .wea    (wr_en_1_r              ),  
        .enb    (flag_r ? a_rd_en : b_rd_en),  
        .rstb   (rst                    ), 
        .doutb  (rd_data_1              ) 
    );
    
    sdp_sync_ram #(
        .NB_COL         (1                  ),  
        .COL_WIDTH      (WIDTH              ),  
        .RAM_DEPTH      (DEPTH * 2          ),  
        .RAM_PERFORMANCE("HIGH_PERFORMANCE" ),
        .RAM_TYPE       (RAM_TYPE           ),
        .INIT_FILE      (""                 ) 
    ) ram_inst_2 (
        .addra  ({flag_r, wr_addr_2_r}  ),
        .addrb  ({~flag_r, rd_addr_2_r} ),
        .dina   (wr_data_2_r            ), 
        .clka   (clk                    ), 
        .wea    (wr_en_2_r              ),  
        .enb    (flag_r ? b_rd_en : a_rd_en),  
        .rstb   (rst                    ), 
        .doutb  (rd_data_2              ) 
    );
    
    assign  a_rd_data = a_rd_data_r;
    assign  b_rd_data = b_rd_data_r;
    
endmodule