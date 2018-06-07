import  GLOBAL_PARAM::DATA_W;
import  GLOBAL_PARAM::BATCH;
import  GLOBAL_PARAM::DDR_W;
import  GLOBAL_PARAM::bw;

module ddr2dbuf#(
    parameter   BUF_DEPTH   = 256,
    parameter   ADDR_W      = bw(BUF_DEPTH),
    parameter   PE_NUM      = 32
    )(
    input   clk,
    input   rst,
    
    // configuration port
    input                   conf_valid,
    output                  conf_ready,
    input   [4      -1 : 0] conf_mode,
    input   [4      -1 : 0] conf_ch_num,
    input   [4      -1 : 0] conf_row_num, 
    input   [4      -1 : 0] conf_pix_num, 
    input   [PE_NUM -1 : 0] conf_mask,
    input                   conf_depool,
    
    // ddr data stream port
    input   [DDR_W  -1 : 0] ddr1_data,
    input                   ddr1_valid,
    output                  ddr1_ready,
    
    input   [DDR_W  -1 : 0] ddr2_data,
    input                   ddr2_valid,
    output                  ddr2_ready,
    
    // dbuf write port    
    output  [3:0][DATA_W*BATCH-1 : 0] dbuf_wr_data,
    output  [ADDR_W -1 : 0] dbuf_wr_addr,
    output  [PE_NUM -1 : 0] dbuf_wr_en
    );
    
    assign  ddr1_ready = (conf_mode[2:1] == 2'b01) ? ddr2_valid : 1'b1;
    assign  ddr2_ready = (conf_mode[2:1] == 2'b01) ? ddr1_valid : 1'b1;
    
//=============================================================================
// CONV mode
//=============================================================================
    reg     [3 : 0] row_cnt_r;
    reg     [3 : 0] pix_cnt_r;
    reg     [3 : 0] ch_cnt_r;
    reg     [3 : 0] ch_cnt_d;
    reg             next_pix_r;
    reg     [ADDR_W -1 : 0] conv_addr;
    // wire    [4      -1 : 0] conv_wr_mask;
    reg             conv_last_r;
    
    wire    conv_ddr_valid = (conf_mode[2:1] == 2'b01) ? (ddr1_valid && ddr2_valid) : ddr1_valid;
    
    always @ (posedge clk) begin
<<<<<<< HEAD
        if (conf_valid && conf_ready) begin
=======
        if (conf_valid) begin
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
            ch_cnt_r <= 0;
        end
        else if (conv_ddr_valid) begin
            ch_cnt_r <= (ch_cnt_r == conf_ch_num) ? 0 : ch_cnt_r + 1;
        end
    end
    
    always @ (posedge clk) begin
        next_pix_r  <= (ch_cnt_r == conf_ch_num) && conv_ddr_valid;
        ch_cnt_d    <= ch_cnt_r;
    end
    
    always @ (posedge clk) begin
<<<<<<< HEAD
        if (conf_valid && conf_ready) begin
=======
        if (conf_valid) begin
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
            row_cnt_r <= 0;
            pix_cnt_r <= 0;
        end
        else if (next_pix_r) begin
            if (pix_cnt_r == conf_pix_num) begin
                pix_cnt_r <= 0;
                row_cnt_r <= row_cnt_r + 1;
            end
            else begin
                pix_cnt_r <= pix_cnt_r + 1;
            end
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            conv_last_r <= 1'b0;
        end
        else begin
            conv_last_r <= next_pix_r && (pix_cnt_r == conf_pix_num) && (row_cnt_r == conf_row_num);
        end
    end
    
    always_comb begin
        conv_addr[ADDR_W-1 : 4] <= ch_cnt_d;
        conv_addr[3]            <= row_cnt_r[1];
        conv_addr[2 : 0]        <= pix_cnt_r[3 : 1]; 
    end
    
//=============================================================================
// FC mode
//=============================================================================
    reg     [ADDR_W -1 : 0] fc_addr_r;
    reg                     fc_last_r;
    
    always @ (posedge clk) begin
<<<<<<< HEAD
        if (conf_valid && conf_ready) begin
=======
        if (conf_valid) begin
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
            fc_addr_r <= 0;
        end
        else if (ddr1_valid) begin
            fc_addr_r <= fc_addr_r + 1;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            fc_last_r <= 1'b0;
        end
        else begin
            fc_last_r <= ddr1_valid && (fc_addr_r == conf_ch_num);
        end
    end
    
//=============================================================================
// Address and data mux
//=============================================================================

    reg     [BATCH  -1 : 0][DATA_W  -1 : 0] ddr1_data_d;
    reg     [BATCH  -1 : 0][DATA_W  -1 : 0] ddr2_data_d;
    reg                     ddr_valid_d;
    
    reg     [ADDR_W -1 : 0] dbuf_wr_addr_r;
    reg     [PE_NUM -1 : 0] dbuf_wr_en_r;
    reg     [3 : 0][BATCH -1 : 0][DATA_W-1 : 0] dbuf_wr_data_r;    
    
    always @ (posedge clk) begin
        if (rst) begin
            ddr_valid_d <= 1'b0;
        end
        else begin
            ddr_valid_d <= (conf_mode[2:1] == 2'b01) ? (ddr1_valid && ddr2_valid) : ddr2_valid;
        end
    end
    
    always @ (posedge clk) begin
        ddr1_data_d <= ddr1_data;
        ddr2_data_d <= ddr2_data;
    end

    always @ (posedge clk) begin
        if (conf_mode[2:1] == 2'b01) begin
            dbuf_wr_addr_r <= conv_addr;
        end
        else begin
            dbuf_wr_addr_r <= fc_addr_r;
        end
    end
    
    genvar i, j;
    generate
        for (j = 0; j < 4; j = j + 1) begin: UNIT
            for (i = 0; i < BATCH; i = i + 1) begin: ARRAY
            
                always @ (posedge clk) begin
                    if (conf_mode[2:1] == 2'b01) begin
                        if (conf_depool) begin
                            dbuf_wr_data_r[j][i] <= ddr2_data_d[i][j] ? ddr1_data_d[j][i] : '0;
                        end
                        else begin
                            dbuf_wr_data_r[j][i] <= ddr2_data_d[i][j];
                        end
                    end
                    else begin
                        dbuf_wr_data_r[j][i] <= ddr1_data[DATA_W*i +: DATA_W];
                    end
                end
                
            end            
        end
        
        for (i = 0; i < PE_NUM / 4; i = i + 1) begin: GROUP
            for (j = 0; j < 4; j = j + 1) begin: UNIT
            
                always @ (posedge clk) begin
                    if (rst) begin
                        dbuf_wr_en_r[i*4+j] <= 1'b0;
                    end
                    else if (conf_mask[i*4+j]) begin
                        if (conf_mode[2:1] == 2'b10) begin
                            if (conf_depool) begin
                                dbuf_wr_en_r[i*4+j] <= ddr_valid_d;
                            end
                            else begin
                                dbuf_wr_en_r[i*4+j] <= ddr_valid_d && ({row_cnt_r[0], pix_cnt_r[0]} == j);
                            end
                        end
                        else begin
                            dbuf_wr_en_r[i*4+j] <= ddr2_valid;
                        end
                    end
                    else begin
                        dbuf_wr_en_r[i*4+j] <= 1'b0;
                    end
                end
                
            end
        end
    endgenerate
    
    assign  dbuf_wr_addr    = dbuf_wr_addr_r;
    assign  dbuf_wr_data    = dbuf_wr_data_r;
    assign  dbuf_wr_en      = dbuf_wr_en_r;
    
//=============================================================================
// conf_ready signal
//=============================================================================

    reg conf_ready_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            conf_ready_r <= 1'b1;
        end
<<<<<<< HEAD
        else if (conf_valid && conf_ready) begin
=======
        else if (conf_valid) begin
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
            conf_ready_r <= 1'b0;
        end
        else begin
            if (conf_mode[0]) begin
                if (fc_last_r) begin
                    conf_ready_r <= 1'b1;
                end
            end
            else begin
                if (conv_last_r) begin
                    conf_ready_r <= 1'b1;
                end
            end
        end
    end
    
    assign  conf_ready = conf_ready_r;
    
endmodule