import GLOBAL_PARAM::DATA_W;
import GLOBAL_PARAM::TAIL_W;
import INS_CONST::*;

module rx_config#(
    parameter PE_NUM    = 32,
    )(
    input           clk,
    input           rst,

    // global registers
    input   [4      -1 : 0] layer_type,
    input   [8      -1 : 0] in_img_width,
    input   [8      -1 : 0] out_img_width,
    input   [4      -1 : 0] in_ch_seg,
    input   [4      -1 : 0] out_ch_seg,
    input                   depool,

    // instruction input
    input                   ins_valid,
    output                  ins_ready,
    input   [INST_W -1 : 0] ins,

    // return signal
    output  [6      -1 ：0] rx_done_buf_id,
    output  [4      -1 : 0] rx_done_opcode,
    output                  rx_done_pulse,

    // configuration port
    output                  ibuf_conf_valid,
    input                   ibuf_conf_ready,
    output  [4      -1 : 0] ibuf_conf_mode,
    output  [8      -1 : 0] ibuf_conf_idx_num,
    output  [PE_NUM -1 : 0] ibuf_conf_mask,
    
    output                  dbuf_conf_valid,
    input                   dbuf_conf_ready,
    output  [4      -1 : 0] dbuf_conf_mode,
    output  [4      -1 : 0] dbuf_conf_ch_num,
    output  [4      -1 : 0] dbuf_conf_row_num,
    output  [4      -1 : 0] dbuf_conf_pix_num,
    output  [PE_NUM -1 : 0] dbuf_conf_mask,
    output                  dbuf_conf_depool,
    
    output                  pbuf_conf_valid,
    input                   pbuf_conf_ready,
    output  [16     -1 : 0] pbuf_conf_trans_num,
    output  [4      -1 : 0] pbuf_conf_mode,     
    output  [4      -1 : 0] pbuf_conf_ch_num,   
    output  [4      -1 : 0] pbuf_conf_pix_num,  
    output  [2      -1 : 0] pbuf_conf_row_num,  
    output                  pbuf_conf_depool,
    output  [PE_NUM -1 : 0] pbuf_conf_mask,

    output                  abuf_conf_valid,
    input                   abuf_conf_ready,
    output  [2      -1 : 0] abuf_conf_trans_type,
    output  [16     -1 : 0] abuf_conf_trans_num,
    output  [PE_NUM -1 : 0] abuf_conf_mask,

    output  [1 : 0] ddr1_ready_mux,
    output  [1 : 0] ddr2_ready_mux,
    
    output  [1 : 0] dbuf_ddr_sel,
    output          ibuf_ddr_sel,
    output  [1 : 0] pbuf_ddr_sel,
    output          abuf_ddr_sel
    );

    // decoding logic
    wire    [3 : 0] opcode  = ins[61:58];
    wire    [5 : 0] buf_id  = ins[57:52];
    wire    [7 : 0] size    = ins[39:32];
    wire    [3 : 0] pix_num = ins[43:40];
    wire    [3 : 0] row_num = ins[47:44];
    wire    [31: 0] st_addr = ins[31: 0];
    wire    [11: 0] p_size  = ins[51:40];

    // register output
    reg                     ibuf_conf_valid_r;
    reg     [4      -1 : 0] ibuf_conf_mode_r;
    reg     [8      -1 : 0] ibuf_conf_idx_num_r;
    reg     [PE_NUM -1 : 0] ibuf_conf_mask_r;
    
    reg                     dbuf_conf_valid_r;
    reg     [4      -1 : 0] dbuf_conf_mode_r;
    reg     [4      -1 : 0] dbuf_conf_ch_num_r;
    reg     [4      -1 : 0] dbuf_conf_row_num_r;
    reg     [4      -1 : 0] dbuf_conf_pix_num_r;
    reg     [PE_NUM -1 : 0] dbuf_conf_mask_r;
    
    reg                     pbuf_conf_valid_r;
    reg     [16     -1 : 0] pbuf_conf_trans_num_r;
    reg     [4      -1 : 0] pbuf_conf_mode_r;     
    reg     [4      -1 : 0] pbuf_conf_ch_num_r;   
    reg     [4      -1 : 0] pbuf_conf_pix_num_r;  
    reg     [2      -1 : 0] pbuf_conf_row_num_r;  
    reg     [PE_NUM -1 : 0] pbuf_conf_mask_r;

    reg                     abuf_conf_valid_r;
    reg     [2      -1 : 0] abuf_conf_trans_type_r;
    reg     [16     -1 : 0] abuf_conf_trans_num_r;
    reg     [PE_NUM -1 : 0] abuf_conf_mask_r;

    reg     [1 : 0] dbuf_ddr_sel_r;
    reg             ibuf_ddr_sel_r;
    reg     [1 : 0] pbuf_ddr_sel_r;
    reg             abuf_ddr_sel_r;

    reg     [1 : 0] ddr1_ready_mux_r;
    reg     [1 : 0] ddr2_ready_mux_r;

    assign  ibuf_conf_valid     = ibuf_conf_valid_r;
    assign  ibuf_conf_mode      = ibuf_conf_mode_r;
    assign  ibuf_conf_idx_num   = ibuf_conf_idx_num_r;
    assign  ibuf_conf_mask      = ibuf_conf_mask_r;

    assign  dbuf_conf_valid     = dbuf_conf_valid_r;
    assign  dbuf_conf_mode      = dbuf_conf_mode_r;
    assign  dbuf_conf_ch_num    = dbuf_conf_ch_num_r;
    assign  dbuf_conf_row_num   = dbuf_conf_row_num_r;
    assign  dbuf_conf_pix_num   = dbuf_conf_pix_num_r;
    assign  dbuf_conf_mask      = dbuf_conf_mask_r;
    assign  dbuf_conf_depool    = depool;

    assign  pbuf_conf_valid     = pbuf_conf_valid_r;
    assign  pbuf_conf_trans_num = pbuf_conf_trans_num_r;
    assign  pbuf_conf_mode      = pbuf_conf_mode_r;     
    assign  pbuf_conf_ch_num    = pbuf_conf_ch_num_r;   
    assign  pbuf_conf_pix_num   = pbuf_conf_pix_num_r;  
    assign  pbuf_conf_row_num   = pbuf_conf_row_num_r;  
    assign  pbuf_conf_depool    = depool;
    assign  pbuf_conf_mask      = pbuf_conf_mask_r;

    assign  abuf_conf_valid     = abuf_conf_valid_r;
    assign  abuf_conf_trans_type= abuf_conf_trans_type_r;
    assign  abuf_conf_trans_num = abuf_conf_trans_num_r;
    assign  abuf_conf_mask      = abuf_conf_mask_r;
    
    assign dbuf_ddr_sel         = dbuf_ddr_sel_r;
    assign ibuf_ddr_sel         = ibuf_ddr_sel_r;
    assign pbuf_ddr_sel         = pbuf_ddr_sel_r;
    assign abuf_ddr_sel         = abuf_ddr_sel_r;

    assign ddr1_ready_mux       = ddr1_ready_mux_r;
    assign ddr2_ready_mux       = ddr2_ready_mux_r;

