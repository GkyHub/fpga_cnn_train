`timescale 1ns/1ps

import  GLOBAL_PARAM::*;
import  INS_CONST::*;

(* dont_touch = "true" *)
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



	assign ins_ready = 1'b0;  
// =================== data and addr and size for send ====================== //
    localparam ADDR_1    = {{6'b000001}, {(DDR_ADDR_W-6){1'b0}}};
    localparam ADDR_2    = {{6'b000001}, {(DDR_ADDR_W-6){1'b0}}};
    localparam ADDR_3    = {{6'b000010}, {(DDR_ADDR_W-6){1'b0}}};
    localparam ADDR_4    = {{6'b000010}, {(DDR_ADDR_W-6){1'b0}}};
    localparam ADDR_5    = {{6'b000000}, {(DDR_ADDR_W-6){1'b0}}};
    localparam ADDR_6    = {{6'b000011}, {(DDR_ADDR_W-6){1'b0}}};

    localparam SEND_1    = { {(DDR_W/4){1'b0}}, {(DDR_W/4){1'b0}}, {(DDR_W/4){1'b1}}, {(DDR_W/4){1'b1}} };
    localparam SEND_2    = { {(DDR_W/4){1'b0}}, {(DDR_W/4){1'b0}}, {(DDR_W/4){1'b1}}, {(DDR_W/4){1'b1}} };
    localparam SEND_3    = { {(DDR_W/4){1'b1}}, {(DDR_W/4){1'b1}}, {(DDR_W/4){1'b0}}, {(DDR_W/4){1'b0}} };
    localparam SEND_4    = { {(DDR_W/4){1'b1}}, {(DDR_W/4){1'b1}}, {(DDR_W/4){1'b1}}, {(DDR_W/4){1'b1}} };
    localparam SEND_5    = { {(DDR_W/4){1'b1}}, {(DDR_W/4){1'b0}}, {(DDR_W/4){1'b0}}, {(DDR_W/4){1'b1}} };
    localparam SEND_6    = { {(DDR_W/4){1'b0}}, {(DDR_W/4){1'b1}}, {(DDR_W/4){1'b1}}, {(DDR_W/4){1'b0}} };

    localparam SIZE      = {{(BURST_W-6){1'b0}}, {6'b100000}}; 


// =========================== regs for output ============================== //
    reg                      ddr1_in_ready_r;
    reg  [DDR_ADDR_W -1 : 0] ddr1_in_addr_r;
    reg  [BURST_W    -1 : 0] ddr1_in_size_r;
    reg                      ddr1_in_addr_valid_r;
    
    reg                      ddr2_in_ready_r;
    reg  [DDR_ADDR_W -1 : 0] ddr2_in_addr_r;
    reg  [BURST_W    -1 : 0] ddr2_in_size_r;
    reg                      ddr2_in_addr_valid_r;
  
    reg  [DDR_W      -1 : 0] ddr1_out_data_r;
    reg                      ddr1_out_valid_r;
                                    
    reg  [DDR_ADDR_W -1 : 0] ddr1_out_addr_r;
    reg  [BURST_W    -1 : 0] ddr1_out_size_r;
    reg                      ddr1_out_addr_valid_r;
                                    
    reg  [DDR_W      -1 : 0] ddr2_out_data_r;
    reg                      ddr2_out_valid_r;

    reg  [DDR_ADDR_W -1 : 0] ddr2_out_addr_r;
    reg  [BURST_W    -1 : 0] ddr2_out_size_r;
    reg                      ddr2_out_addr_valid_r;

    assign ddr1_in_ready      = ddr1_in_ready_r;
    assign ddr1_in_addr       = ddr1_in_addr_r;
    assign ddr1_in_size       = ddr1_in_size_r;
    assign ddr1_in_addr_valid = ddr1_in_addr_valid_r;
    
    assign ddr2_in_ready      = ddr2_in_ready_r;
    assign ddr2_in_addr       = ddr2_in_addr_r;
    assign ddr2_in_size       = ddr2_in_size_r;
    assign ddr2_in_addr_valid = ddr2_in_addr_valid_r;
  
    assign ddr1_out_data       = ddr1_out_data_r;
    assign ddr1_out_valid      = ddr1_out_valid_r;                   
    assign ddr1_out_addr       = ddr1_out_addr_r;
    assign ddr1_out_size       = ddr1_out_size_r;
    assign ddr1_out_addr_valid = ddr1_out_addr_valid_r;
                                    
    assign ddr2_out_data       = ddr2_out_data_r;
    assign ddr2_out_valid      = ddr2_out_valid_r;
    assign ddr2_out_addr       = ddr2_out_addr_r;
    assign ddr2_out_size       = ddr2_out_size_r;
    assign ddr2_out_addr_valid = ddr2_out_addr_valid_r;


// ======================= regs and logic for receive ======================= //
    reg  [DDR_W-1 : 0] receive_1;
    reg  [DDR_W-1 : 0] receive_2;
    always @(posedge clk or posedge rst) begin
    	if (rst) begin
    		receive_1 <= {(DDR_W){1'b0}};
    	end
    	else if (ddr1_in_valid) begin
            if (ddr1_in_ready) begin
                receive_1       <= ddr1_in_data;
                ddr1_in_ready_r <= 1'b0;
            end
            else begin
                ddr1_in_ready_r <= 1'b1;
            end
    	end
    	else ddr1_in_ready_r <= 1'b1;
    end
    always @(posedge clk or posedge rst) begin
    	if (rst) begin
    		receive_2 <= {(DDR_W){1'b0}};
    	end
    	else if (ddr2_in_valid) begin
    		if (ddr2_in_ready) begin
                receive_2       <= ddr2_in_data;
                ddr2_in_ready_r <= 1'b0;
            end
            else begin
                ddr2_in_ready_r <= 1'b1;
            end
    	end
        else ddr2_in_ready_r <= 1'b1;
    end


// ========================== compare result ================================ //
    wire [5 : 0] compare_error;
	assign compare_error[0] = |(receive_1 ^ SEND_1);
	assign compare_error[1] = |(receive_2 ^ SEND_2);
	assign compare_error[2] = |(receive_1 ^ SEND_3);
	assign compare_error[3] = |(receive_2 ^ SEND_4);
	assign compare_error[4] = |(receive_1 ^ SEND_5);
	assign compare_error[5] = |(receive_2 ^ SEND_6);
    	

// ================================ ddr1 ==================================== //
    initial begin
    	ddr1_out_addr_valid_r <= 1'b0;
    	ddr1_out_valid_r      <= 1'b0;
    	ddr1_in_addr_valid_r  <= 1'b0;
    	ddr1_in_ready_r       <= 1'b0;

    	ddr1_in_size_r  <= SIZE;
    	ddr2_in_size_r  <= SIZE;
    	ddr1_out_size_r <= SIZE;
    	ddr2_out_size_r <= SIZE;

    	wait(ins_valid);

    	// ------------- logic of write ddr1 -------------- //

        #1000; 						// write data1 into ddr1
        @(posedge clk);
        ddr1_out_addr_r       <= ADDR_1;
        ddr1_out_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr1_out_addr_ready) begin
        	@(posedge clk);
        end 
        ddr1_out_addr_valid_r <= 1'b0;
        ddr1_out_data_r       <= SEND_1;
        #50;
        @(posedge clk);
        ddr1_out_valid_r      <= 1'b1;
        @(posedge clk);
        while (~ddr1_out_ready) begin
        	@(posedge clk);
        end 
        ddr1_out_valid_r      <= 1'b0;

        #1000; 						// write data3 into ddr1
        @(posedge clk);
        ddr1_out_addr_r       <= ADDR_3;
        ddr1_out_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr1_out_addr_ready) begin
        	@(posedge clk);
        end 
        ddr1_out_addr_valid_r <= 1'b0;
        #50;
        @(posedge clk);
        ddr1_out_data_r       <= SEND_3;
        ddr1_out_valid_r      <= 1'b1;
        @(posedge clk);
        while (~ddr1_out_ready) begin
        	@(posedge clk);
        end 
        ddr1_out_valid_r      <= 1'b0;

        #1000; 						// write data5 into ddr1
        @(posedge clk);
        ddr1_out_addr_r       <= ADDR_5;
        ddr1_out_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr1_out_addr_ready) begin
        	@(posedge clk);
        end 
        ddr1_out_addr_valid_r <= 1'b0;
        #50;
        @(posedge clk);
        ddr1_out_data_r       <= SEND_5;
        ddr1_out_valid_r      <= 1'b1;
        @(posedge clk);
        while (~ddr1_out_ready) begin
        	@(posedge clk);
        end 
        ddr1_out_valid_r      <= 1'b0;


        // -------------- logic of read ddr1 -------------- //
        #1000; 						// read data1 from ddr1
        @(posedge clk);
        ddr1_in_addr_r       <= ADDR_1;
        ddr1_in_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr1_in_addr_ready) begin
        	@(posedge clk);
        end 
        ddr1_in_addr_valid_r <= 1'b0;
       
        #1000; 						// read data3 from ddr1
        @(posedge clk);
        ddr1_in_addr_r       <= ADDR_3;
        ddr1_in_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr1_in_addr_ready) begin
        	@(posedge clk);
        end 
        ddr1_in_addr_valid_r <= 1'b0;

        #1000; 						// read data5 from ddr1
        @(posedge clk);
        ddr1_in_addr_r       <= ADDR_5;
        ddr1_in_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr1_in_addr_ready) begin
        	@(posedge clk);
        end 
        ddr1_in_addr_valid_r <= 1'b0;

    end


// ================================== ddr2 ================================== //

    initial begin
    	ddr2_out_addr_valid_r <= 1'b0;
    	ddr2_out_valid_r      <= 1'b0;
    	ddr2_in_addr_valid_r  <= 1'b0;
    	ddr2_in_ready_r       <= 1'b0;
       
        wait(ins_valid);

        // ------------- logic of write ddr2 -------------- //

        #1000;                      // write data2 into ddr2
        @(posedge clk);
        ddr2_out_addr_r       <= ADDR_2;
        ddr2_out_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr2_out_addr_ready) begin
            @(posedge clk);
        end 
        ddr2_out_addr_valid_r <= 1'b0;
        ddr2_out_data_r       <= SEND_2;
        #50;
        @(posedge clk);
        ddr2_out_valid_r      <= 1'b1;
        @(posedge clk);
        while (~ddr2_out_ready) begin
            @(posedge clk);
        end 
        ddr2_out_valid_r      <= 1'b0;

        #1000;                      // write data4 into ddr2
        @(posedge clk);
        ddr2_out_addr_r       <= ADDR_4;
        ddr2_out_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr2_out_addr_ready) begin
            @(posedge clk);
        end 
        ddr2_out_addr_valid_r <= 1'b0;
        #50;
        @(posedge clk);
        ddr2_out_data_r       <= SEND_4;
        ddr2_out_valid_r      <= 1'b1;
        @(posedge clk);
        while (~ddr2_out_ready) begin
            @(posedge clk);
        end 
        ddr2_out_valid_r      <= 1'b0;

        #1000;                      // write data6 into ddr2
        @(posedge clk);
        ddr2_out_addr_r       <= ADDR_6;
        ddr2_out_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr2_out_addr_ready) begin
            @(posedge clk);
        end 
        ddr2_out_addr_valid_r <= 1'b0;
        #50;
        @(posedge clk);
        ddr2_out_data_r       <= SEND_6;
        ddr2_out_valid_r      <= 1'b1;
        @(posedge clk);
        while (~ddr2_out_ready) begin
            @(posedge clk);
        end 
        ddr2_out_valid_r      <= 1'b0;


        // -------------- logic of read ddr2 -------------- //
        #1000;                      // read data2 from ddr2
        @(posedge clk);
        ddr2_in_addr_r       <= ADDR_2;
        ddr2_in_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr2_in_addr_ready) begin
            @(posedge clk);
        end 
        ddr2_in_addr_valid_r <= 1'b0;
       
        #1000;                      // read data4 from ddr2
        @(posedge clk);
        ddr2_in_addr_r       <= ADDR_4;
        ddr2_in_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr2_in_addr_ready) begin
            @(posedge clk);
        end 
        ddr2_in_addr_valid_r <= 1'b0;

        #1000;                      // read data6 from ddr2
        @(posedge clk);
        ddr2_in_addr_r       <= ADDR_6;
        ddr2_in_addr_valid_r <= 1'b1;
        @(posedge clk);
        while (~ddr2_in_addr_ready) begin
            @(posedge clk);
        end 
        ddr2_in_addr_valid_r <= 1'b0;

    end


endmodule
