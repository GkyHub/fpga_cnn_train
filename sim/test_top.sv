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
       #200;
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
        .c0_ddr4_ck_t           (c0_ddr4_ck_t           ),
        .c0_ddr4_ck_c           (c0_ddr4_ck_c           ),
        .c0_ddr4_reset_n        (c0_ddr4_reset_n        ),
        .c0_ddr4_dm_dbi_n       (c0_ddr4_dm_dbi_n       ),
        .c0_ddr4_dq             (c0_ddr4_dq             ),
        .c0_ddr4_dqs_c          (c0_ddr4_dqs_c          ),
        .c0_ddr4_dqs_t          (c0_ddr4_dqs_t          ),

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
        .c1_ddr4_ck_t           (c1_ddr4_ck_t           ),
        .c1_ddr4_ck_c           (c1_ddr4_ck_c           ),
        .c1_ddr4_reset_n        (c1_ddr4_reset_n        ),
        .c1_ddr4_dm_dbi_n       (c1_ddr4_dm_dbi_n       ),
        .c1_ddr4_dq             (c1_ddr4_dq             ),
        .c1_ddr4_dqs_c          (c1_ddr4_dqs_c          ),
        .c1_ddr4_dqs_t          (c1_ddr4_dqs_t          )
      );
  
endmodule