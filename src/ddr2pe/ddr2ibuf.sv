import  GLOBAL_PARAM::DDR_W;
import  GLOBAL_PARAM::IDX_W;
import  GLOBAL_PARAM::bw;

module ddr2ibuf#(
    parameter   IDX_DEPTH   = 256,
    parameter   ADDR_W      = bw(IDX_DEPTH),
    parameter   PE_NUM      = 32
    )(
    input   clk,
    input   rst,
    
    // configuration port
    input                   conf_valid,
    output                  conf_ready,
    input   [4      -1 : 0] conf_mode,
    input   [8      -1 : 0] conf_idx_num,
    input   [PE_NUM -1 : 0] conf_mask,
    
    // ddr data stream port
    input   [DDR_W  -1 : 0] ddr_data,
    input                   ddr_valid,
    output                  ddr_ready,
    
    // pbuf write port
    output  [IDX_W*2-1 : 0] idx_wr_data,
    output  [ADDR_W -1 : 0] idx_wr_addr,
    output  [PE_NUM -1 : 0] idx_wr_en
    );
    
    localparam IDX_BATCH = DDR_W / IDX_W / 2;
    
    reg     [ADDR_W -1 : 0] idx_wr_addr_r;
    reg     [ADDR_W -1 : 0] idx_cnt_r;
    reg     [6      -1 : 0] batch_cnt_r;
    wire    [IDX_BATCH-1 : 0][IDX_W*2-1 : 0] ddr_data_arr;
    reg     ddr_ready_r;
    reg     [IDX_W*2-1 : 0] idx_wr_data_r;
    reg     [PE_NUM -1 : 0] idx_wr_en_r;
    
    always @ (posedge clk) begin
        if (conf_valid && conf_ready) begin
            batch_cnt_r <= 0;
        end
        else if (ddr_valid) begin
            batch_cnt_r <= (batch_cnt_r == IDX_BATCH-1) ? 0 : (batch_cnt_r + 1);
        end
    end
    
    always @ (posedge clk) begin
        if (conf_valid && conf_ready) begin
            idx_cnt_r <= 0;
        end
        else if (ddr_valid) begin
            idx_cnt_r <= idx_cnt_r + 1;
        end
    end
    
    // ready signal: ready when read a whole batch or the index are read done.
    always @ (posedge clk) begin
        if (rst) begin
            ddr_ready_r <= 1'b0;
        end
        else begin
            ddr_ready_r <= (batch_cnt_r == IDX_BATCH - 2) || (idx_cnt_r == conf_idx_num - 1);
        end
    end
    
    assign  ddr_ready = ddr_ready_r;
    
    // data selection
    assign  ddr_data_arr = ddr_data;
    
    always @ (posedge clk) begin
        if (conf_mode[2:1] != 2'b01) begin
            idx_wr_data_r = ddr_data_arr[batch_cnt_r];
        end
        else begin
            idx_wr_data_r = {ddr_data_arr[batch_cnt_r][IDX_W  -1 :     0], 
                           ddr_data_arr[batch_cnt_r][IDX_W*2-1 : IDX_W]};
        end
    end
    
    // address
    always @ (posedge clk) begin
        idx_wr_addr_r <= idx_cnt_r;
    end
    
    // write enable
    always @ (posedge clk) begin
        if (rst) begin
            idx_wr_en_r <= '0;
        end
        else if (ddr_valid) begin
            idx_wr_en_r <= conf_mask;
        end
        else begin
            idx_wr_en_r <= '0;
        end
    end
    
    // conf_ready signal
    reg     conf_ready_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            conf_ready_r <= 1'b1;
        end
        else if (conf_valid && conf_ready) begin
            conf_ready_r <= 1'b0;
        end
        else if (idx_cnt_r == conf_idx_num && ddr_valid) begin
            conf_ready_r <= 1'b1;
        end
    end
    
    assign  conf_ready = conf_ready_r;
    
    assign  idx_wr_en   = idx_wr_en_r;
    assign  idx_wr_data = idx_wr_data_r;
    assign  idx_wr_addr = idx_wr_addr_r;
    
endmodule