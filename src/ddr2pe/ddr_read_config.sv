import GLOBAL_PARAM::DDR_ADDR_W;
import GLOBAL_PARAM::BURST_W;
import GLOBAL_PARAM::DATA_W;
import GLOBAL_PARAM::TAIL_W;
import INS_CONST::*;

module ddr_read_config(
    input   clk,
    input   rst,

    // global registers
    input   [8      -1 : 0] in_img_width,
    input   [8      -1 : 0] out_img_width,
    input   [4      -1 : 0] in_ch_seg,
    input   [4      -1 : 0] out_ch_seg,

    // instruction input
    input                   ins_valid,
    output                  ins_ready,
    input   [INST_W -1 : 0] ins,

    // instruction transfer to data receiving module
    output                  rx_ins_valid,
    input                   rx_ins_ready,
    output  [INST_W -1 : 0] rx_ins,

    output                      ddr1_conf_valid,
    input                       ddr1_conf_ready,
    output  [DDR_ADDR_W -1 : 0] ddr1_st_addr,
    output  [BURST_W    -1 : 0] ddr1_burst,
    output  [DDR_ADDR_W -1 : 0] ddr1_step,
    output  [BURST_W    -1 : 0] ddr1_burst_num,
    
    output                      ddr2_conf_valid,
    input                       ddr2_conf_ready,
    output  [DDR_ADDR_W -1 : 0] ddr2_st_addr,
    output  [BURST_W    -1 : 0] ddr2_burst,
    output  [DDR_ADDR_W -1 : 0] ddr2_step,
    output  [BURST_W    -1 : 0] ddr2_burst_num
    );

    localparam TD_RATE = TAIL_W / DATA_W;

    // decoding logic
    wire    [3 : 0] opcode  = ins[61:58];
    wire    [5 : 0] buf_id  = ins[57:52];
    wire    [7 : 0] size    = ins[39:32];
    wire    [3 : 0] pix_num = ins[43:40];
    wire    [3 : 0] row_num = ins[47:44];
    wire    [31: 0] st_addr = ins[31: 0];
    wire    [11: 0] p_size  = ins[51:40];

    // register configuration output 
    reg                         ddr1_conf_valid_r;
    reg     [DDR_ADDR_W -1 : 0] ddr1_st_addr_r;
    reg     [BURST_W    -1 : 0] ddr1_burst_r;
    reg     [DDR_ADDR_W -1 : 0] ddr1_step_r;
    reg     [BURST_W    -1 : 0] ddr1_burst_num_r;
    
    reg                         ddr2_conf_valid_r;
    reg     [DDR_ADDR_W -1 : 0] ddr2_st_addr_r;
    reg     [BURST_W    -1 : 0] ddr2_burst_r;
    reg     [DDR_ADDR_W -1 : 0] ddr2_step_r;
    reg     [BURST_W    -1 : 0] ddr2_burst_num_r;

    assign  ddr1_conf_valid     = ddr1_conf_valid_r;
    assign  ddr1_st_addr        = ddr1_st_addr_r;
    assign  ddr1_burst          = ddr1_burst_r;
    assign  ddr1_step           = ddr1_step_r;
    assign  ddr1_burst_num      = ddr1_burst_num_r;

    assign  ddr2_conf_valid     = ddr2_conf_valid_r;
    assign  ddr2_st_addr        = ddr2_st_addr_r;
    assign  ddr2_burst          = ddr2_burst_r;
    assign  ddr2_step           = ddr2_step_r;
    assign  ddr2_burst_num      = ddr2_burst_num_r;

//=============================================================================
// Configuration Logic
//=============================================================================

    always @ (posedge clk) begin
        if (rst) begin
            ddr1_conf_valid_r   <= 1'b0;
            ddr1_st_addr_r      <= 0;
            ddr1_burst_r        <= 0;
            ddr1_step_r         <= 0;  
            ddr1_burst_num_r    <= 0;  
        end
        else if (ins_valid && ins_ready) begin
            if (opcode == 4'b0100) begin
                ddr1_conf_valid_r   <= 1'b1;
                ddr1_st_addr_r      <= st_addr;
                ddr1_burst_r        <= size + 1;
                ddr1_step_r         <= 0;
                ddr1_burst_num_r    <= 0;
            end
            else if (opcode[3:2] == 2'b00) begin
                ddr1_conf_valid_r   <= 1'b1;
                ddr1_st_addr_r      <= st_addr;
                ddr1_burst_r        <= ((pix_num + 1) * in_ch_seg) << 5;
                ddr1_step_r         <= ((pix_num + 1) * in_img_width) << 5;
                ddr1_burst_num_r    <= row_num;
            end
            else begin
                ddr1_conf_valid_r   <= 1'b0;
            end
        end
        else begin
            ddr1_conf_valid_r   <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            ddr2_conf_valid_r   <= 1'b0;
            ddr2_st_addr_r      <= 0;
            ddr2_burst_r        <= 0;
            ddr2_step_r         <= 0;
            ddr2_burst_num_r    <= 0;
        end
        else if (ins_valid && ins_ready) begin
            if (opcode == RD_OP_G) begin
                ddr2_conf_valid_r   <= 1'b1;
                ddr2_st_addr_r      <= st_addr;
                ddr2_burst_r        <= ((pix_num + 1) * out_ch_seg) << 5;
                ddr2_step_r         <= ((pix_num + 1) * out_img_width) << 5;
                ddr2_burst_num_r    <= row_num;
            end
            else if (opcode[3:2] == 2'b01) begin
                ddr2_conf_valid_r   <= 1'b1;
                ddr2_st_addr_r      <= st_addr;
                ddr2_burst_r        <= opcode[1] ? (p_size * TD_RATE) : p_size;
                ddr2_step_r         <= 0;
                ddr2_burst_num_r    <= 0;
            end
            else begin
                ddr2_conf_valid_r   <= 1'b0;
            end
        end
        else begin
            ddr2_conf_valid_r   <= 1'b0;
        end
    end

//=============================================================================
// Status Logic
//=============================================================================

    // configuration FSM
    localparam STAT_IDLE = 2'b00;
    localparam STAT_CONF = 2'b01;
    localparam STAT_WORK = 2'b10;
    
    reg     [1 : 0] config_stat_r;
    wire    all_done = ddr1_conf_ready && ddr2_conf_ready;
    
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

    // receive instruction
    reg     ins_ready_r;
    assign  ins_ready = ins_ready_r;

    always @ (posedge clk) begin
        if (rst) begin
            ins_ready_r <= 1'b1;
        end
        else if (ins_ready && ins_valid) begin
            ins_ready_r <= 1'b0;
        end
        else if (config_stat_r == STAT_WORK && all_done) begin
            ins_ready_r <= 1'b1;
        end
    end


    // transfer instruction to rx module
    reg                     rx_ins_valid_r;
    reg     [INST_W -1 : 0] rx_ins_r;

    always @ (posedge clk) begin
        if (rst) begin
            rx_ins_valid_r <= 1'b0;
        end
        else if (ins_valid && ins_ready) begin
            rx_ins_valid_r <= 1'b1;
        end
        else if (rx_ins_valid && rx_ins_ready) begin
            rx_ins_valid_r <= 1'b0;
        end
    end

endmodule