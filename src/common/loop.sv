module loop#(
    parameter   DATA_W  = 8,
    parameter   MODE    = "block"   // "block": last signal is the catch of counter return to 0
                                    // "comb":  last signal is combinational logic, align with cnt
    )(
    input   clk,
    input   rst,
    
    input   [DATA_W -1 : 0] lim,    // counter will count from 0 to lim iteratively
    
    input                   trig,   // counter work when trig asserts
    output  [DATA_W -1 : 0] cnt,
    output                  last    
    );
    
    reg     [DATA_W -1 : 0] cnt_r;
    reg                     last_r;
    
    assign  cnt = cnt_r;
    assign  last = last_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            cnt_r   <= 0;
        end
        else if (trig) begin
            cnt_r   <= (cnt_r == lim) ? 0 : (cnt_r + 1);
        end
    end
    
    generate
        if (MODE == "block") begin: BLOCK_MODE
        
            always @ (posedge clk) begin
                if (rst) begin
                    last_r <= 1'b0;
                end
                else if ((cnt_r == lim - 1) && trig) begin
                    last_r <= 1'b1;
                end
                else begin
                    last_r <= 1'b0;
                end
            end
            
        end
        else begin: COMB_MODE
            
            always_comb begin
                last_r <= (cnt_r == lim - 1);
            end
            
        end
    endgenerate

endmodule