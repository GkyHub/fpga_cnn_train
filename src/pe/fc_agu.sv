import GLOBAL_PARAM::bw;
import GLOBAL_PARAM::IDX_W;
import GLOBAL_PARAM::BATCH;

module fc_agu#(
    parameter   ADDR_W  = 8
    )(
    input   clk,
    input   rst,
    
    input   start,
    output  done,
    input   [2  -1 : 0] conf_mode,
    input   [8  -1 : 0] conf_idx_cnt,   // number of idx to deal with
    input               conf_is_new,
    
    // index read port
    output  [ADDR_W     -1 : 0] idx_rd_addr,
    input   [IDX_W * 2  -1 : 0] idx,
    
    // buffer address generation port
    output  [ADDR_W     -1 : 0] dbuf_addr,  // data buffer address
    output                      dbuf_mask,  // padding mask
    output  [2          -1 : 0] dbuf_mux,   // data sharing mux
    
    output  [ADDR_W     -1 : 0] pbuf_addr,  // parameter buffer address
    output  [bw(BATCH)  -1 : 0] pbuf_sel,   // parameter scalar selection 
    
    output                      mac_new_acc,
    
    output  [ADDR_W     -1 : 0] abuf_addr,  // accumulate buffer address
    output  [BATCH      -1 : 0] abuf_acc_en,// enable mask
    output                      abuf_acc_new
    );
    
    reg     [ADDR_W     -1 : 0] idx_rd_addr_r;
    
    reg     [ADDR_W     -1 : 0] dbuf_addr_r;
    reg                         dbuf_mask_r;
    reg     [2          -1 : 0] dbuf_mux_r;
    
    reg     [ADDR_W     -1 : 0] pbuf_addr_r;
    reg     [bw(BATCH)  -1 : 0] pbuf_sel_r;
    
    reg     [ADDR_W     -1 : 0] abuf_addr_r;
    reg     [BATCH      -1 : 0] abuf_acc_en_r;
    reg                         abuf_acc_new_r;
    
    reg     idx_rd_done_r;
    
    wire    [10 -1 : 0][ADDR_W  -1 : 0] idx_rd_addr_d;
    wire    [7  -1 : 0][IDX_W   -1 : 0] idx_y_d;
    wire    [10 -1 : 0][1       -1 : 0] vld_d;
    
    wire    [IDX_W      -1 : 0] idx_x, idx_y;
    assign  {idx_y, idx_x} = idx;
    
    always @ (posedge clk) begin
        if (rst) begin
            idx_rd_addr_r <= 0;
        end
        else if (start) begin
            idx_rd_addr_r <= 0;
        end
        else if (idx_rd_addr_r < conf_idx_cnt) begin
            idx_rd_addr_r <= idx_rd_addr_r + 1;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            idx_rd_done_r <= 1'b1;
        end
        else if (start) begin
            idx_rd_done_r <= 1'b0;
        end
        else if (idx_rd_addr_r == conf_idx_cnt) begin
            idx_rd_done_r <= 1'b1;
        end
    end
    
    Q#(.DW(ADDR_W), .L(10)) idx_rd_addr_q (.clk, .s(idx_rd_addr ), .d(idx_rd_addr_d ));
    Q#(.DW(IDX_W),  .L(7 )) idx_y_q       (.clk, .s(idx_y       ), .d(idx_y_d       ));
    Q#(.DW(1),      .L(10)) vld_q         (.clk, .s(~idx_rd_done_r), .d(vld_d));
    
    // data buffer 
    always @ (posedge clk) begin
        dbuf_addr_r <= {{(ADDR_W - IDX_W){1'b0}}, idx_x};
        dbuf_mask_r <= '1;
        dbuf_mux_r  <= 2'b00;
    end
    
    // parameter buffer
    always @ (posedge clk) begin
        if (~conf_mode[1]) begin
            pbuf_addr_r <= {{bw(BATCH){1'b0}}, (idx_rd_addr_d[2] >> bw(BATCH))};
            pbuf_sel_r  <= idx_rd_addr_d[2][bw(BATCH) - 1 : 0];
        end
        else begin
            pbuf_addr_r <= {{(ADDR_W - IDX_W){1'b0}}, idx_y};
            pbuf_sel_r  <= 0;
        end
    end
    
    // new accumulation flag
    reg     [16 -1 : 0] new_flag_buf;
    always @ (posedge clk) begin
        if (rst) begin
            new_flag_buf <= '1;
        end
        else if (start && conf_is_new) begin
            new_flag_buf <= '1;
        end
        else if (~conf_mode[1] && vld_d[9]) begin
            new_flag_buf[idx_y_d[7]] <= 1'b0;
        end
    end
    
    // accumulation buffer
    always @ (posedge clk) begin
        if (~conf_mode[1]) begin
            abuf_addr_r     <= {{(ADDR_W - IDX_W){1'b0}}, idx_y_d[6]};
            abuf_acc_en_r   <= {32{vld_d[9]}};
            abuf_acc_new_r  <= new_flag_buf[idx_y_d[7]];
        end
        else begin
            abuf_addr_r     <= {{(ADDR_W - bw(BATCH)){1'b0}}, (idx_rd_addr_d[9] >> bw(BATCH))};
            abuf_acc_en_r   <= vld_d[9] ? (1 << idx_rd_addr_d[9][bw(BATCH)-1 : 0]) : 0;
            abuf_acc_new_r  <= 1'b1;
        end
    end
    
    assign  idx_rd_addr     = idx_rd_addr_r;
    assign  dbuf_addr       = dbuf_addr_r;
    assign  dbuf_mask       = dbuf_mask_r;
    assign  dbuf_mux        = dbuf_mux_r;    
    assign  pbuf_addr       = pbuf_addr_r;
    assign  pbuf_sel        = pbuf_sel_r;
    assign  mac_new_acc     = 1'b0;
    assign  abuf_addr       = abuf_addr_r;
    assign  abuf_acc_en     = abuf_acc_en_r;
    assign  abuf_acc_new    = abuf_acc_new_r;
    
endmodule