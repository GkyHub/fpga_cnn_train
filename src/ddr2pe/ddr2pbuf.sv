import  GLOBAL_PARAM::DDR_W;
import  GLOBAL_PARAM::BATCH;
import  GLOBAL_PARAM::bw;
import  GLOBAL_PARAM::RES_W;
import  GLOBAL_PARAM::DATA_W;

module ddr2pbuf#(
    parameter   BUF_DEPTH   = 256,
    parameter   ADDR_W      = bw(BUF_DEPTH),
    parameter   PE_NUM      = 32
    )(
    input   clk,
    input   rst,
    
    // configuration port
    input                   conf_valid,
    output                  conf_ready,
    input   [12     -1 : 0] conf_trans_num,
    input   [4      -1 : 0] conf_mode,
    input   [4      -1 : 0] conf_ch_num,    // only for update
    input   [4      -1 : 0] conf_pix_num,   // only for update
    input   [2      -1 : 0] conf_row_num,   // only for update
    input                   conf_depool,    // only for update
    input   [PE_NUM -1 : 0] conf_mask,
    
    // ddr data stream port
    input   [DDR_W  -1 : 0] ddr1_data,
    input                   ddr1_valid,
    output                  ddr1_ready,
    
    input   [DDR_W  -1 : 0] ddr2_data,
    input                   ddr2_valid,
    output                  ddr2_ready,
    
    // pbuf write port    
    output  [3:0][DATA_W*BATCH-1:0] pbuf_wr_data,
    output  [ADDR_W -1 : 0] pbuf_wr_addr,
    output  [PE_NUM -1 : 0] pbuf_wr_en,
    
    // bbuf accumulation port
    input                   bbuf_acc_en,
    input                   bbuf_acc_new,
    input   [ADDR_W -1 : 0] bbuf_acc_addr,
    input   [RES_W  -1 : 0] bbuf_acc_data
    );
    
    assign  ddr1_ready = 1'b1;
    assign  ddr2_ready = 1'b1;

//=============================================================================
// forward and backward mode
//============================================================================= 
    
    reg     [12     -1 : 0] param_cnt_r;
    wire    [ADDR_W -1 : 0] param_addr;
    wire                    param_wr_en;
    reg     param_last_r;
        
    always @ (posedge clk) begin
        if (conf_valid) begin
            param_cnt_r <= 0;
        end
        else if (ddr2_valid) begin
            param_cnt_r <= param_cnt_r + 32;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            param_last_r <= 1'b1;
        end
        else if (conf_valid) begin
            param_last_r <= 1'b0;
        end
        else if (param_cnt_r > conf_trans_num) begin
            param_last_r <= 1'b1;
        end
        else begin
            param_last_r <= 1'b0;
        end
    end
    
    assign  param_addr = param_cnt_r >> 5;
    assign  param_wr_en= ddr2_valid;

//=============================================================================
// update mode
//=============================================================================

    reg     [3 : 0] row_cnt_r;
    reg     [3 : 0] pix_cnt_r;
    reg     [3 : 0] ch_cnt_r;
    reg     [3 : 0] ch_cnt_d;
    reg             next_pix_r;
    reg     [ADDR_W -1 : 0] update_addr;
    wire    [4      -1 : 0] update_wr_mask;
    reg             update_last_r;
    
    always @ (posedge clk) begin
        if (conf_valid) begin
            ch_cnt_r <= 0;
        end
        else if (ddr1_valid && ddr2_valid) begin
            ch_cnt_r <= (ch_cnt_r == conf_ch_num) ? 0 : ch_cnt_r + 1;
        end
    end
    
    always @ (posedge clk) begin
        next_pix_r  <= (ch_cnt_r == conf_ch_num) && (ddr1_valid && ddr2_valid);
        ch_cnt_d    <= ch_cnt_r;
    end
    
    always @ (posedge clk) begin
        if (conf_valid) begin
            row_cnt_r <= 0;
            pix_cnt_r <= 0;
        end
        else if (next_pix_r) begin
            if (pix_cnt_r == conf_pix_num) begin
                pix_cnt_r <= 0;
                row_cnt_r <= row_cnt_r + (conf_depool ? 2 : 1);
            end
            else begin
                pix_cnt_r <= pix_cnt_r + (conf_depool ? 2 : 1);
            end
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            update_last_r <= 1'b0;
        end
        else begin
            update_last_r <= next_pix_r && (pix_cnt_r == conf_pix_num) && (row_cnt_r == conf_row_num);
        end
    end
    
    always_comb begin
        update_addr[ADDR_W-1 : 4] <= ch_cnt_d;
        update_addr[3]            <= row_cnt_r[1];
        update_addr[2 : 0]        <= pix_cnt_r[3 : 1]; 
    end
    
