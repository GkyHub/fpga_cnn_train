import GLOBAL_PARAM::bw; 

module adder_tree#(
    parameter   DATA_W  = 16,
    parameter   DATA_N  = 32,
    parameter   RES_W   = bw(DATA_N) + DATA_W
    )(
    input   clk,
    
    input   [DATA_N -1 : 0][DATA_W  -1 : 0] vec,
    output  [RES_W  -1 : 0] sum
    );
    
    `define SIGN_EXT(X, H, L) {{((H)-(L)){X[(L)-1]}}, X}
    
    reg signed  [RES_W  -1 : 0] local_res[DATA_N*2-2 : 0];
    
    assign  sum = local_res[0];
    
    generate
        genvar i;
        for (i = 0; i < DATA_N - 1; i = i + 1) begin: HEAP
            always @ (posedge clk) begin
                local_res[i] <= local_res[i*2+1] + local_res[i*2+2];
            end
        end
        
        for (i = 0; i < DATA_N; i = i + 1) begin: INPUT
            
            wire    [DATA_W -1 : 0] op = vec[i*DATA_W+:DATA_W];
            
            always @ (posedge clk) begin
                local_res[i+DATA_N-1] = `SIGN_EXT(op, RES_W, DATA_W);
            end
        end
    endgenerate
    
endmodule