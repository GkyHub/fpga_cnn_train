module agu_config(
    input   clk,
    input   rst,
    
    input               start,
    input   [3  -1 : 0] mode,
    input   [8  -1 : 0] idx_cnt,    // number of idx to deal with
    input   [8  -1 : 0] trip_cnt,   // number of cycles for the agu to work with a single cycle
    input               is_new,
    input   [4  -1 : 0] pad_code,   // {R, L, D, U}
    input               cut_y,
    
    output  [2  -1 : 0] conf_mode,
    output  [8  -1 : 0] conf_idx_cnt,   // number of idx to deal with
    output  [8  -1 : 0] conf_trip_cnt,  // number of cycles for the agu to work with a single cycle
    output              conf_is_new,
    output              conf_pad_u,
    output              conf_pad_l,
    output  [6  -1 : 0] conf_lim_r,
    output  [6  -1 : 0] conf_lim_d,
    output  [6  -1 : 0] conf_row_cnt,
    
    output              start_fc,
    output              start_conv
    );
    
    reg     [2  -1 : 0] conf_mode_r;
    reg     [8  -1 : 0] conf_idx_cnt_r;
    reg     [8  -1 : 0] conf_trip_cnt_r;
    reg                 conf_is_new_r;
    reg                 conf_pad_u_r;
    reg                 conf_pad_l_r;
    reg     [6  -1 : 0] conf_lim_r_r;
    reg     [6  -1 : 0] conf_lim_d_r;
    reg     [6  -1 : 0] conf_row_cnt_r;

    reg     start_fc_r, start_conv_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            conf_mode_r     <= 2'b00;
            conf_idx_cnt_r  <= 0;
            conf_trip_cnt_r <= 0;
            conf_is_new_r   <= 1'b1;
            conf_pad_u_r    <= 1'b0;
            conf_pad_l_r    <= 1'b0;
            conf_lim_r_r    <= 0;
            conf_lim_d_r    <= 0;
            conf_row_cnt_r  <= 0;
        end
        else if (start) begin
            conf_mode_r     <= mode[2 : 1];
            conf_idx_cnt_r  <= idx_cnt;
            conf_trip_cnt_r <= trip_cnt;
            conf_is_new_r   <= is_new;
            conf_pad_u_r    <= pad_code[0];
            conf_pad_l_r    <= pad_code[2];
            conf_row_cnt_r  <= (trip_cnt >> 1) + trip_cnt[0] - 1;
            
            case(pad_code[1 : 0])
            2'b00: conf_lim_d_r <= 3 - cut_y;
            2'b01: conf_lim_d_r <= 2 - cut_y;
            2'b10: conf_lim_d_r <= 2 - cut_y;
            2'b11: conf_lim_d_r <= 1 - cut_y;
            endcase
            
            case(pad_code[1 : 0])
            2'b00: conf_lim_r_r <= trip_cnt + 1;
            2'b01: conf_lim_r_r <= trip_cnt;
            2'b10: conf_lim_r_r <= trip_cnt;
            2'b11: conf_lim_r_r <= trip_cnt - 1;
            endcase
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            start_conv_r<= 1'b0;
            start_fc_r  <= 1'b0;
        end
        else if (start) begin
            if (mode[0]) begin
                start_fc_r <= 1'b1;
            end
            else begin
                start_conv_r <= 1'b1;
            end
        end
        else begin
            start_conv_r<= 1'b0;
            start_fc_r  <= 1'b0;
        end
    end
    
    assign  conf_mode       = conf_mode_r;   
    assign  conf_idx_cnt    = conf_idx_cnt_r; 
    assign  conf_trip_cnt   = conf_trip_cnt_r;
    assign  conf_is_new     = conf_is_new_r;  
    assign  conf_pad_u      = conf_pad_u_r;   
    assign  conf_pad_l      = conf_pad_l_r;   
    assign  conf_lim_r      = conf_lim_r_r;   
    assign  conf_lim_d      = conf_lim_d_r;   
    assign  conf_row_cnt    = conf_row_cnt_r;     
    
    assign  start_fc        = start_fc_r;
    assign  start_conv      = start_conv_r;
    
endmodule