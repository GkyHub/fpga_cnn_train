import  GLOBAL_PARAM::DDR_W;
import  GLOBAL_PARAM::BATCH;
import  GLOBAL_PARAM::DATA_W;
import  GLOBAL_PARAM::TAIL_W;
import  GLOBAL_PARAM::bw;

module ddr2abuf#(
    parameter   BUF_DEPTH   = 256,
    parameter   PE_NUM      = 32,
    parameter   ADDR_W  = bw(BUF_DEPTH)
    )(
    input   clk,
    input   rst,
    
    input                   conf_valid,
    output                  conf_ready,
    input   [2      -1 : 0] conf_trans_type,
    input   [16     -1 : 0] conf_trans_num,
    input   [PE_NUM -1 : 0] conf_mask,
    
    // ddr data stream port
    input   [DDR_W  -1 : 0] ddr_data,
    input                   ddr_valid,
    output                  ddr_ready,
    
    // accum and bias buf port
    output  [ADDR_W         -1 : 0] abuf_wr_addr,
    output  [BATCH * DATA_W -1 : 0] abuf_wr_data,
    output  [PE_NUM         -1 : 0] abuf_wr_data_en,
    output  [BATCH * TAIL_W -1 : 0] abuf_wr_tail,
    output  [PE_NUM         -1 : 0] abuf_wr_tail_en,
    
    output  [ADDR_W -1 : 0] bbuf_wr_addr,
    output  [DATA_W -1 : 0] bbuf_wr_data,
    output                  bbuf_wr_data_en,
    output  [TAIL_W -1 : 0] bbuf_wr_tail,
    output                  bbuf_wr_tail_en
    );
    
    localparam TD_RATE = TAIL_W / DATA_W;

//=============================================================================
// Load tail data to accumulation buffer
//=============================================================================
    reg     [ADDR_W -1 : 0] abuf_tail_addr_r;
    reg     [3      -1 : 0] abuf_pack_cnt_r;
    reg                     abuf_next_pack_r;
    
    reg     [TD_RATE-1:0][BATCH-1:0][DATA_W-1:0] abuf_tail_buf_r;
    
    always @ (posedge clk) begin
<<<<<<< HEAD
        if (conf_valid && conf_ready) begin
