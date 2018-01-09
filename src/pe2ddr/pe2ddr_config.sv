import  INS_CONST::*;
import  GLOBAL_PARAM::*;

module pe2ddr_config#(
    parameter   PE_NUM  = 32    
    )(
    input   clk,
    input   rst,
    
    input   [4      -1 : 0] layer_type,
    input   [4      -1 : 0] out_ch_seg,
    input   [8      -1 : 0] img_width,
    
    input   [INST_W -1 : 0] ins,
    output                  ins_ready,
    input                   ins_valid,
    
    output  [bw(PE_NUM / 4) -1 : 0] rd_sel,
    
    output          dg_start,
    input           dg_done,
    output  [3 : 0] dg_conf_pix_num,
    output  [3 : 0] dg_conf_row_num,
    output  [5 : 0] dg_conf_shift,
    output  [1 : 0] dg_conf_pe_sel,
    
    output          ab_start,
    input           ab_done,
    output  [1 : 0] ab_conf_trans_type,
    output  [7 : 0] ab_conf_trans_num,
    output  [1 : 0] ab_conf_grp_sel,
    
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
    
    output      path_sel
    );
    
    reg             dg_start_r;
    reg     [3 : 0] dg_conf_ch_num_r;
    reg     [3 : 0] dg_conf_pix_num_r;
    reg     [3 : 0] dg_conf_row_num_r;
    reg     [5 : 0] dg_conf_shift_r;
    reg     [1 : 0] dg_conf_pe_sel_r;
    
    reg             ab_start_r;
    reg     [1 : 0] ab_conf_trans_type_r;
    reg     [7 : 0] ab_conf_trans_num_r;
    reg     [1 : 0] ab_conf_grp_sel_r;
    
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
    
    wire    [3 : 0] opcode  = ins[61:58];
    wire    [3 : 0] pix_num = ins[43:40];
    wire    [3 : 0] row_num = ins[47:44];
    wire    [5 : 0] buf_id  = ins[57:52];
    wire    [7 : 0] shift   = ins[39:32];
    wire    [31: 0] st_addr = ins[31: 0];
    wire    [7 : 0] size    = ins[47:40];

