import  GLOBAL_PARAM::*;

module pe2ddr_dg#(
    parameter   BUF_DEPTH   = 256,
    parameter   ADDR_W      = bw(BUF_DEPTH)
    )(
    input   clk,
    input   rst,
    
    input           start,
    output          done,
    input   [3 : 0] conf_layer_type,
    input           conf_pooling,
    input           conf_relu,
    input   [3 : 0] conf_ch_num,
    input   [3 : 0] conf_pix_num,
    input   [3 : 0] conf_row_num,
    input   [5 : 0] conf_shift,
    input   [1 : 0] conf_pe_sel,
    
    output  [ADDR_W         -1 : 0] abuf_rd_addr,
    input   [3 : 0][BATCH * RES_W  -1 : 0] abuf_rd_data,
    output  abuf_rd_en,
    
    output  [ADDR_W -1 : 0] bbuf_rd_addr,
    input   [RES_W  -1 : 0] bbuf_rd_data,
    output                  bbuf_rd_en,
    
    output  [DDR_W      -1 : 0] ddr1_data,
    output                      ddr1_valid,
    input                       ddr1_ready,
    
    output  [DDR_W      -1 : 0] ddr2_data,
    output                      ddr2_valid,
    input                       ddr2_ready
    );
    
    wire    ddr_ready = conf_layer_type[1] ? ddr1_ready : (ddr1_ready && ddr2_ready);
    assign  abuf_rd_en = ddr_ready;
    assign  bbuf_rd_en = ddr_ready;

