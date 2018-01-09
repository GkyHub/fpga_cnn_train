`timescale 1ns/1ns

import GLOBAL_PARAM::*;
import INS_CONST::*;

module test_top;
    
    reg     clk;
    reg     rst;
    
    reg                     ins_valid;
    wire                    ins_ready;
    reg     [INST_W -1 : 0] ins;
    
    reg     [DDR_W      -1 : 0] ddr1_in_data;
    reg                         ddr1_in_valid;
    wire                        ddr1_in_ready;
    
    wire    [DDR_ADDR_W -1 : 0] ddr1_in_addr;
    wire    [BURST_W    -1 : 0] ddr1_in_size;
    wire                        ddr1_in_addr_valid;
    reg                         ddr1_in_addr_ready;
    
    reg     [DDR_W      -1 : 0] ddr2_in_data;
    reg                         ddr2_in_valid;
    wire                        ddr2_in_ready;
    
    wire    [DDR_ADDR_W -1 : 0] ddr2_in_addr;
    wire    [BURST_W    -1 : 0] ddr2_in_size;
    wire                        ddr2_in_addr_valid;
    reg                         ddr2_in_addr_ready;
    
    wire    working;
    
    always #5 clk <= ~clk;
    
    initial begin
        clk <= 1'b1;
        rst <= 1'b1;
        #100
        rst <= 1'b0;
    end

    fpga_cnn_train_top#(
        .PE_NUM (32     )
    ) uut (
        .clk                (clk                ),
        .rst                (rst                ),
                            
        .ins_valid          (ins_valid          ),
        .ins_ready          (ins_ready          ),
        .ins                (ins                ),
        
        .workgin            (working            ),
                            
        .ddr1_in_data       (ddr1_in_data       ),
        .ddr1_in_valid      (ddr1_in_valid      ),
        .ddr1_in_ready      (ddr1_in_ready      ),
                            
        .ddr1_in_addr       (ddr1_in_addr       ),
        .ddr1_in_size       (ddr1_in_size       ),
        .ddr1_in_addr_valid (ddr1_in_addr_valid ),
        .ddr1_in_addr_ready (ddr1_in_addr_ready ),  
                            
        .ddr2_in_data       (ddr2_in_data       ),
        .ddr2_in_valid      (ddr2_in_valid      ),
        .ddr2_in_ready      (ddr2_in_ready      ),
                            
        .ddr2_in_addr       (ddr2_in_addr       ),
        .ddr2_in_size       (ddr2_in_size       ),
        .ddr2_in_addr_valid (ddr2_in_addr_valid ),
        .ddr2_in_addr_ready (ddr2_in_addr_ready ),
        
        .ddr1_out_data      (),
        .ddr1_out_valid     (),
        .ddr1_out_ready     (),
        
        .ddr1_out_addr      (),
        .ddr1_out_size      (),
        .ddr1_out_addr_valid(),
        .ddr1_out_addr_ready(),
        
        .ddr2_out_data      (),
        .ddr2_out_valid     (),
        .ddr2_out_ready     (),
        
        .ddr2_out_addr      (),
        .ddr2_out_size      (),
        .ddr2_out_addr_valid(),
        .ddr2_out_addr_ready()
    );
    
    initial begin
        wait(~rst);
    end
    
endmodule