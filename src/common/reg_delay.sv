module RQ#(
    parameter   DW  = 1,
    parameter   L   = 4
    )(
    input   clk,
    input   rst,
    
    input          [DW-1:0] s,
    output  [L-1:0][DW-1:0] d
    );
    
    reg [L-1:0][DW-1:0] r;
    assign d = r;
    
    always @ (posedge clk) begin: DELAY
        int i;
        
        if (rst) begin
            for (i = 0; i < L; i++) begin
                r[i] <= 0;
            end
        end
        else begin
            r[0] <= s;
            for (i = 1; i < L; i++) begin
                r[i] <= r[i-1];
            end
        end
    
    end: DELAY
    
endmodule

module Q#(
    parameter   DW  = 1,
    parameter   L   = 4
    )(
    input   clk,
    
    input          [DW-1:0] s,
    output  [L-1:0][DW-1:0] d
    );
    
    reg [L-1:0][DW-1:0] r;
    assign d = r;
    
    always @ (posedge clk) begin: DELAY
    
        int i;
        r[0] <= s;
        for (i = 1; i < L; i++) begin
            r[i] <= r[i-1];
        end
    
    end: DELAY
    
endmodule

module RPipe#(
    parameter   DW  = 1,
    parameter   L   = 4
    )(
    input   clk,
    input   rst,
    
    input   [DW-1:0] s,
    output  [DW-1:0] d
    );
    
    reg [L-1:0][DW-1:0] r;
    assign d = r[L-1];
    
    always @ (posedge clk) begin: DELAY
        int i;
        
        if (rst) begin
            for (i = 0; i < L; i++) begin
                r[i] <= 0;
            end
        end
        else begin
            r[0] <= s;
            for (i = 1; i < L; i++) begin
                r[i] <= r[i-1];
            end
        end
    
    end: DELAY
    
endmodule

module Pipe#(
    parameter   DW  = 1,
    parameter   L   = 4
    )(
    input   clk,
    
    input   [DW-1:0] s,
    output  [DW-1:0] d
    );
    
    reg [L-1:0][DW-1:0] r;
    assign d = r[L-1];
    
    always @ (posedge clk) begin: DELAY
    
        int i;
        r[0] <= s;
        for (i = 1; i < L; i++) begin
            r[i] <= r[i-1];
        end
    
    end: DELAY
    
endmodule

module RPipeEn#(
    parameter   DW  = 1,
    parameter   L   = 4
    )(
    input   clk,
    input   rst,
    input   clk_en,
    
    input   [DW-1:0] s,
    output  [DW-1:0] d
    );
    
    reg [L-1:0][DW-1:0] r;
    assign d = r[L-1];
    
    always @ (posedge clk) begin: DELAY
        int i;
        
        if (rst) begin
            for (i = 0; i < L; i++) begin
                r[i] <= 0;
            end
        end
        else if (clk_en) begin
            r[0] <= s;
            for (i = 1; i < L; i++) begin
                r[i] <= r[i-1];
            end
        end
    
    end: DELAY
    
endmodule

module PipeEn#(
    parameter   DW  = 1,
    parameter   L   = 4
    )(
    input   clk,
    input   clk_en,
    
    input   [DW-1:0] s,
    output  [DW-1:0] d
    );
    
    reg [L-1:0][DW-1:0] r;
    assign d = r[L-1];
    
    always @ (posedge clk) begin: DELAY
    
        int i;
        if (clk_en) begin
            r[0] <= s;
            for (i = 1; i < L; i++) begin
                r[i] <= r[i-1];
            end
        end
    end: DELAY
    
endmodule