=======
        if (conf_valid) begin
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
            abuf_tail_addr_r<= 0;
            abuf_pack_cnt_r <= 0; 
        end
        else if (ddr_valid && conf_trans_type == 2'b01) begin
            abuf_tail_addr_r<= (abuf_pack_cnt_r == TD_RATE - 1) ? abuf_tail_addr_r + 1 : abuf_tail_addr_r;
            abuf_pack_cnt_r <= (abuf_pack_cnt_r == TD_RATE - 1) ? 0 : abuf_pack_cnt_r + 1;
        end
    end
    
    always @ (posedge clk) begin
        if (ddr_valid && conf_trans_type == 2'b01) begin
            abuf_tail_buf_r[abuf_pack_cnt_r] <= ddr_data;
        end
    end    
    
//=============================================================================
// Load data to accumulation buffer
//=============================================================================
    reg     [ADDR_W -1 : 0] abuf_data_addr_r;
    reg     [DDR_W  -1 : 0] abuf_data_buf_r;
    
    always @ (posedge clk) begin
<<<<<<< HEAD
        if (conf_valid && conf_ready) begin
=======
        if (conf_valid) begin
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
            abuf_data_addr_r <= 0;
        end
        else if (ddr_valid && conf_trans_type == 2'b00) begin
            abuf_data_addr_r <= abuf_data_addr_r + 1;
        end
    end
    
    always @ (posedge clk) begin
        abuf_data_buf_r <= ddr_data;
    end
    
//=============================================================================
// Load tail to bias buffer
//=============================================================================

    localparam  TPACK_SIZE = DDR_W / TAIL_W;
    
    reg     [6  -1 : 0] bbuf_tail_cnt_r;
    reg     [ADDR_W -1 : 0] bbuf_tail_addr_r;
    wire    [TPACK_SIZE -1 : 0][TAIL_W -1 : 0] bbuf_tail_pack;
    reg     [TAIL_W -1 : 0] bbuf_tail_r;
    
    assign  bbuf_tail_pack = ddr_data[TPACK_SIZE*DATA_W-1 : 0];
    
    always @ (posedge clk) begin
<<<<<<< HEAD
        if (conf_valid && conf_ready) begin
=======
        if (conf_valid) begin
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
            bbuf_tail_cnt_r <= 0;
        end
        else if (ddr_valid && conf_trans_type == 2'b11) begin
            bbuf_tail_cnt_r <= (bbuf_tail_cnt_r == TPACK_SIZE - 1) ? 0 : bbuf_tail_cnt_r + 1;
        end
    end
    
    always @ (posedge clk) begin
        bbuf_tail_r <= bbuf_tail_pack[bbuf_tail_cnt_r];
    end
    
    always @ (posedge clk) begin
<<<<<<< HEAD
        if (conf_valid && conf_ready) begin
=======
        if (conf_valid) begin
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
            bbuf_tail_addr_r <= 0;
        end
        else if (ddr_valid && conf_trans_type == 2'b11) begin
            bbuf_tail_addr_r <= bbuf_tail_addr_r + 1;
        end
    end
    
//=============================================================================
// Load data to bias buffer
//=============================================================================
    
    localparam  DPACK_SIZE = DDR_W / DATA_W;
    
    reg     [6  -1 : 0] bbuf_data_cnt_r;
    reg     [ADDR_W -1 : 0] bbuf_data_addr_r;
    wire    [DPACK_SIZE -1 : 0][DATA_W -1 : 0] bbuf_data_pack;
    reg     [DATA_W -1 : 0] bbuf_data_r;
    
    assign  bbuf_data_pack = ddr_data;
    
    always @ (posedge clk) begin
<<<<<<< HEAD
        if (conf_valid && conf_ready) begin
=======
        if (conf_valid) begin
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
            bbuf_data_cnt_r <= 0;
        end
        else if (ddr_valid && conf_trans_type == 2'b10) begin
            bbuf_data_cnt_r <= (bbuf_data_cnt_r == DPACK_SIZE - 1) ? 0 : bbuf_data_cnt_r + 1;
        end
    end
    
    always @ (posedge clk) begin
        bbuf_data_r <= bbuf_data_pack[bbuf_data_cnt_r];
    end
    
    always @ (posedge clk) begin
<<<<<<< HEAD
        if (conf_valid && conf_ready) begin
=======
        if (conf_valid) begin
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
            bbuf_data_addr_r <= 0;
        end
        else if (ddr_valid && conf_trans_type == 2'b10) begin
            bbuf_data_addr_r <= bbuf_data_addr_r + 1;
        end
    end
    
//=============================================================================
// data and ready mux
//=============================================================================
    reg     [ADDR_W         -1 : 0] abuf_wr_addr_r;
    reg     [PE_NUM         -1 : 0] abuf_wr_data_en_r;
    reg     [PE_NUM         -1 : 0] abuf_wr_tail_en_r;
    
    reg     [ADDR_W -1 : 0] bbuf_wr_addr_r;
    reg                     bbuf_wr_data_en_r;
    reg                     bbuf_wr_tail_en_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            abuf_wr_data_en_r   <= '0;
            abuf_wr_tail_en_r   <= '0;
            abuf_wr_addr_r      <= 0;
        end
        else begin
            case(conf_trans_type)
            2'b00: begin
                abuf_wr_data_en_r <= {PE_NUM{ddr_valid}} & conf_mask;
                abuf_wr_tail_en_r <= '0;
                abuf_wr_addr_r    <= abuf_data_addr_r;
            end
            2'b01: begin
                abuf_wr_data_en_r <= '0;
                abuf_wr_tail_en_r <= {PE_NUM{ddr_valid}} & conf_mask;
                abuf_wr_addr_r    <= abuf_tail_addr_r;
            end
            default: begin
                abuf_wr_data_en_r <= '0;
                abuf_wr_tail_en_r <= '0;
                abuf_wr_addr_r    <= 0;
            end
            endcase
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            bbuf_wr_addr_r      <= 0;
            bbuf_wr_data_en_r   <= 0;
            bbuf_wr_tail_en_r   <= 0;
        end
        else begin
            case(conf_trans_type)
            2'b10: begin
                bbuf_wr_addr_r      <= bbuf_data_addr_r;
                bbuf_wr_data_en_r   <= {PE_NUM{ddr_valid}} & conf_mask;
                bbuf_wr_tail_en_r   <= 0;
            end
            2'b11: begin
                bbuf_wr_addr_r      <= bbuf_tail_addr_r;
                bbuf_wr_data_en_r   <= 0;
                bbuf_wr_tail_en_r   <= {PE_NUM{ddr_valid}} & conf_mask;
            end
            default: begin
                bbuf_wr_addr_r      <= 0;
                bbuf_wr_data_en_r   <= 0;
                bbuf_wr_tail_en_r   <= 0;
            end
            endcase
        end
    end
    
    assign  abuf_wr_addr    = abuf_wr_addr_r;
    assign  abuf_wr_data    = abuf_data_buf_r;
    assign  abuf_wr_tail    = abuf_tail_buf_r;
    assign  abuf_wr_data_en = abuf_wr_data_en_r;
    assign  abuf_wr_tail_en = abuf_wr_tail_en_r;
    
    assign  bbuf_wr_addr    = bbuf_wr_addr_r;
    assign  bbuf_wr_data    = bbuf_data_r;
    assign  bbuf_wr_tail    = bbuf_tail_r;
    assign  bbuf_wr_data_en = bbuf_wr_data_en_r;
    assign  bbuf_wr_tail_en = bbuf_wr_tail_en_r;
    
    // conf_ready signal
    reg     conf_ready_r;
    reg     [16 -1 : 0] byte_cnt_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            byte_cnt_r <= 0;
        end
<<<<<<< HEAD
        else if (conf_valid && conf_ready) begin
=======
        else if (conf_valid) begin
>>>>>>> 60554c7037d894b3799ea46f5d343372896bb277
            byte_cnt_r <= 0;
        end
        else if (ddr_valid && ddr_ready) begin
            byte_cnt_r <= byte_cnt_r + 32;
        end
    end
    
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
        else if (byte_cnt_r > conf_trans_num) begin
            conf_ready_r <= 1'b1;
        end
    end
    
    assign  conf_ready = conf_ready_r;
    
    // ready signal
    reg     ddr_ready_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            ddr_ready_r <= 1'b1;
        end
        else begin
            case(conf_trans_type)
            2'b00: ddr_ready_r <= 1'b1;
            2'b01: ddr_ready_r <= 1'b1;
            2'b10: ddr_ready_r <= (bbuf_data_cnt_r == DPACK_SIZE - 1) || (bbuf_data_addr_r == conf_trans_num);
            2'b11: ddr_ready_r <= (bbuf_tail_cnt_r == TPACK_SIZE - 1) || (bbuf_tail_addr_r == conf_trans_num);
            endcase
        end
    end
    
    assign  ddr_ready = ddr_ready_r;
    
endmodule