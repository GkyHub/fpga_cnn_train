module posedge2pulse(
    input   clk,
    input   rst,
    input   a,
    output  b
    );
    
    reg a_r;
    reg b_r;
    
    always @ (posedge clk) begin
        a_r <= rst ? 1'b1 : a;
        b_r <= rst ? 1'b0 : ({a_r, a} == 2'b01);
    end
    
    assign b = b_r;
    
endmodule