//=============================================================================
// Configuration Logic
//=============================================================================

    localparam TD_RATE = TAIL_W / DATA_W;
    
    // i buffer configuration
    always @ (posedge clk) begin
        if (rst) begin
            ibuf_conf_valid_r   <= 1'b0;
            ibuf_conf_mode_r    <= 4'b0000;
            ibuf_conf_idx_num_r <= 0;
            ibuf_conf_mask_r    <= '0;
        end
        else if (ins_valid && ins_ready && opcode == RD_OP_DW) begin
            ibuf_conf_valid_r   <= 1'b1;
            ibuf_conf_mode_r    <= layer_type;
            ibuf_conf_idx_num_r <= size;
            ibuf_conf_mask_r    <= layer_type[0] ? (1 << buf_id) : (15 << (buf_id << 2));
        end 
        else begin
            ibuf_conf_valid_r   <= 1'b0;
        end
    end
    
    // d buffer configuration
    always @ (posedge clk) begin
        if (rst) begin
            dbuf_conf_valid_r   <= 1'b0;
            dbuf_conf_mode_r    <= 4'b0000;
            dbuf_conf_ch_num_r  <= 0;
            dbuf_conf_row_num_r <= 0;
            dbuf_conf_pix_num_r <= 0;
            dbuf_conf_mask_r    <= '0;
        end
        else if (ins_valid && ins_ready && (opcode == RD_OP_D || opcode == RD_OP_G)) begin
            dbuf_conf_valid_r   <= 1'b1;
            dbuf_conf_mode_r    <= layer_type;
            dbuf_conf_ch_num_r  <= in_ch_seg;
            dbuf_conf_row_num_r <= row_num;
            dbuf_conf_pix_num_r <= pix_num;
            dbuf_conf_mask_r    <= '1;
        end
        else begin
            dbuf_conf_valid_r   <= 1'b0;
        end
    end
    
    // p buffer configuration
    always @ (posedge clk) begin
        if (rst) begin
            pbuf_conf_valid_r       <= 1'b0;
            pbuf_conf_trans_num_r   <= 0;
            pbuf_conf_mode_r        <= 4'b0000;  
            pbuf_conf_ch_num_r      <= 0;
            pbuf_conf_pix_num_r     <= 0;
            pbuf_conf_row_num_r     <= 0;
            pbuf_conf_mask_r        <= 0;
        end
        else if (ins_valid && ins_ready && 
            (((opcode == RD_OP_G)  && (layer_type[2:1] == 2'b10)) || 
             ((opcode == RD_OP_DW) && (layer_type[2:1] != 2'b10)))) begin
            pbuf_conf_valid_r       <= 1'b1;
            pbuf_conf_trans_num_r   <= p_size;
            pbuf_conf_mode_r        <= layer_type;  
            pbuf_conf_ch_num_r      <= (opcode == RD_OP_G) ? out_ch_seg : size;
            pbuf_conf_pix_num_r     <= pix_num;
            pbuf_conf_row_num_r     <= row_num;
            pbuf_conf_mask_r        <= layer_type[0] ? (1 << buf_id) : (15 << (buf_id << 2));
        end
        else begin
            pbuf_conf_valid_r       <= 1'b0;
        end
    end
    
    // a buffer configuration
    always @ (posedge clk) begin
        if (rst) begin
            abuf_conf_valid_r       <= 1'b0;
            abuf_conf_trans_type_r  <= 4'b0000;
            abuf_conf_trans_num_r   <= 0;
            abuf_conf_mask_r        <= '0;
        end
        else if (ins_valid && ins_ready && layer_type[2:1] == 2'b10 &&
            (opcode != RD_OP_D) && (opcode != RD_OP_G)) begin
            abuf_conf_valid_r       <= 1'b1;
            abuf_conf_trans_type_r  <= layer_type[1:0];
            abuf_conf_trans_num_r   <= opcode[1] ? (p_size * TD_RATE) : p_size;
            abuf_conf_mask_r        <= layer_type[0] ? (1 << buf_id) : (15 << (buf_id << 2));        
        end
        else begin
            abuf_conf_valid_r       <= 1'b0;
        end
    end

//=============================================================================
// DDR ready and valid signal mux control
//=============================================================================

    // ready signal mux control
    always @ (posedge clk) begin
        if (rst) begin
            ddr1_ready_mux_r <= 2'b00;
        end
        else begin
            case({dbuf_conf_valid_r, ibuf_conf_valid_r, pbuf_conf_valid_r, abuf_conf_valid_r})
            4'b1000: ddr1_ready_mux_r <= 2'b00; // d buf
            4'b0110: ddr1_ready_mux_r <= 2'b01; // i buf
            4'b0101: ddr1_ready_mux_r <= 2'b01; // i buf
            4'b0010: ddr1_ready_mux_r <= 2'b10; // p buf
            default: ddr1_ready_mux_r <= ddr1_ready_mux_r;
            endcase
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            ddr2_ready_mux_r <= 2'b00;
        end
        else begin
            case({dbuf_conf_valid_r, ibuf_conf_valid_r, pbuf_conf_valid_r, abuf_conf_valid_r})
            4'b1000: ddr2_ready_mux_r <= 2'b00;
            4'b0110: ddr2_ready_mux_r <= 2'b01;
            4'b0101: ddr2_ready_mux_r <= 2'b10;
            4'b0001: ddr2_ready_mux_r <= 2'b10;
            default: ddr2_ready_mux_r <= ddr2_ready_mux_r;
            endcase
        end
    end

//=============================================================================
// Status Logic
//=============================================================================

    localparam STAT_IDLE = 2'b00;
    localparam STAT_CONF = 2'b01;
    localparam STAT_WORK = 2'b10;
    
    reg     [1 : 0] config_stat_r;
    wire    all_conf_ready = ibuf_conf_ready && pbuf_conf_ready && dbuf_conf_ready && abuf_conf_ready;
    
    always @ (posedge clk) begin
        if (rst) begin
            config_stat_r   <= STAT_IDLE;
        end
        else begin
            case(config_stat_r)
            STAT_IDLE: config_stat_r <= (ins_valid && ins_ready) ? STAT_CONF : STAT_WORK;
            STAT_CONF: config_stat_r <= STAT_WORK;
            STAT_WORK: config_stat_r <= (all_conf_ready) ? STAT_IDLE : STAT_WORK;
            endcase
        end
    end
    
    reg     ready_r;
    assign  ins_ready = ready_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            ready_r <= 1'b1;
        end
        else if (ins_ready && ins_valid) begin
            ready_r <= 1'b0;
        end
        else if (config_stat_r == STAT_WORK && all_conf_ready) begin
            ready_r <= 1'b1;
        end
    end    

    reg     [PE_NUM -1 ：0] rx_done_opcode_r;
    reg     [4      -1 : 0] rx_done_buf_id_r;
    assign  rx_done_buf_id = rx_done_buf_id_r;
    assign  rx_done_opcode = rx_done_opcode_r;

    always @ (posedge clk) begin
        if (ins_valid && ins_ready) begin
            rx_done_opcode_r <= opcode;
            rx_done_buf_id_r <= buf_id;
        end
    end

    posedge2pulse rx_done(.clk(clk), .rst(rst), .a(all_conf_ready), .b(rx_done_pulse));

endmodule