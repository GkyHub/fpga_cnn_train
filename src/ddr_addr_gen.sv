module ddr_addr_gen#(
    parameter   DDR_ADDR_W  = 32,
    parameter   BURST_W     = 16
    )(
    input   clk,
    input   rst,
    
    input   start,
    output  done,
    input   [DDR_ADDR_W -1 : 0] st_addr,
    input   [BURST_W    -1 : 0] burst,
    input   [DDR_ADDR_W -1 : 0] step,
    input   [BURST_W    -1 : 0] burst_num,
    
    output  [DDR_ADDR_W -1 : 0] ddr_addr,
    output  [BURST_W    -1 : 0] ddr_size,
    output                      ddr_addr_valid,
    input                       ddr_addr_ready
    );
    
    reg     [BURST_W    -1 : 0] burst_r;
    reg     [DDR_ADDR_W -1 : 0] step_r;
    reg     [BURST_W    -1 : 0] burst_num_r;
    reg     [DDR_ADDR_W -1 : 0] ddr_addr_r;
    reg     [BURST_W    -1 : 0] burst_cnt_r;
    reg     done_r;
    
    reg     ddr_addr_valid_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            burst_r     <= 0;
            step_r      <= 0;
            burst_num_r <= 0;
        end
        else if (start) begin
            burst_r     <= burst;    
            step_r      <= step;     
            burst_num_r <= burst_num;
        end
    end   
    
    always @ (posedge clk) begin
        if (start) begin
            ddr_addr_r <= st_addr;
            burst_cnt_r<= 0;
        end
        else if (ddr_addr_ready && burst_cnt_r < burst_num_r) begin
            ddr_addr_r <= ddr_addr_r + step_r;
            burst_cnt_r<= burst_cnt_r + 1;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            ddr_addr_valid_r <= 1'b0;
        end
        else if (start) begin
            ddr_addr_valid_r <= 1'b1;
        end
        else if (burst_cnt_r == burst_num_r && ddr_addr_ready) begin
            ddr_addr_valid_r <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            done_r <= 1'b1;
        end
        else if (start) begin
            done_r <= 1'b0;
        end
        else if (burst_cnt_r >= burst_num_r) begin
            done_r <= 1'b1;
        end
    end
    
    assign  done            = done_r;
    assign  ddr_addr        = ddr_addr_r;
    assign  ddr_size        = burst_r;
    assign  ddr_addr_valid  = ddr_addr_valid_r;
    
endmodule