//=============================================================================
// data and address selection
//=============================================================================

    reg     [BATCH  -1 : 0][DATA_W  -1 : 0] ddr1_data_d;
    reg     [BATCH  -1 : 0][DATA_W  -1 : 0] ddr2_data_d;
    reg                     ddr_valid_d;
    
    reg     [ADDR_W -1 : 0] pbuf_wr_addr_r;
    reg     [PE_NUM -1 : 0] pbuf_wr_en_r;
    reg     [3 : 0][BATCH -1 : 0][DATA_W-1 : 0] pbuf_wr_data_r;    
    
    always @ (posedge clk) begin
        if (rst) begin
            ddr_valid_d <= 1'b0;
        end
        else begin
            ddr_valid_d <= (conf_mode[2:1] == 2'b10) ? (ddr1_valid && ddr2_valid) : ddr2_valid;
        end
    end
    
    always @ (posedge clk) begin
        ddr1_data_d <= ddr1_data;
        ddr2_data_d <= ddr2_data;
    end

    always @ (posedge clk) begin
        if (conf_mode[2:1] == 2'b10) begin
            pbuf_wr_addr_r <= update_addr;
        end
        else begin
            pbuf_wr_addr_r <= param_addr;
        end
    end
    
    genvar i, j;
    generate
        for (j = 0; j < 4; j = j + 1) begin: UNIT
            for (i = 0; i < BATCH; i = i + 1) begin: ARRAY
            
                always @ (posedge clk) begin
                    if (conf_mode[2:1] == 2'b10) begin
                        if (conf_depool) begin
                            pbuf_wr_data_r[j][i] <= ddr2_data_d[i][j] ? ddr1_data_d[j][i] : '0;
                        end
                        else begin
                            pbuf_wr_data_r[j][i] <= ddr1_data_d[i][j];
                        end
                    end
                    else begin
                        pbuf_wr_data_r[j][i] <= ddr2_data[DATA_W*i +: DATA_W];
                    end
                end
                
            end            
        end
        
        for (i = 0; i < PE_NUM / 4; i = i + 1) begin: GROUP
            for (j = 0; j < 4; j = j + 1) begin: UNIT
            
                always @ (posedge clk) begin
                    if (rst) begin
                        pbuf_wr_en_r[i*4+j] <= 1'b0;
                    end
                    else if (conf_mask[i*4+j]) begin
                        if (conf_mode[2:1] == 2'b10) begin
                            if (conf_depool) begin
                                pbuf_wr_en_r[i*4+j] <= ddr_valid_d;
                            end
                            else begin
                                pbuf_wr_en_r[i*4+j] <= ddr_valid_d && ({row_cnt_r[0], pix_cnt_r[0]} == j);
                            end
                        end
                        else begin
                            pbuf_wr_en_r[i*4+j] <= ddr2_valid;
                        end
                    end
                    else begin
                        pbuf_wr_en_r[i*4+j] <= 1'b0;
                    end
                end
                
            end
        end
    endgenerate
    
    assign  pbuf_wr_addr    = pbuf_wr_addr_r;
    assign  pbuf_wr_data    = pbuf_wr_data_r;
    assign  pbuf_wr_en      = pbuf_wr_en_r;

//=============================================================================
// update bias
//=============================================================================
    wire    [RES_W  -1 : 0] channel_sum;
    wire    bbuf_acc_valid = (conf_mode[2:1] == 2'b10) && (ddr1_valid && ddr2_valid);
    
    assign  bbuf_acc_new = 1'b0;
    assign  bbuf_acc_data = channel_sum;
    
    adder_tree#(
        .DATA_W (DATA_W ),
        .DATA_N (BATCH  ),
        .RES_W  (RES_W  )
    ) bias_gradient_sum (
        .clk    (clk        ),
    
        .vec    (ddr1_data  ),
        .sum    (channel_sum)
    );
    
    RPipe#(.DW(1), .L(6)) acc_en_q (.clk, .rst, .s(bbuf_acc_valid), .d(bbuf_acc_en));
    
    reg     [ADDR_W -1 : 0] bbuf_acc_addr_r;
    always @ (posedge clk) begin
        if (conf_valid) begin
            bbuf_acc_addr_r <= 0;
        end
        else if (bbuf_acc_en) begin
            bbuf_acc_addr_r <= bbuf_acc_addr_r + 1;
        end
    end
    
    assign  bbuf_acc_addr = bbuf_acc_addr_r;
    
//=============================================================================
// conf_ready signal
//=============================================================================

    reg conf_ready_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            conf_ready_r <= 1'b1;
        end
        else if (conf_valid) begin
            conf_ready_r <= 1'b0;
        end
        else begin
            if (conf_mode[2:1] == 2'b10) begin
                if (update_last_r) begin
                    conf_ready_r <= 1'b1;
                end
            end
            else begin
                if (param_last_r) begin
                    conf_ready_r <= 1'b1;
                end
            end
        end
    end
    
    assign  conf_ready = conf_ready_r;
    
endmodule