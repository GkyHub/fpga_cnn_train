module mac_array#(
    parameter   BATCH   = 32,
    parameter   DATA_W  = 8,
    parameter   RES_W   = 24
    )(
    input   clk,
    input   rst,
    
    input   new_acc,
    input   [BATCH  -1 : 0][DATA_W  -1 : 0] vec_a,
    input   [BATCH  -1 : 0][DATA_W  -1 : 0] vec_b,
    
    output  [BATCH  -1 : 0][RES_W   -1 : 0] vec_out,
    output  [RES_W  -1 : 0] sca_out
    );
    
    // parallel accumulator
    generate
        genvar i;
        for (i = 0; i < BATCH; i = i + 1) begin: ARR
            wire    [DATA_W -1 : 0] op_a, op_b;
            wire    [RES_W  -1 : 0] res;
            
            MAC_DSP#(
                .SIZEIN (DATA_W ),
                .SIZEOUT(RES_W  )
            ) mac_unit (
                .clk        (clk        ),
                .ce         (1'b1       ),
                .sload      (new_acc    ),
                .a          (vec_a[i]   ),
                .b          (vec_b[i]   ),
                .accum_out  (vec_out[i] )
            );
            
        end
    endgenerate
    
    // adder tree for inner-product
    adder_tree#(
        .DATA_W (RES_W      ),
        .DATA_N (BATCH      ),
        .RES_W  (RES_W      )
    ) adder_tree_inst (
        .clk    (clk        ),
        .vec    (vec_out    ),
        .sum    (sca_out    )
    );
    
    
endmodule