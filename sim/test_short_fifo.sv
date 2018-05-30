`timescale 1ns/1ns
module test_short_fifo;
    parameter DATA_W = 8;
    parameter DEPTH  = 16;

    reg clk, rst;

    initial begin
        clk <= 1'b1;
        rst <= 1'b1;
        #100
        rst <= 1'b0;
    end

    always #5 clk <= ~clk;

    reg     [DATA_W -1 : 0] wr_data;
    reg                     wr_valid;
    wire                    wr_ready;

    wire    [DATA_W -1 : 0] rd_data;
    wire                    rd_valid;
    reg                     rd_ready;

    short_fifo#(
        .DATA_W(DATA_W),
        .DEPTH (DEPTH )
    ) uut (
        .*
    );

    initial begin: write_thread
        wait(~rst);
        wr_valid <= 1'b0;
        @(posedge clk);
        while (1) begin
            @(posedge clk);
            if (wr_ready) begin
                wr_data  <= $random();
                wr_valid <= 1'b1;
            end
        end
    end

    initial begin:read_thread
        reg [7 : 0] th;
        wait(~rst);
        rd_ready <= 1'b0;
        while(1) begin
            @(posedge clk);
            th <= $random();
            if ((th > 8'd100) && rd_valid) begin
                rd_ready <= 1'b1;
            end
            else begin
                rd_ready <= 1'b0;
            end
        end
    end

endmodule