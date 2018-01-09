import GLOBAL_PARAM::DDR_ADDR_W;
import GLOBAL_PARAM::BURST_W;
import GLOBAL_PARAM::DATA_W;
import GLOBAL_PARAM::TAIL_W;
import INS_CONST::*;

module ddr2pe_config#(
    parameter   PE_NUM  = 32
    )(
    input           clk,
    input           rst,
        
    input   [4      -1 : 0] layer_type,
    input   [8      -1 : 0] in_img_width,
    input   [8      -1 : 0] out_img_width,
    input   [4      -1 : 0] in_ch_seg,
    input   [4      -1 : 0] out_ch_seg,
    input                   depool,
    
    input                   ins_valid,
    output                  ins_ready,
    input   [INST_W -1 : 0] ins,
    
    output                  ibuf_start,
    input                   ibuf_done,
    output  [4      -1 : 0] ibuf_conf_mode,
    output  [8      -1 : 0] ibuf_conf_idx_num,
    output  [PE_NUM -1 : 0] ibuf_conf_mask,
    
    output                  dbuf_start,
    input                   dbuf_done,
    output  [4      -1 : 0] dbuf_conf_mode,
    output  [4      -1 : 0] dbuf_conf_ch_num,
    output  [4      -1 : 0] dbuf_conf_row_num,
    output  [4      -1 : 0] dbuf_conf_pix_num,
    output  [PE_NUM -1 : 0] dbuf_conf_mask,
    output                  dbuf_conf_depool,
    
    output                  pbuf_start,
    input                   pbuf_done,
    output  [16     -1 : 0] pbuf_conf_trans_num,
    output  [4      -1 : 0] pbuf_conf_mode,     
    output  [4      -1 : 0] pbuf_conf_ch_num,   
    output  [4      -1 : 0] pbuf_conf_pix_num,  
    output  [2      -1 : 0] pbuf_conf_row_num,  
    output                  pbuf_conf_depool,
    output  [PE_NUM -1 : 0] pbuf_conf_mask,

    output                  abuf_start,
    input                   abuf_done,
    output  [2      -1 : 0] abuf_conf_trans_type,
    output  [16     -1 : 0] abuf_conf_trans_num,
    output  [PE_NUM -1 : 0] abuf_conf_mask,
    
    output                      ddr1_start,
    input                       ddr1_done,
    output  [DDR_ADDR_W -1 : 0] ddr1_st_addr,
    output  [BURST_W    -1 : 0] ddr1_burst,
    output  [DDR_ADDR_W -1 : 0] ddr1_step,
    output  [BURST_W    -1 : 0] ddr1_burst_num,
    
    output                      ddr2_start,
    input                       ddr2_done,
    output  [DDR_ADDR_W -1 : 0] ddr2_st_addr,
    output  [BURST_W    -1 : 0] ddr2_burst,
    output  [DDR_ADDR_W -1 : 0] ddr2_step,
    output  [BURST_W    -1 : 0] ddr2_burst_num,
    
    output  [1 : 0] ddr1_ready_mux,
    output  [1 : 0] ddr2_ready_mux,
    
    output  [1 : 0] dbuf_ddr_sel,
    output          ibuf_ddr_sel,
    output  [1 : 0] pbuf_ddr_sel,
    output          abuf_ddr_sel
    );
    
    wire    [3 : 0] opcode  = ins[61:58];
    wire    [5 : 0] buf_id  = ins[57:52];
    wire    [7 : 0] size    = ins[39:32];
    wire    [3 : 0] pix_num = ins[43:40];
    wire    [3 : 0] row_num = ins[47:44];
    wire    [31: 0] st_addr = ins[31: 0];
    wire    [11: 0] p_size  = ins[51:40];
    
    reg                     ibuf_start_r;
    reg     [4      -1 : 0] ibuf_conf_mode_r;
    reg     [8      -1 : 0] ibuf_conf_idx_num_r;
    reg     [PE_NUM -1 : 0] ibuf_conf_mask_r;
    
    reg                     dbuf_start_r;
    reg     [4      -1 : 0] dbuf_conf_mode_r;
    reg     [4      -1 : 0] dbuf_conf_ch_num_r;
    reg     [4      -1 : 0] dbuf_conf_row_num_r;
    reg     [4      -1 : 0] dbuf_conf_pix_num_r;
    reg     [PE_NUM -1 : 0] dbuf_conf_mask_r;
    
    reg                     pbuf_start_r;
    reg     [16     -1 : 0] pbuf_conf_trans_num_r;
    reg     [4      -1 : 0] pbuf_conf_mode_r;     
    reg     [4      -1 : 0] pbuf_conf_ch_num_r;   
    reg     [4      -1 : 0] pbuf_conf_pix_num_r;  
    reg     [2      -1 : 0] pbuf_conf_row_num_r;  
    reg     [PE_NUM -1 : 0] pbuf_conf_mask_r;

    reg                     abuf_start_r;
    reg     [2      -1 : 0] abuf_conf_trans_type_r;
    reg     [16     -1 : 0] abuf_conf_trans_num_r;
    reg     [PE_NUM -1 : 0] abuf_conf_mask_r;
    
    reg                         ddr1_start_r;
    reg     [DDR_ADDR_W -1 : 0] ddr1_st_addr_r;
    reg     [BURST_W    -1 : 0] ddr1_burst_r;
    reg     [DDR_ADDR_W -1 : 0] ddr1_step_r;
    reg     [BURST_W    -1 : 0] ddr1_burst_num_r;
    
    reg                         ddr2_start_r;
    reg     [DDR_ADDR_W -1 : 0] ddr2_st_addr_r;
    reg     [BURST_W    -1 : 0] ddr2_burst_r;
    reg     [DDR_ADDR_W -1 : 0] ddr2_step_r;
    reg     [BURST_W    -1 : 0] ddr2_burst_num_r;
    
    reg     [1 : 0] dbuf_ddr_sel_r;
    reg             ibuf_ddr_sel_r;
    reg     [1 : 0] pbuf_ddr_sel_r;
    reg             abuf_ddr_sel_r;
    
    reg     [4 : 0] in_ch_seg_r;
    reg     [4 : 0] out_ch_seg_r;
    reg     [7 : 0] in_img_width_r;
    reg     [7 : 0] out_img_width_r;

    always @ (posedge clk) begin
        in_ch_seg_r     <= in_ch_seg + 1;
        out_ch_seg_r    <= out_ch_seg + 1;
        in_img_width_r  <= in_img_width + 1;
        out_img_width_r <= out_img_width + 1;
    end

