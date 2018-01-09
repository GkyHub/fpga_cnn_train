`timescale 1ns/1ns

import GLOBAL_PARAM::*;

module test_accum_ram;
    
    localparam  DEPTH = 256;
    localparam  ADDR_W= 8;
    
    reg     clk, rst;
    
    always #5 clk <= ~clk;
    
    initial begin
        clk <= 1'b1;
        rst <= 1'b1;
        #100
        rst <= 1'b0;
    end
    
    reg     switch;
    reg     [BATCH  -1 : 0]                 accum_en;
    reg     [BATCH  -1 : 0]                 accum_new;
    reg     [ADDR_W -1 : 0]                 accum_addr;
    reg     [BATCH  -1 : 0][RES_W   -1 : 0] accum_data;
    int i;
    
    initial begin
        accum_en = '0;
        accum_new = '0;
        accum_addr = 0;
    
        for (i = 0; i < BATCH; i++) begin
            accum_data[i] = i;
        end
        
        wait(!rst);
        
        for (i = 0; i < 32; i++) begin
            @(posedge clk);
            accum_en = '1;
            accum_new= '1;
            accum_addr= accum_addr + 1; 
        end
        
        @(posedge clk);
        accum_addr = 0;
        accum_en = '0;
        
        for (i = 0; i < 32; i++) begin
            @(posedge clk);
            accum_en = '1;
            accum_new= '0;
            accum_addr= accum_addr + 1; 
        end
    end
    
    accum_buf#(
        .DEPTH(DEPTH)
    ) uut (
        .clk,
        .rst,
    
        .switch,
    
        // accumulation port
        .accum_en,
        .accum_new,
        .accum_addr,
        .accum_data,
    
        // load intermediate result port
        .wr_addr (       ),
        .wr_data (       ),
        .wr_en   (       ),
    
        // store result port
        .rd_addr (       ),
        .rd_data (       )
    );
    
endmodule