//=============================================================================
// address generator   
//=============================================================================

    reg     [3 : 0] ch_cnt_r, ch_cnt_d_r;
    reg     [3 : 0] pix_cnt_r;
    reg     [3 : 0] row_cnt_r; 
    reg     [ADDR_W -1 : 0] abuf_rd_addr_r;
    wire    [1 : 0] grp_mux;
    reg     valid_r;
    reg     start_d_r;
    
    reg     nxt_pix_r;
    
    always @ (posedge clk) begin
        if (start) begin
            ch_cnt_r    <= 0;
        end
        else if (ddr_ready) begin
            ch_cnt_r    <= (ch_cnt_r == conf_ch_num) ? 0 : ch_cnt_r + 1;
        end
    end
    
    always @ (posedge clk) begin
        start_d_r <= start;
    end
    
    always @ (posedge clk) begin
        if (ddr_ready) begin
            ch_cnt_d_r <= ch_cnt_r;
        end
    end
    
    always @ (posedge clk) begin
        if (ddr_ready) begin
            nxt_pix_r <= (ch_cnt_r == conf_ch_num);
        end
    end
    
    always @ (posedge clk) begin
        if (start) begin
            pix_cnt_r <= {3'd0, conf_pe_sel[0]};
            row_cnt_r <= {3'd0, conf_pe_sel[1]};
        end
        else if (ddr_ready && nxt_pix_r) begin
            if (pix_cnt_r == conf_pix_num) begin
                pix_cnt_r <= (row_cnt_r == conf_row_num) ? pix_cnt_r : 0;
                row_cnt_r <= (row_cnt_r == conf_row_num) ? row_cnt_r : row_cnt_r + 1;
            end
            else begin
                pix_cnt_r <= pix_cnt_r + 1;
                row_cnt_r <= row_cnt_r;
            end
        end
    end
    
    always @ (posedge clk) begin
        if (ddr_ready) begin
            abuf_rd_addr_r[ADDR_W-1 : ADDR_W-4] <= ch_cnt_d_r;
            if (conf_pooling) begin
                abuf_rd_addr_r[3]   <= row_cnt_r[0];
                abuf_rd_addr_r[2:0] <= pix_cnt_r[2:0];
            end
            else begin
                abuf_rd_addr_r[3]   <= row_cnt_r[1];
                abuf_rd_addr_r[2:0] <= pix_cnt_r[3:1];
            end
        end
    end

    assign grp_mux = {row_cnt_r[0], pix_cnt_r[0]};
    
    always @ (posedge clk) begin
        if (rst) begin
            valid_r <= 1'b0;
        end
        else if (start_d_r) begin
            valid_r <= 1'b1;
        end
        else if (ddr_ready && nxt_pix_r && (pix_cnt_r == conf_pix_num) && row_cnt_r == conf_row_num) begin
            valid_r <= 1'b0;
        end
    end
    
    PipeEn#(.DW(4), .L(3)) bbuf_addr_pipe (.clk(clk), .clk_en(ddr_ready), 
        .s(ch_cnt_d_r), .d(bbuf_rd_addr[3:0]));
    assign  bbuf_rd_addr[ADDR_W-1:4] = 0;
    
    assign  abuf_rd_addr = abuf_rd_addr_r;

//=============================================================================
// data path 
//=============================================================================

    wire    [DATA_W -1 : 0] bias = bbuf_rd_data[RES_W-1 : RES_W-DATA_W];
    wire    [3 : 0][BATCH -1 : 0][RES_W -1 : 0] res_arr = abuf_rd_data;
    
    reg signed [BATCH -1 : 0][RES_W -1 : 0] res_sel_r;
    reg signed [BATCH -1 : 0][DATA_W-1 : 0] res_sf_r;
    reg signed [BATCH -1 : 0][DATA_W-1 : 0] res_bias_r;
    reg signed [BATCH -1 : 0][DATA_W-1 : 0] res_relu_r;
    
    reg     [BATCH -1 : 0][3 : 0] pool_mask_r;
    reg     [BATCH -1 : 0][3 : 0] relu_mask_r;
    
    wire    [1 : 0] grp_mux_d;
    
    wire    [BATCH  -1 : 0][DATA_W  -1 : 0] ddr1_data_arr, ddr2_data_arr;
    
    PipeEn#(.DW(2), .L(5)) grp_mux_pipe (.clk(clk), .clk_en(ddr_ready), 
        .s(grp_mux), .d(grp_mux_d));
        
    genvar i;
    generate
        for (i = 0; i < BATCH; i = i + 1) begin: UNIT
            
            wire signed [3 : 0][RES_W  -1 : 0] unit_res;
            assign  unit_res[0] = res_arr[0][i];
            assign  unit_res[1] = res_arr[1][i];
            assign  unit_res[2] = res_arr[2][i];
            assign  unit_res[3] = res_arr[3][i];
                 
            reg  signed [1 : 0][RES_W  -1 : 0] pool_res1_r;
            reg  signed [RES_W  -1 : 0] pool_res2_r;
            
            reg     [4  -1 : 0] pool_mask1_r;
            reg     [4  -1 : 0] pool_mask2_r;
            
            reg     [4  -1 : 0] pool_mask_d;
        
            // pooling or mux data
            always @ (posedge clk) begin
                if (ddr_ready) begin
                    // step 1
                    if (conf_pooling) begin
                        pool_res1_r[0] = (unit_res[0] > unit_res[1]) ? unit_res[0] : unit_res[1];
                        pool_res1_r[1] = (unit_res[2] > unit_res[3]) ? unit_res[2] : unit_res[3];
                    end
                    else begin
                        pool_res1_r[0] = unit_res[grp_mux_d];
                    end
                    
                    // step 2
                    if (conf_pooling) begin
                        res_sel_r[i] = (pool_res1_r[0] > pool_res1_r[1]) ? pool_res1_r[0] : pool_res1_r[1];
                    end
                    else begin
                        res_sel_r[i] = pool_res1_r[0];
                    end
                end
            end
            
            // pooling or mux mask
            always @ (posedge clk) begin
                if (ddr_ready) begin
                    // step 1
                    if (conf_pooling) begin
                        pool_mask1_r[0] <= (unit_res[0] > unit_res[1]);
                        pool_mask1_r[1] <= !(unit_res[0] > unit_res[1]);
                        pool_mask1_r[2] <= (unit_res[2] > unit_res[3]);
                        pool_mask1_r[3] <= !(unit_res[2] > unit_res[3]);
                    end
                    
                    // step 2
                    if (conf_pooling) begin
                        pool_mask2_r[0] <= pool_mask1_r[0] && (pool_res1_r[0] > pool_res1_r[1]);
                        pool_mask2_r[1] <= pool_mask1_r[1] && (pool_res1_r[0] > pool_res1_r[1]);
                        pool_mask2_r[2] <= pool_mask1_r[2] && !(pool_res1_r[0] > pool_res1_r[1]);
                        pool_mask2_r[3] <= pool_mask1_r[3] && !(pool_res1_r[0] > pool_res1_r[1]);
                    end
                    else begin
                        pool_mask2_r[i] <= 4'b1111;
                    end
                end
            end
            
            // shift
            always @ (posedge clk) begin
                if (ddr_ready) begin
                    res_sf_r[i] <= res_sel_r[i] >> conf_shift;
                end
            end
            
            // bias
            always @ (posedge clk) begin
                if (ddr_ready && !conf_layer_type[1]) begin
                    if (conf_layer_type[1]) begin
                        res_bias_r[i] <= res_sf_r[i];
                    end
                    else begin                    
                        res_bias_r[i] <= res_sf_r[i] + bias;
                    end
                end
            end
            
            // delay pooling mask to sync with relu
            PipeEn#(.DW(4), .L(2)) pool_mask_pipe(.clk(clk), .clk_en(ddr_ready), 
                .s(pool_mask2_r), .d(pool_mask_d));
            
            // relu
            always @ (posedge clk) begin
                if (ddr_ready) begin
                    res_relu_r[i] <= (res_relu_r[i] > 0) ? res_relu_r[i] : 0;
                    relu_mask_r[i]<= (res_relu_r[i] > 0) ? pool_mask_d : 4'b0000;
                end
            end
            
            assign  ddr1_data_arr[i] = res_relu_r[i];
            assign  ddr2_data_arr[i] = {4'b0000, relu_mask_r[i]};
            
        end
    endgenerate
    
    // valid signal delay
    RPipeEn#(.DW(1), .L(12)) pool_mask_pipe(.clk(clk), .rst(rst), 
        .clk_en(ddr_ready), .s(valid_r), .d(ddr1_valid));
    assign  ddr2_valid = (conf_layer_type[2:1] == 2'b00) ? ddr1_valid : 1'b0;
    
    // output data
    assign  ddr1_data = ddr1_data_arr;
    assign  ddr2_data = ddr2_data_arr;
    
//=============================================================================
// done signal   
//=============================================================================
   
    reg     done_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            done_r <= 1'b1;
        end
        else if (start) begin
            done_r <= 1'b0;
        end
        else if (ddr_ready && nxt_pix_r && row_cnt_r == conf_row_num) begin
            done_r <= 1'b1;
        end
    end
    
    assign  done = done_r;
    
endmodule