//=============================================================================
// Configuration Logic
//=============================================================================

    localparam TD_RATE = TAIL_W / DATA_W;
    
    // i buffer configuration
    always @ (posedge clk) begin
        if (rst) begin
            ibuf_start_r        <= 1'b0;
            ibuf_conf_mode_r    <= 4'b0000;
            ibuf_conf_idx_num_r <= 0;
            ibuf_conf_mask_r    <= '0;
        end
        else if (ins_valid && ins_ready && opcode == RD_OP_DW) begin
            ibuf_start_r        <= 1'b1;
            ibuf_conf_mode_r    <= layer_type;
            ibuf_conf_idx_num_r <= size;
            ibuf_conf_mask_r    <= layer_type[0] ? (1 << buf_id) : (15 << (buf_id << 2));
        end 
        else begin
            ibuf_start_r        <= 1'b0;
        end
    end
    
    // d buffer configuration
    always @ (posedge clk) begin
        if (rst) begin
            dbuf_start_r        <= 1'b0;
            dbuf_conf_mode_r    <= 4'b0000;
            dbuf_conf_ch_num_r  <= 0;
            dbuf_conf_row_num_r <= 0;
            dbuf_conf_pix_num_r <= 0;
            dbuf_conf_mask_r    <= '0;
        end
        else if (ins_valid && ins_ready && (opcode == RD_OP_D || opcode == RD_OP_G)) begin
            dbuf_start_r        <= 1'b1;
            dbuf_conf_mode_r    <= layer_type;
            dbuf_conf_ch_num_r  <= in_ch_seg;
            dbuf_conf_row_num_r <= row_num;
            dbuf_conf_pix_num_r <= pix_num;
            dbuf_conf_mask_r    <= '1;
        end
        else begin
            dbuf_start_r        <= 1'b0;
        end
    end
    
    // p buffer configuration
    always @ (posedge clk) begin
        if (rst) begin
            pbuf_start_r            <= 1'b0;
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
            pbuf_start_r            <= 1'b1;
            pbuf_conf_trans_num_r   <= p_size;
            pbuf_conf_mode_r        <= layer_type;  
            pbuf_conf_ch_num_r      <= (opcode == RD_OP_G) ? out_ch_seg : size;
            pbuf_conf_pix_num_r     <= pix_num;
            pbuf_conf_row_num_r     <= row_num;
            pbuf_conf_mask_r        <= layer_type[0] ? (1 << buf_id) : (15 << (buf_id << 2));
        end
        else begin
            pbuf_start_r            <= 1'b0;
        end
    end
    
    // a buffer configuration
    always @ (posedge clk) begin
        if (rst) begin
            abuf_start_r            <= 1'b0;
            abuf_conf_trans_type_r  <= 4'b0000;
            abuf_conf_trans_num_r   <= 0;
            abuf_conf_mask_r        <= '0;
        end
        else if (ins_valid && ins_ready && layer_type[2:1] == 2'b10 &&
            (opcode != RD_OP_D) && (opcode != RD_OP_G)) begin
            abuf_start_r            <= 1'b1;
            abuf_conf_trans_type_r  <= layer_type[1:0];
            abuf_conf_trans_num_r   <= opcode[1] ? (p_size * TD_RATE) : p_size;
            abuf_conf_mask_r        <= layer_type[0] ? (1 << buf_id) : (15 << (buf_id << 2));        
        end
        else begin
            abuf_start_r            <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            ddr1_start_r    <= 1'b0;
            ddr1_st_addr_r  <= 0;
            ddr1_burst_r    <= 0;
            ddr1_step_r     <= 0;  
            ddr1_burst_num_r<= 0;  
        end
        else if (ins_valid && ins_ready) begin
            if (opcode == 4'b0100) begin
                ddr1_start_r    <= 1'b1;
                ddr1_st_addr_r  <= st_addr;
                ddr1_burst_r    <= size + 1;
                ddr1_step_r     <= 0;
                ddr1_burst_num_r<= 0;
            end
            else if (opcode[3:2] == 2'b00) begin
                ddr1_start_r    <= 1'b1;
                ddr1_st_addr_r  <= st_addr;
                ddr1_burst_r    <= ((pix_num + 1) * in_ch_seg_r) << 5;
                ddr1_step_r     <= ((pix_num + 1) * in_img_width_r) << 5;
                ddr1_burst_num_r<= row_num;
            end
            else begin
                ddr1_start_r    <= 1'b0;
            end
        end
        else begin
            ddr1_start_r    <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            ddr2_start_r    <= 1'b0;
            ddr2_st_addr_r  <= 0;
            ddr2_burst_r    <= 0;
            ddr2_step_r     <= 0;
            ddr2_burst_num_r<= 0;
        end
        else if (ins_valid && ins_ready) begin
            if (opcode == RD_OP_G) begin
                ddr2_start_r    <= 1'b1;
                ddr2_st_addr_r  <= st_addr;
                ddr2_burst_r    <= ((pix_num + 1) * out_ch_seg_r) << 5;
                ddr2_step_r     <= ((pix_num + 1) * out_img_width_r) << 5;
                ddr2_burst_num_r<= row_num;
            end
            else if (opcode[3:2] == 2'b01) begin
                ddr2_start_r    <= 1'b1;
                ddr2_st_addr_r  <= st_addr;
                ddr2_burst_r    <= opcode[1] ? (p_size * TD_RATE) : p_size;
                ddr2_step_r     <= 0;
                ddr2_burst_num_r<= 0;
            end
            else begin
                ddr2_start_r    <= 1'b0;
            end
        end
        else begin
            ddr2_start_r    <= 1'b0;
        end
    end
    
    assign  ibuf_start          = ibuf_start_r;
    assign  ibuf_conf_mode      = ibuf_conf_mode_r;
    assign  ibuf_conf_idx_num   = ibuf_conf_idx_num_r;
    assign  ibuf_conf_mask      = ibuf_conf_mask_r;

    assign  dbuf_start          = dbuf_start_r;
    assign  dbuf_conf_mode      = dbuf_conf_mode_r;
    assign  dbuf_conf_ch_num    = dbuf_conf_ch_num_r;
    assign  dbuf_conf_row_num   = dbuf_conf_row_num_r;
    assign  dbuf_conf_pix_num   = dbuf_conf_pix_num_r;
    assign  dbuf_conf_mask      = dbuf_conf_mask_r;
    assign  dbuf_conf_depool    = depool;

    assign  pbuf_start          = pbuf_start_r;
    assign  pbuf_conf_trans_num = pbuf_conf_trans_num_r;
    assign  pbuf_conf_mode      = pbuf_conf_mode_r;     
    assign  pbuf_conf_ch_num    = pbuf_conf_ch_num_r;   
    assign  pbuf_conf_pix_num   = pbuf_conf_pix_num_r;  
    assign  pbuf_conf_row_num   = pbuf_conf_row_num_r;  
    assign  pbuf_conf_depool    = depool;
    assign  pbuf_conf_mask      = pbuf_conf_mask_r;

    assign  abuf_start          = abuf_start_r;
    assign  abuf_conf_trans_type= abuf_conf_trans_type_r;
    assign  abuf_conf_trans_num = abuf_conf_trans_num_r;
    assign  abuf_conf_mask      = abuf_conf_mask_r;
    
    assign  ddr1_start          = ddr1_start_r;
    assign  ddr1_st_addr        = ddr1_st_addr_r;
    assign  ddr1_burst          = ddr1_burst_r;
    assign  ddr1_step           = ddr1_step_r;
    assign  ddr1_burst_num      = ddr1_burst_num_r;

    assign  ddr2_start          = ddr2_start_r;
    assign  ddr2_st_addr        = ddr2_st_addr_r;
    assign  ddr2_burst          = ddr2_burst_r;
    assign  ddr2_step           = ddr2_step_r;
    assign  ddr2_burst_num      = ddr2_burst_num_r;

//=============================================================================
// Status Logic
//=============================================================================
    
    localparam STAT_IDLE = 2'b00;
    localparam STAT_CONF = 2'b01;
    localparam STAT_WORK = 2'b10;
    
    reg     [1 : 0] config_stat_r;
    wire    all_done = ibuf_done && pbuf_done && dbuf_done && abuf_done;
    
    always @ (posedge clk) begin
        if (rst) begin
            config_stat_r   <= STAT_IDLE;
        end
        else begin
            case(config_stat_r)
            STAT_IDLE: config_stat_r <= (ins_valid && ins_ready) ? STAT_CONF : STAT_WORK;
            STAT_CONF: config_stat_r <= STAT_WORK;
            STAT_WORK: config_stat_r <= (&all_done) ? STAT_IDLE : STAT_WORK;
            endcase
        end
    end
    
    reg     ready_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            ready_r <= 1'b1;
        end
        else if (ins_ready && ins_valid) begin
            ready_r <= 1'b0;
        end
        else if (config_stat_r == STAT_WORK && all_done) begin
            ready_r <= 1'b1;
        end
    end
    
    assign  ins_ready = ready_r;

//=============================================================================
// DDR ready signal mux control
//=============================================================================
    reg     [1 : 0] ddr1_ready_mux_r;
    reg     [1 : 0] ddr2_ready_mux_r;    
    
    always @ (posedge clk) begin
        if (rst) begin
            ddr1_ready_mux_r <= 1'b0;
        end
        else begin
            case({dbuf_start_r, ibuf_start_r, pbuf_start_r, abuf_start_r})
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
            case({dbuf_start_r, ibuf_start_r, pbuf_start_r, abuf_start_r})
            4'b1000: ddr2_ready_mux_r <= 2'b00;
            4'b0110: ddr2_ready_mux_r <= 2'b01;
            4'b0101: ddr2_ready_mux_r <= 2'b10;
            4'b0001: ddr2_ready_mux_r <= 2'b10;
            default: ddr2_ready_mux_r <= ddr2_ready_mux_r;
            endcase
        end
    end
    
    assign  ddr1_ready_mux = ddr1_ready_mux_r;
    assign  ddr2_ready_mux = ddr2_ready_mux_r;
    
    wire    ibuf_done_pulse;
    wire    dbuf_done_pulse;
    wire    pbuf_done_pulse;
    wire    abuf_done_pulse;
    
    posedge2pulse idone(.clk(clk), .rst(rst), .a(ibuf_done), .b(ibuf_done_pulse));
    posedge2pulse ddone(.clk(clk), .rst(rst), .a(dbuf_done), .b(dbuf_done_pulse));
    posedge2pulse pdone(.clk(clk), .rst(rst), .a(pbuf_done), .b(pbuf_done_pulse));
    posedge2pulse adone(.clk(clk), .rst(rst), .a(abuf_done), .b(abuf_done_pulse));
    
    // ibuf valid signal
    always @ (posedge clk) begin
        if (rst) begin
            ibuf_ddr_sel_r <= 1'b0;
        end
        else if (ins_valid && ins_ready && opcode == RD_OP_DW) begin
            ibuf_ddr_sel_r <= 1'b1;
        end
        else if (ibuf_done_pulse) begin
            ibuf_ddr_sel_r <= 1'b0;
        end
    end
    
    // dbuf valid signal
    always @ (posedge clk) begin
        if (rst) begin
            dbuf_ddr_sel_r <= 2'b00;
        end
        else if (ins_valid && ins_ready && (opcode == RD_OP_D || opcode == RD_OP_G)) begin
            if (opcode == RD_OP_D) begin
                dbuf_ddr_sel_r <= 2'b01;
            end
            else if (opcode == RD_OP_G) begin
                dbuf_ddr_sel_r <= 2'b11;
            end            
        end
        else if (dbuf_done_pulse) begin
            dbuf_ddr_sel_r <= 2'b00;
        end
    end

    // pbuf valid signal
    always @ (posedge clk) begin
        if (rst) begin
            pbuf_ddr_sel_r <= 2'b00;
        end
        else if (ins_valid && ins_ready && 
            (((opcode == RD_OP_G)  && (layer_type[2:1] == 2'b10)) || 
             ((opcode == RD_OP_DW) && (layer_type[2:1] != 2'b10)))) begin
            if (opcode == RD_OP_D) begin
                pbuf_ddr_sel_r <= 2'b01;
            end
            else if (opcode == RD_OP_DW) begin
                pbuf_ddr_sel_r <= 2'b11;
            end            
        end
        else if (dbuf_done_pulse) begin
            pbuf_ddr_sel_r <= 2'b00;
        end
    end
    
    // abuf valid signal
    always @ (posedge clk) begin
        if (rst) begin
            abuf_ddr_sel_r <= 1'b0;
        end
        else if (ins_valid && ins_ready && layer_type[2:1] == 2'b10 &&
            (opcode != RD_OP_D) && (opcode != RD_OP_G)) begin
            abuf_ddr_sel_r <= 1'b1;
        end
        else if (abuf_done_pulse) begin
            abuf_ddr_sel_r <= 1'b0;
        end
    end
    
    assign dbuf_ddr_sel = dbuf_ddr_sel_r;
    assign ibuf_ddr_sel = ibuf_ddr_sel_r;
    assign pbuf_ddr_sel = pbuf_ddr_sel_r;
    assign abuf_ddr_sel = abuf_ddr_sel_r;
    
endmodule