//=============================================================================
// Configuration Logic
//=============================================================================
    
    always @ (posedge clk) begin
        if (rst) begin
            dg_start_r           <= 1'b0;
            dg_conf_pix_num_r    <= 0;
            dg_conf_row_num_r    <= 0;
            dg_conf_shift_r      <= 0;
            dg_conf_pe_sel_r     <= 2'b00;            
        end
        else if (ins_valid && ins_ready && opcode == 4'b0000) begin
            dg_start_r           <= 1'b1;
            dg_conf_pix_num_r    <= pix_num;
            dg_conf_row_num_r    <= row_num;
            dg_conf_shift_r      <= shift;
            dg_conf_pe_sel_r     <= layer_type[0] ? buf_id[1:0] : 2'b00;
        end
        else begin
            dg_start_r           <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            ab_start_r          <= 1'b0;
            ab_conf_trans_type_r<= 2'b00;
            ab_conf_trans_num_r <= 0;
            ab_conf_grp_sel_r   <= 0; 
        end
        else if (ins_valid && ins_ready && !opcode[3]) begin
            ab_start_r          <= 1'b1;
            ab_conf_trans_type_r<= opcode[1:0];
            ab_conf_trans_num_r <= size;
            ab_conf_grp_sel_r   <= buf_id[1:0]; 
        end
        else begin
            ab_start_r          <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            ddr1_start_r        <= 1'b0;
            ddr1_st_addr_r      <= 0;
            ddr1_burst_r        <= 0;
            ddr1_step_r         <= 0;
            ddr1_burst_num_r    <= 0;
        end
        else if (ins_valid && ins_ready && opcode == 4'b0000) begin
            ddr1_start_r        <= 1'b1;
            ddr1_st_addr_r      <= st_addr;
            ddr1_burst_r        <= ((pix_num + 1) * out_ch_seg) << 5;
            ddr1_step_r         <= ((pix_num + 1) * img_width) << 5; 
            ddr1_burst_num_r    <= row_num + 1;    
        end
        else begin
            ddr1_start_r <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            ddr2_start_r        <= 1'b0;
            ddr2_st_addr_r      <= 0;
            ddr2_burst_r        <= 0;
            ddr2_step_r         <= 0;
            ddr2_burst_num_r    <= 0;
        end
        else if (ins_valid && ins_ready) begin
            if (!opcode[3] && layer_type[2:1] == 2'b00) begin
                ddr2_start_r        <= 1'b1;
                ddr2_st_addr_r      <= st_addr;
                ddr2_burst_r        <= ((pix_num + 1) * out_ch_seg) << 5;
                ddr2_step_r         <= ((pix_num + 1) * img_width) << 5; 
                ddr2_burst_num_r    <= row_num + 1;
            end
            else if (opcode[3]) begin
                ddr2_start_r        <= 1'b1;
                ddr2_st_addr_r      <= st_addr;
                ddr2_burst_r        <= layer_type[1] ? (size + 1) : ((size + 1) << 5);
                ddr2_step_r         <= layer_type[1] ? (size + 1) : ((size + 1) << 5);
                ddr2_burst_num_r    <= layer_type[0] ? 2 : 0;
            end
            else begin
                ddr2_start_r        <= 1'b0;
            end
        end
        else begin
            ddr2_start_r <= 1'b0;
        end
    end
    
    assign  dg_start                = dg_start_r;
    assign  dg_conf_ch_num          = dg_conf_ch_num_r;
    assign  dg_conf_pix_num         = dg_conf_pix_num_r;
    assign  dg_conf_row_num         = dg_conf_row_num_r;
    assign  dg_conf_shift           = dg_conf_shift_r;
    assign  dg_conf_pe_sel          = dg_conf_pe_sel_r;

    assign  ab_start                = ab_start_r;
    assign  ab_conf_trans_type      = ab_conf_trans_type_r;
    assign  ab_conf_trans_num       = ab_conf_trans_num_r;
    assign  ab_conf_grp_sel         = ab_conf_grp_sel_r;

    assign  ddr1_start              = ddr1_start_r;
    assign  ddr1_st_addr            = ddr1_st_addr_r;
    assign  ddr1_burst              = ddr1_burst_r;
    assign  ddr1_step               = ddr1_step_r;
    assign  ddr1_burst_num          = ddr1_burst_num_r;

    assign  ddr2_start              = ddr2_start_r;
    assign  ddr2_st_addr            = ddr2_st_addr_r;
    assign  ddr2_burst              = ddr2_burst_r;
    assign  ddr2_step               = ddr2_step_r;
    assign  ddr2_burst_num          = ddr2_burst_num_r;
    
//=============================================================================
// Status Logic
//=============================================================================

    localparam STAT_IDLE = 2'b00;
    localparam STAT_CONF = 2'b01;
    localparam STAT_WORK = 2'b10;
    
    reg     [1 : 0] config_stat_r;
    wire    all_done = dg_done && ab_done;
    
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
// read address and data selection
//=============================================================================

    reg     path_sel_r;
    reg     [bw(PE_NUM / 4) -1 : 0] rd_sel_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            rd_sel_r <= 0;
        end
        else if (ins_valid && ins_ready) begin
            if (layer_type[0]) begin
                rd_sel_r <= buf_id >> 2;
            end
            else begin
                rd_sel_r <= buf_id;
            end
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            path_sel_r <= 1'b0;
        end
        else if (dg_start_r) begin
            path_sel_r <= 1'b0;
        end
        else if (ab_start_r) begin
            path_sel_r <= 1'b1;
        end
    end
    
    assign  path_sel = path_sel_r;
    assign  rd_sel   = rd_sel_r;
    
endmodule