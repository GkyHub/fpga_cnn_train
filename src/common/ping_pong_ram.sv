import GLOBAL_PARAM::bw;

module ping_pong_ram#(
    parameter   DEPTH   = 256,
    parameter   ADDR_W  = bw(DEPTH),    // please do not change this parameter
    parameter   WIDTH   = 512,
    parameter   RAM_TYPE= "block"
    )(
    input   clk,
    input   rst,
    
    input   switch,
    
    input   [ADDR_W -1 : 0] wr_addr,
    input   [WIDTH  -1 : 0] wr_data,
    input                   wr_en,
    
    input   [ADDR_W -1 : 0] rd_addr,
    output  [WIDTH  -1 : 0] rd_data
    );
    
    reg flag_r = 0;
    
    always @ (posedge clk) begin
        if (switch) begin
            flag_r <= ~flag_r;
        end
    end
    
    sdp_sync_ram #(
        .NB_COL         (1                  ),  
        .COL_WIDTH      (WIDTH              ),  
        .RAM_DEPTH      (DEPTH * 2          ),  
        .RAM_PERFORMANCE("HIGH_PERFORMANCE" ),  // Select "HIGH_PERFORMANCE" with 2 cycle read delay
        .RAM_TYPE       (RAM_TYPE           ),  
        .INIT_FILE      (""                 )   // initialize to all zero
    ) ram_inst (
        .addra  ({flag_r, wr_addr}  ),
        .addrb  ({~flag_r, rd_addr} ),
        .dina   (wr_data            ), 
        .clka   (clk                ), 
        .wea    (wr_en              ),  
        .enb    (1'b1               ),  
        .rstb   (rst                ), 
        .doutb  (rd_data            ) 
    );
    
endmodule