import GLOBAL_PARAM::bw;
import GLOBAL_PARAM::IDX_W;
import GLOBAL_PARAM::BATCH;

module conv_agu#(
    parameter   ADDR_W  = 8,
    parameter   GRP_ID_Y= 0,
    parameter   GRP_ID_X= 0
    )(
    input   clk,
    input   rst,
    
    input   start,
    output  done,
    input   [2  -1 : 0] conf_mode,
    input   [8  -1 : 0] conf_idx_cnt,   // number of idx to deal with
    input   [8  -1 : 0] conf_trip_cnt,
    input               conf_is_new,
    input               conf_pad_u,
    input               conf_pad_l,
    input   [6  -1 : 0] conf_lim_r,
    input   [6  -1 : 0] conf_lim_d,
    input   [6  -1 : 0] conf_row_cnt,
    
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

//=============================================================================
// Counter Status
//=============================================================================
    
    reg     working_r;
    
    // 2-dim counter for kernel x, y
    reg     [2 : 0] ker_x_r, ker_y_r;
    reg     next_pix_r;
    wire    [8 : 0] next_pix_d;
    
    always @ (posedge clk) begin
        if (rst) begin
            ker_x_r <= 0;
            ker_y_r <= 0;
        end
        else if (start) begin
            ker_x_r <= 0;
            ker_y_r <= 0;
        end
        else if (ker_x_r < 2) begin
            ker_x_r <= ker_x_r + 1;
            ker_y_r <= ker_y_r;
        end
        else begin
            ker_x_r <= 0;
            ker_y_r <= (ker_y_r < 2) ? (ker_y_r + 1) : 0;
        end
    end
    
    always @ (posedge clk) begin
        next_pix_r <= (ker_x_r == 2) && (ker_y_r == 2);
    end
    
    // pixel row counter
    reg     [3 : 0] pix_cnt_r;
    reg     next_channel_r;
    wire    [7 : 0] next_ch_d;
    
    always @ (posedge clk) begin
        if (rst) begin
            pix_cnt_r <= 0;
        end
        else if (start) begin
            pix_cnt_r <= 0;
        end
        else if (next_pix_r) begin
            pix_cnt_r <= (pix_cnt_r == conf_row_cnt) ? 0 : (pix_cnt_r + 1);
        end
    end
    
    always @ (posedge clk) begin
        if (working_r) begin
            next_channel_r <= next_pix_r && (pix_cnt_r == conf_row_cnt);
        end
        else begin
            next_channel_r <= 1'b0;
        end
    end
    
    // channel 
    reg     [4 : 0] channel_cnt_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            channel_cnt_r <= 0;
        end
        else if (start) begin
            channel_cnt_r <= 0;
        end
        else if (next_channel_r) begin
            channel_cnt_r <= (channel_cnt_r < conf_idx_cnt) ? channel_cnt_r + 1 : channel_cnt_r;
        end
    end
    
    // working status
    wire    [10: 0] start_d;
    wire    [7 : 0] valid_d;
    reg     valid_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            working_r <= 1'b0;
        end
        else if (start) begin
            working_r <= 1'b1;
        end
        else if (channel_cnt_r == conf_idx_cnt && next_channel_r) begin
            working_r <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            valid_r <= 1'b0;
        end
        else if (start_d[2]) begin
            valid_r <= 1'b1;
        end
        else if (channel_cnt_r == conf_idx_cnt && next_channel_r) begin
            valid_r <= 1'b0;
        end
    end
    
    reg     last_r;
    wire    [8 : 0] last_d;
    
    always @ (posedge clk) begin
        if (rst) begin
            last_r <= 1'b0;
        end
        else if (channel_cnt_r == conf_idx_cnt && next_channel_r) begin
            last_r <= 1'b1;
        end
        else begin
            last_r <= 1'b0;
        end
    end
    
    RQ#(.DW(1),.L(11)) start_q (.clk, .rst, .s(start),   .d(start_d));
    RQ#(.DW(1), .L(8)) valid_q (.clk, .rst, .s(valid_r), .d(valid_d));
    RQ#(.DW(1), .L(9)) last_q  (.clk, .rst, .s(last_r),  .d(last_d));
    RQ#(.DW(1), .L(8)) next_ch_q  (.clk, .rst, .s(next_channel_r), .d(next_ch_d));
    RQ#(.DW(1), .L(9)) next_pix_q (.clk, .rst, .s(next_pix_r),     .d(next_pix_d));    
    
    // done signal
    reg     done_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            done_r <= 1'b1;
        end
        else if (start) begin
            done_r <= 1'b0;
        end
        else if (~conf_mode[1]) begin
            if (last_d[3]) begin
                done_r <= 1'b1;
            end
        end
        else begin
            if (last_d[8]) begin
                done_r <= 1'b1;
            end
        end
    end
    
    assign  done = done_r;
    
//=============================================================================
// Calculate index buffer address
//=============================================================================
    reg     [ADDR_W -1 : 0] idx_rd_addr_r;

    always @ (posedge clk) begin
        if (start) begin
            idx_rd_addr_r <= 0;
        end
        else if (next_channel_r) begin
            idx_rd_addr_r <= idx_rd_addr_r + 1;
        end        
    end
    
    assign  idx_rd_addr = idx_rd_addr_r;
    
//=============================================================================
// Calculate data buffer address
//=============================================================================

    wire    [IDX_W  -1 : 0] idx_x, idx_y;
    assign  {idx_y, idx_x} = idx;
    
    reg     [2 : 0] ker_x_d0_r, ker_y_d0_r;
    reg     [2 : 0] ker_x_d1_r, ker_y_d1_r;
    reg     [3 : 0] pix_cnt_d_r;
    
    always @ (posedge clk) begin
        ker_x_d0_r <= ker_x_r;
        ker_x_d1_r <= ker_x_d0_r;
        ker_y_d0_r <= ker_y_r;
        ker_y_d1_r <= ker_y_d0_r;
        pix_cnt_d_r<= pix_cnt_r;
    end
    
    reg signed  [3 : 0] win_y_r;
    reg signed  [5 : 0] win_x_r;
    reg signed  [3 : 0] pe_y_r;
    reg signed  [5 : 0] pe_x_r;
    
    always @ (posedge clk) begin
        win_y_r <= ker_y_d1_r - (conf_pad_u ? 1 : 0);
        win_x_r <= ker_x_d1_r - (conf_pad_l ? 1 : 0) + (pix_cnt_d_r << 1);
    end
    
    always @ (posedge clk) begin
        pe_y_r <= win_y_r[0] ? (win_y_r + 1 - GRP_ID_Y) : (win_y_r + GRP_ID_Y);
        pe_x_r <= win_x_r[0] ? (win_x_r + 1 - GRP_ID_X) : (win_x_r + GRP_ID_X);
    end
    
    // padding mask
    reg     pad_mask_r, dbuf_mask_r;
    always @ (posedge clk) begin
        pad_mask_r <= (win_x_r >= 0) && (win_x_r <= conf_lim_r) &&
                      (win_y_r >= 0) && (win_y_r <= conf_lim_d);
        dbuf_mask_r<= pad_mask_r;
    end
    assign  dbuf_mask = dbuf_mask_r;
    
    // shared data mux
    wire    [1 : 0] mux;
    assign  mux[0] = win_x_r[0];
    assign  mux[1] = win_y_r[0];
    
    Pipe#(.DW(2), .L(2)) mux_pipe (.clk, .s(mux), .d(dbuf_mux));
    
    // address
    reg     [4 -1 : 0] dbuf_addr_r;
    always @ (posedge clk) begin
        // y coordinate
        dbuf_addr_r[3 : 3] <= pe_y_r[1];
        // x coordinate
        dbuf_addr_r[2 : 0] <= pe_x_r[3 : 1];
    end    
    assign  dbuf_addr = {idx_x, dbuf_addr_r};
    
//=============================================================================
// Calculate parameter buffer address
//============================================================================= 
    
    reg     [ADDR_W -1 : 0] pbuf_addr_conv_r;
    reg     [4      -1 : 0] pbuf_addr_uconv_r;
    
    // address
    always @ (posedge clk) begin
        if (start_d[5]) begin
            pbuf_addr_conv_r <= 0;
        end
        else if (next_pix_d[3] && !next_ch_d[2]) begin
            pbuf_addr_conv_r <= pbuf_addr_conv_r - 8;
        end
        else begin
            pbuf_addr_conv_r <= pbuf_addr_conv_r + 1;
        end
    end
    
    always @ (posedge clk) begin
        if (start_d[5]) begin
            pbuf_addr_uconv_r <= 0;
        end
        else if (next_pix_d[3]) begin
            if (next_ch_d[2]) begin
                pbuf_addr_uconv_r <= 0;
            end
            else begin
                pbuf_addr_uconv_r <= pbuf_addr_uconv_r + 1;
            end
        end
    end
    
    // select from 2 modes
    reg     [ADDR_W     -1 : 0] pbuf_addr_r;
    reg     [bw(BATCH)  -1 : 0] pbuf_sel_r;
    
    always_comb begin
        if (~conf_mode[1]) begin // CONV mode
            pbuf_addr_r <= {{(bw(BATCH)){1'b0}}, pbuf_addr_conv_r[ADDR_W-1 : bw(BATCH)]};
            pbuf_sel_r  <= pbuf_addr_r[bw(BATCH) -1 : 0];
        end
        else begin
            pbuf_addr_r[3 : 0] <= pbuf_addr_uconv_r;
            pbuf_addr_r[ADDR_W-1 : 4] <= idx_y;
            pbuf_sel_r  <= 0;
        end
    end
    
    assign  pbuf_addr   = pbuf_addr_r;
    assign  pbuf_sel    = pbuf_sel_r;
   
//=============================================================================
// Calculate accumulation buffer address
//=============================================================================
    reg     [ADDR_W -1 : 0] abuf_addr_conv_r;
    reg     [ADDR_W -1 : 0] abuf_addr_uconv_r;
    reg     [ADDR_W -1 : 0] abuf_addr_uconv_step_r;
    
    always @ (posedge clk) begin
        abuf_addr_conv_r[3 : 0] <= pbuf_addr_uconv_r;
        abuf_addr_conv_r[ADDR_W-1 : 4] <= idx_y;
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            abuf_addr_uconv_step_r <= 0;
        end
        else if (next_pix_d[7]) begin
            if (next_ch_d[6]) begin
                abuf_addr_uconv_step_r <= 17;
            end
            else begin
                abuf_addr_uconv_step_r <= 8;
            end
        end
        else begin
            abuf_addr_uconv_step_r <= -1;
        end
    end
    
    always @ (posedge clk) begin
        if (start_d[10]) begin
            abuf_addr_uconv_r <= 8;
        end
        else begin
            abuf_addr_uconv_r <= abuf_addr_uconv_r + abuf_addr_uconv_step_r;
        end
    end

    // new accumulation flag
    reg     [16 -1 : 0] new_flag_buf;
    reg     [4  -1 : 0] idx_y_d;
    
    always @ (posedge clk) begin
        idx_y_d <= idx_y;
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            new_flag_buf <= '1;
        end
        else if (start && conf_is_new) begin
            new_flag_buf <= '1;
        end
        else if (~conf_mode[1] && next_ch_d[3]) begin
            new_flag_buf[idx_y_d] <= 1'b0;
        end
    end    
    
    reg     [ADDR_W -1 : 0] abuf_addr_r;
    reg     [BATCH  -1 : 0] abuf_acc_en_r;
    reg                     abuf_acc_new_r;
    
    always @ (posedge clk) begin
        if (~conf_mode[1]) begin
            abuf_addr_r     <= abuf_addr_conv_r;
            abuf_acc_en_r   <= {32{valid_d[3] && next_pix_d[5]}};
            abuf_acc_new_r  <= new_flag_buf[idx_y_d];
        end
        else begin
            abuf_addr_r     <= {{(bw(BATCH)){1'b0}}, abuf_addr_uconv_r[ADDR_W-1 : bw(BATCH)]};
            abuf_acc_en_r   <= valid_d[7] ? (1 << abuf_addr_uconv_r[bw(BATCH)-1 : 0]) : 0;
            abuf_acc_new_r  <= 1'b0;
        end
    end
    
    assign  abuf_addr   = abuf_addr_r;
    assign  abuf_acc_en = abuf_acc_en_r;
    assign  abuf_acc_new= abuf_acc_new_r;

//=============================================================================
// Clear MAC array signal
//=============================================================================    
    reg     mac_new_acc_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            mac_new_acc_r <= 1'b1;
        end
        else if (~conf_mode[1]) begin
            mac_new_acc_r <= (start_d[7] || next_pix_d[5]);
        end
        else begin
            mac_new_acc_r <= 1'b1;
        end
    end
    
    assign  mac_new_acc = mac_new_acc_r;    
   
endmodule