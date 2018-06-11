`timescale 1ns/1ps

module test_top;
    parameter real CORE_FREQ_MHZ    = 300.0;
    parameter real PERIOD_NS        = 1000.0/CORE_FREQ_MHZ;
  
//**************************************************************************//
// Reset Generation
//**************************************************************************//
    reg                 sys_rst;
    reg                 core_clk;
    
    initial begin
       sys_rst = 1'b0;
       #200
       sys_rst = 1'b1;
       #400;
       sys_rst = 1'b0;
       #100;
    end

    initial core_clk <= 1'b1;

    always #(PERIOD_NS/2) begin
        core_clk <= ~core_clk;
    end

//**************************************************************************//
// DDR0 instatiation
//**************************************************************************//
    wire            c0_sys_clk_p;
    wire            c0_sys_clk_n;

    wire            c0_ddr4_act_n;
    wire    [16: 0] c0_ddr4_adr;
    wire    [1 : 0] c0_ddr4_ba;
    wire    [0 : 0] c0_ddr4_bg;
    wire    [0 : 0] c0_ddr4_cke;
    wire    [0 : 0] c0_ddr4_odt;
    wire    [0 : 0] c0_ddr4_cs_n;

    wire            c0_ddr4_ck_t;
    wire            c0_ddr4_ck_c;

    wire            c0_ddr4_reset_n;

    wire    [7 : 0] c0_ddr4_dm_dbi_n;
    wire    [63: 0] c0_ddr4_dq;
    wire    [7 : 0] c0_ddr4_dqs_c;
    wire    [7 : 0] c0_ddr4_dqs_t;
    wire            c0_init_calib_complete;
    wire            c0_data_compare_error;
  
    ddr4_wrapper ddr4_0_inst (
        .sys_rst                (sys_rst                ),
        .init_calib_complete    (c0_init_calib_complete ),
        .data_compare_error     (c0_data_compare_error  ),
        .sys_clk_p              (c0_sys_clk_p           ),
        .sys_clk_n              (c0_sys_clk_n           ),
        .ddr4_act_n             (c0_ddr4_act_n          ),
        .ddr4_adr               (c0_ddr4_adr            ),
        .ddr4_ba                (c0_ddr4_ba             ),
        .ddr4_bg                (c0_ddr4_bg             ),
        .ddr4_cke               (c0_ddr4_cke            ),
        .ddr4_odt               (c0_ddr4_odt            ),
        .ddr4_cs_n              (c0_ddr4_cs_n           ),
        .ddr4_ck_t              (c0_ddr4_ck_t           ),
        .ddr4_ck_c              (c0_ddr4_ck_c           ),
        .ddr4_reset_n           (c0_ddr4_reset_n        ),
        .ddr4_dm_dbi_n          (c0_ddr4_dm_dbi_n       ),
        .ddr4_dq                (c0_ddr4_dq             ),
        .ddr4_dqs_t             (c0_ddr4_dqs_t          ),
        .ddr4_dqs_c             (c0_ddr4_dqs_c          )
    );


//**************************************************************************//
// DDR1 instatiation
//**************************************************************************//
    wire            c1_sys_clk_p;
    wire            c1_sys_clk_n;

    wire            c1_ddr4_act_n;
    wire    [16: 0] c1_ddr4_adr;
    wire    [1 : 0] c1_ddr4_ba;
    wire    [0 : 0] c1_ddr4_bg;
    wire    [0 : 0] c1_ddr4_cke;
    wire    [0 : 0] c1_ddr4_odt;
    wire    [0 : 0] c1_ddr4_cs_n;

    wire            c1_ddr4_ck_t;
    wire            c1_ddr4_ck_c;

    wire            c1_ddr4_reset_n;

    wire    [7 : 0] c1_ddr4_dm_dbi_n;
    wire    [63: 0] c1_ddr4_dq;
    wire    [7 : 0] c1_ddr4_dqs_c;
    wire    [7 : 0] c1_ddr4_dqs_t;
    wire            c1_init_calib_complete;
    wire            c1_data_compare_error;
  
    ddr4_wrapper ddr4_1_inst (
        .sys_rst                (sys_rst                ),
        .init_calib_complete    (c1_init_calib_complete ),
        .data_compare_error     (c1_data_compare_error  ),
        .sys_clk_p              (c1_sys_clk_p           ),
        .sys_clk_n              (c1_sys_clk_n           ),
        .ddr4_act_n             (c1_ddr4_act_n          ),
        .ddr4_adr               (c1_ddr4_adr            ),
        .ddr4_ba                (c1_ddr4_ba             ),
        .ddr4_bg                (c1_ddr4_bg             ),
        .ddr4_cke               (c1_ddr4_cke            ),
        .ddr4_odt               (c1_ddr4_odt            ),
        .ddr4_cs_n              (c1_ddr4_cs_n           ),
        .ddr4_ck_t              (c1_ddr4_ck_t           ),
        .ddr4_ck_c              (c1_ddr4_ck_c           ),
        .ddr4_reset_n           (c1_ddr4_reset_n        ),
        .ddr4_dm_dbi_n          (c1_ddr4_dm_dbi_n       ),
        .ddr4_dq                (c1_ddr4_dq             ),
        .ddr4_dqs_t             (c1_ddr4_dqs_t          ),
        .ddr4_dqs_c             (c1_ddr4_dqs_c          )
    );

//**************************************************************************//
// FPGA design instatiation
//**************************************************************************//

    reg                 ins_valid;
    wire                ins_ready;
    reg     [64 -1 : 0] ins;
    wire                working;

    fpga_top fpga_top_inst (
        .sys_rst                (sys_rst                ),
        .core_clk               (core_clk               ),

        .c0_data_compare_error  (c0_data_compare_error  ),
        .c0_init_calib_complete (c0_init_calib_complete ),
        .c0_sys_clk_p           (c0_sys_clk_p           ),
        .c0_sys_clk_n           (c0_sys_clk_n           ),

        .c0_ddr4_act_n          (c0_ddr4_act_n          ),
        .c0_ddr4_adr            (c0_ddr4_adr            ),
        .c0_ddr4_ba             (c0_ddr4_ba             ),
        .c0_ddr4_bg             (c0_ddr4_bg             ),
        .c0_ddr4_cke            (c0_ddr4_cke            ),
        .c0_ddr4_odt            (c0_ddr4_odt            ),
        .c0_ddr4_cs_n           (c0_ddr4_cs_n           ),
        .c0_ddr4_ck_t           (c0_ddr4_ck_t_int       ),
        .c0_ddr4_ck_c           (c0_ddr4_ck_c_int       ),
        .c0_ddr4_reset_n        (c0_ddr4_reset_n        ),
        .c0_ddr4_dm_dbi_n       (c0_ddr4_dm_dbi_n       ),

        .c1_data_compare_error  (c1_data_compare_error  ),
        .c1_init_calib_complete (c1_init_calib_complete ),
        .c1_sys_clk_p           (c1_sys_clk_p           ),
        .c1_sys_clk_n           (c1_sys_clk_n           ),

        .c1_ddr4_act_n          (c1_ddr4_act_n          ),
        .c1_ddr4_adr            (c1_ddr4_adr            ),
        .c1_ddr4_ba             (c1_ddr4_ba             ),
        .c1_ddr4_bg             (c1_ddr4_bg             ),
        .c1_ddr4_cke            (c1_ddr4_cke            ),
        .c1_ddr4_odt            (c1_ddr4_odt            ),
        .c1_ddr4_cs_n           (c1_ddr4_cs_n           ),
        .c1_ddr4_ck_t           (c1_ddr4_ck_t_int       ),
        .c1_ddr4_ck_c           (c1_ddr4_ck_c_int       ),
        .c1_ddr4_reset_n        (c1_ddr4_reset_n        ),
        .c1_ddr4_dm_dbi_n       (c1_ddr4_dm_dbi_n       ),
        .c1_ddr4_dq             (c1_ddr4_dq             ),
        .c1_ddr4_dqs_c          (c1_ddr4_dqs_c          ),
        .c1_ddr4_dqs_t          (c1_ddr4_dqs_t          ),

        .ins_valid              (ins_valid              ),
        .ins_ready              (ins_ready              ),
        .ins                    (ins                    ),
        .working                (working                )
    );

    initial begin
        ins_valid   <= 1'b0;
        ins         <= '0;
        wait(core_rst_r);
        #500
        @(posedge core_clk);
        
        SEND(INS_CONF(LT_F_CONV, 1'b1, 1'b1, 4'd7, 4'd7, 8'd31, 8'd15));
        
        SEND(INS_LOAD(RD_OP_D, 0, 0, {4'd0, 4'd3, 4'd7}, 32'h0000_0000));
        
        SEND(INS_LOAD(RD_OP_DW, 0, 19, 12'd180, 32'h1000_0000));
        
        SEND(INS_CALC(1'b0, 1'b1, 0, 4'b0000, 6, 19));
        
        SEND(INS_LOAD(RD_OP_DW, 1, 21, 12'd198, 32'h1001_0000));
        
        SEND(INS_CALC(1'b0, 1'b1, 1, 4'b0000, 6, 21));
        
        SEND(INS_SAVE(WR_OP_D, 0, {4'd0, 4'd0, 4'd2}, 2, 32'h0002_0000));
        
        SEND(INS_SAVE(WR_OP_D, 1, {4'd0, 4'd0, 4'd2}, 2, 32'h0002_0000));        
    end
    
    task SEND(input [63:0] i);
        ins         <= i;
        ins_valid   <= 1'b1;
        while (~ins_ready) begin
            @(posedge core_clk);
        end
        ins_valid   <= 1'b0;
        @(posedge core_clk);
    endtask
  
endmodule