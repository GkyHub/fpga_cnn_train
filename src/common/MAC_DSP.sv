//  Multiply-accumulate unit
//  The following code implements a parameterizable Multiply-accumulate unit
//  with synchronous load to reset the accumulator without losing a clock cycle
//  Size of inputs/output should be less than/equal to what is supported by the architecture else extra logic/dsps will be inferred
(* use_dsp = "yes" *) module MAC_DSP# (
    parameter SIZEIN = 16,   // width of the inputs
    parameter SIZEOUT = 40   // width of output
    )(
    input         clk,
    input         ce,
    input         sload,
    input signed  [SIZEIN   -1:0] a,
    input signed  [SIZEIN   -1:0] b,
    output signed [SIZEOUT  -1:0] accum_out
    );

    // Declare registers for intermediate values
    reg signed [SIZEIN-1:0]   a_reg, b_reg;
    reg                       sload_reg;
    reg signed [2*SIZEIN-1:0] mult_reg;
    reg signed [SIZEOUT-1:0]  adder_out, old_result;

    always @(sload_reg or adder_out) begin
        if (sload_reg)
            old_result <= 0;
        else
            // 'sload' is now and opens the accumulation loop.
            // The accumulator takes the next multiplier output
            // in the same cycle.
            old_result <= adder_out;
    end

    always @(posedge clk) begin
        if (ce) begin
            a_reg     <= a;
            b_reg     <= b;
            mult_reg  <= a_reg * b_reg;
            sload_reg <= sload;
            // Store accumulation result into a register
            adder_out <= old_result + mult_reg;
        end
    end

    // Output accumulation result
    assign accum_out = adder_out;

endmodule

				
				