`ifdef MODEL_TECH
    `define SIMULATION_MODE
`elsif INCA
    `define SIMULATION_MODE
`elsif VCS
    `define SIMULATION_MODE
`elsif XILINX_SIMULATOR
    `define SIMULATION_MODE
`endif

`timescale 1ns/1ps

import GLOBAL_PARAM::*;
import INS_CONST::*;

module fpga_top #(
    parameter nCK_PER_CLK           = 4,    // This parameter is controllerwise
    parameter APP_DATA_WIDTH        = 512,  // This parameter is controllerwise
    parameter APP_MASK_WIDTH        = 64,   // This parameter is controllerwise
    parameter C_AXI_ID_WIDTH        = 1,    // Width of all master and slave ID signals.
                                            // # = >= 1.
    parameter C_AXI_ADDR_WIDTH      = 31,   // Width of S_AXI_AWADDR, S_AXI_ARADDR,
                                            // M_AXI_AWADDR and M_AXI_ARADDR for all SI/MI slots.
                                            // # = 32.
											// 
    parameter C_AXI_DATA_WIDTH      = 256,  // Width of WDATA and RDATA on SI slot.
                                            // Must be <= APP_DATA_WIDTH.
                                            // # = 32, 64, 128, 256.
    parameter C_AXI_NBURST_SUPPORT  = 1,

`ifdef SIMULATION_MODE
    parameter SIMULATION            = "TRUE" 
`else
    parameter SIMULATION            = "FALSE"
`endif
    )(
    input       sys_rst,    // Common port for all controllers
    input       core_clk,   // design logic clock

    output                  c0_init_calib_complete,
    output                  c0_data_compare_error,
    input                   c0_sys_clk_p,
    input                   c0_sys_clk_n,
    output                  c0_ddr4_act_n,
    output [16:0]           c0_ddr4_adr,
    output [1:0]            c0_ddr4_ba,
    output [0:0]            c0_ddr4_bg,
    output [0:0]            c0_ddr4_cke,
    output [0:0]            c0_ddr4_odt,
    output [0:0]            c0_ddr4_cs_n,
    output [0:0]            c0_ddr4_ck_t,
    output [0:0]            c0_ddr4_ck_c,
    output                  c0_ddr4_reset_n,
    inout  [7:0]            c0_ddr4_dm_dbi_n,
    inout  [63:0]           c0_ddr4_dq,
    inout  [7:0]            c0_ddr4_dqs_t,
    inout  [7:0]            c0_ddr4_dqs_c,

    output                  c1_init_calib_complete,
    output                  c1_data_compare_error,
    input                   c1_sys_clk_p,
    input                   c1_sys_clk_n,
    output                  c1_ddr4_act_n,
    output [16:0]           c1_ddr4_adr,
    output [1:0]            c1_ddr4_ba,
    output [0:0]            c1_ddr4_bg,
    output [0:0]            c1_ddr4_cke,
    output [0:0]            c1_ddr4_odt,
    output [0:0]            c1_ddr4_cs_n,
    output [0:0]            c1_ddr4_ck_t,
    output [0:0]            c1_ddr4_ck_c,
    output                  c1_ddr4_reset_n,
    inout  [7:0]            c1_ddr4_dm_dbi_n,
    inout  [63:0]           c1_ddr4_dq,
    inout  [7:0]            c1_ddr4_dqs_t,
    inout  [7:0]            c1_ddr4_dqs_c
    );


    localparam APP_ADDR_WIDTH   = 28;
    localparam MEM_ADDR_ORDER   = "ROW_COLUMN_BANK";
    localparam DBG_WR_STS_WIDTH = 32; 
    localparam DBG_RD_STS_WIDTH = 32;
    localparam ECC              = "OFF"; 

    reg                 core_rst_r;   

//***************************************************************************
// DDR4 0 MIG instantiation
//***************************************************************************

    wire  [APP_ADDR_WIDTH -1:0] c0_ddr4_app_addr;
    wire  [2:0]                 c0_ddr4_app_cmd;
    wire                        c0_ddr4_app_en;
    wire  [APP_DATA_WIDTH -1:0] c0_ddr4_app_wdf_data;
    wire                        c0_ddr4_app_wdf_end;
    wire  [APP_MASK_WIDTH -1:0] c0_ddr4_app_wdf_mask;
    wire                        c0_ddr4_app_wdf_wren;
    wire  [APP_DATA_WIDTH -1:0] c0_ddr4_app_rd_data;
    wire                        c0_ddr4_app_rd_data_end;
    wire                        c0_ddr4_app_rd_data_valid;
    wire                        c0_ddr4_app_rdy;
    wire                        c0_ddr4_app_wdf_rdy;
    wire                        c0_ddr4_clk;
    wire                        c0_ddr4_rst;
    wire                        c0_wr_rd_complete;


    reg                         c0_ddr4_aresetn;
    wire                        c0_ddr4_data_msmatch_err;
    wire                        c0_ddr4_write_err;
    wire                        c0_ddr4_read_err;
    wire                        c0_ddr4_test_cmptd;
    wire                        c0_ddr4_write_cmptd;
    wire                        c0_ddr4_read_cmptd;
    wire                        c0_ddr4_cmptd_one_wr_rd;

    // Slave Interface Write Address Ports
    wire [7:0]                  c0_ddr4_s_axi_awid;
    wire [31:0]                 c0_ddr4_s_axi_awaddr;
    wire [7:0]                  c0_ddr4_s_axi_awlen;
    wire [2:0]                  c0_ddr4_s_axi_awsize;
    wire [1:0]                  c0_ddr4_s_axi_awburst;
    wire [3:0]                  c0_ddr4_s_axi_awcache;
    wire [2:0]                  c0_ddr4_s_axi_awprot;
    wire                        c0_ddr4_s_axi_awvalid;
    wire                        c0_ddr4_s_axi_awready;
     // Slave Interface Write Data Ports
    wire [255:0]                c0_ddr4_s_axi_wdata;
    wire [31:0]                 c0_ddr4_s_axi_wstrb;
    wire                        c0_ddr4_s_axi_wlast;
    wire                        c0_ddr4_s_axi_wvalid;
    wire                        c0_ddr4_s_axi_wready;
     // Slave Interface Write Response Ports
    wire                        c0_ddr4_s_axi_bready;
    wire [0:0]                  c0_ddr4_s_axi_bid;
    wire [1:0]                  c0_ddr4_s_axi_bresp;
    wire                        c0_ddr4_s_axi_bvalid;
     // Slave Interface Read Address Ports
    wire [3:0]                  c0_ddr4_s_axi_arid;
    wire [31:0]                 c0_ddr4_s_axi_araddr;
    wire [7:0]                  c0_ddr4_s_axi_arlen;
    wire [2:0]                  c0_ddr4_s_axi_arsize;
    wire [1:0]                  c0_ddr4_s_axi_arburst;
    wire [3:0]                  c0_ddr4_s_axi_arcache;
    wire                        c0_ddr4_s_axi_arvalid;
    wire                        c0_ddr4_s_axi_arready;
     // Slave Interface Read Data Ports
    wire                        c0_ddr4_s_axi_rready;
    wire [0:0]                  c0_ddr4_s_axi_rid;
    wire [255:0]                c0_ddr4_s_axi_rdata;
    wire [1:0]                  c0_ddr4_s_axi_rresp;
    wire                        c0_ddr4_s_axi_rlast;
    wire                        c0_ddr4_s_axi_rvalid;

    wire                        c0_ddr4_cmp_data_valid;
    wire [255:0]                c0_ddr4_cmp_data;     // Compare data
    wire [255:0]                c0_ddr4_rdata_cmp;      // Read data

    wire                        c0_ddr4_dbg_wr_sts_vld;
    wire [DBG_WR_STS_WIDTH-1:0] c0_ddr4_dbg_wr_sts;
    wire                        c0_ddr4_dbg_rd_sts_vld;
    wire [DBG_RD_STS_WIDTH-1:0] c0_ddr4_dbg_rd_sts;
    assign c0_data_compare_error = c0_ddr4_data_msmatch_err | c0_ddr4_write_err | c0_ddr4_read_err;

  
    wire c0_ddr4_reset_n_int;
    assign c0_ddr4_reset_n = c0_ddr4_reset_n_int;

    ddr4_0 u_ddr4_c0(
        .sys_rst                  (sys_rst                ),
        .c0_sys_clk_p             (c0_sys_clk_p           ),
        .c0_sys_clk_n             (c0_sys_clk_n           ),
        .c0_init_calib_complete   (c0_init_calib_complete ),
        .c0_ddr4_act_n            (c0_ddr4_act_n          ),
        .c0_ddr4_adr              (c0_ddr4_adr            ),
        .c0_ddr4_ba               (c0_ddr4_ba             ),
        .c0_ddr4_bg               (c0_ddr4_bg             ),
        .c0_ddr4_cke              (c0_ddr4_cke            ),
        .c0_ddr4_odt              (c0_ddr4_odt            ),
        .c0_ddr4_cs_n             (c0_ddr4_cs_n           ),
        .c0_ddr4_ck_t             (c0_ddr4_ck_t           ),
        .c0_ddr4_ck_c             (c0_ddr4_ck_c           ),
        .c0_ddr4_reset_n          (c0_ddr4_reset_n_int    ),
        .c0_ddr4_dm_dbi_n         (c0_ddr4_dm_dbi_n       ),
        .c0_ddr4_dq               (c0_ddr4_dq             ),
        .c0_ddr4_dqs_c            (c0_ddr4_dqs_c          ),
        .c0_ddr4_dqs_t            (c0_ddr4_dqs_t          ),
        .c0_ddr4_ui_clk           (c0_ddr4_clk            ),
        .c0_ddr4_ui_clk_sync_rst  (c0_ddr4_rst            ),
        // Slave Interface Write Address Ports
        .c0_ddr4_aresetn          (c0_ddr4_aresetn        ),
        .c0_ddr4_s_axi_awid       (c0_ddr4_s_axi_awid     ),
        .c0_ddr4_s_axi_awaddr     (c0_ddr4_s_axi_awaddr   ),
        .c0_ddr4_s_axi_awlen      (c0_ddr4_s_axi_awlen    ),
        .c0_ddr4_s_axi_awsize     (c0_ddr4_s_axi_awsize   ),
        .c0_ddr4_s_axi_awburst    (c0_ddr4_s_axi_awburst  ),
        .c0_ddr4_s_axi_awlock     (1'b0                   ),
        .c0_ddr4_s_axi_awcache    (c0_ddr4_s_axi_awcache  ),
        .c0_ddr4_s_axi_awprot     (c0_ddr4_s_axi_awprot   ),
        .c0_ddr4_s_axi_awqos      (4'b0                   ),
        .c0_ddr4_s_axi_awvalid    (c0_ddr4_s_axi_awvalid  ),
        .c0_ddr4_s_axi_awready    (c0_ddr4_s_axi_awready  ),
        // Slave Interface Write Data Ports
        .c0_ddr4_s_axi_wdata      (c0_ddr4_s_axi_wdata    ),
        .c0_ddr4_s_axi_wstrb      (c0_ddr4_s_axi_wstrb    ),
        .c0_ddr4_s_axi_wlast      (c0_ddr4_s_axi_wlast    ),
        .c0_ddr4_s_axi_wvalid     (c0_ddr4_s_axi_wvalid   ),
        .c0_ddr4_s_axi_wready     (c0_ddr4_s_axi_wready   ),
        // Slave Interface Write Response Ports
        .c0_ddr4_s_axi_bid        (c0_ddr4_s_axi_bid      ),
        .c0_ddr4_s_axi_bresp      (c0_ddr4_s_axi_bresp    ),
        .c0_ddr4_s_axi_bvalid     (c0_ddr4_s_axi_bvalid   ),
        .c0_ddr4_s_axi_bready     (c0_ddr4_s_axi_bready   ),
        // Slave Interface Read Address Ports
        .c0_ddr4_s_axi_arid       (c0_ddr4_s_axi_arid     ),
        .c0_ddr4_s_axi_araddr     (c0_ddr4_s_axi_araddr   ),
        .c0_ddr4_s_axi_arlen      (c0_ddr4_s_axi_arlen    ),
        .c0_ddr4_s_axi_arsize     (c0_ddr4_s_axi_arsize   ),
        .c0_ddr4_s_axi_arburst    (c0_ddr4_s_axi_arburst  ),
        .c0_ddr4_s_axi_arlock     (1'b0                   ),
        .c0_ddr4_s_axi_arcache    (c0_ddr4_s_axi_arcache  ),
        .c0_ddr4_s_axi_arprot     (3'b0                   ),
        .c0_ddr4_s_axi_arqos      (4'b0                   ),
        .c0_ddr4_s_axi_arvalid    (c0_ddr4_s_axi_arvalid  ),
        .c0_ddr4_s_axi_arready    (c0_ddr4_s_axi_arready  ),
        // Slave Interface Read Data Ports
        .c0_ddr4_s_axi_rid        (c0_ddr4_s_axi_rid      ),
        .c0_ddr4_s_axi_rdata      (c0_ddr4_s_axi_rdata    ),
        .c0_ddr4_s_axi_rresp      (c0_ddr4_s_axi_rresp    ),
        .c0_ddr4_s_axi_rlast      (c0_ddr4_s_axi_rlast    ),
        .c0_ddr4_s_axi_rvalid     (c0_ddr4_s_axi_rvalid   ),
        .c0_ddr4_s_axi_rready     (c0_ddr4_s_axi_rready   )
    );

    always @(posedge c0_ddr4_clk) begin
        c0_ddr4_aresetn <= ~c0_ddr4_rst;
    end

//***************************************************************************
// DDR4 1 MIG instantiation
//***************************************************************************

    wire  [APP_ADDR_WIDTH -1:0] c1_ddr4_app_addr;
    wire  [2:0]                 c1_ddr4_app_cmd;
    wire                        c1_ddr4_app_en;
    wire  [APP_DATA_WIDTH -1:0] c1_ddr4_app_wdf_data;
    wire                        c1_ddr4_app_wdf_end;
    wire  [APP_MASK_WIDTH -1:0] c1_ddr4_app_wdf_mask;
    wire                        c1_ddr4_app_wdf_wren;
    wire  [APP_DATA_WIDTH -1:0] c1_ddr4_app_rd_data;
    wire                        c1_ddr4_app_rd_data_end;
    wire                        c1_ddr4_app_rd_data_valid;
    wire                        c1_ddr4_app_rdy;
    wire                        c1_ddr4_app_wdf_rdy;
    wire                        c1_ddr4_clk;
    wire                        c1_ddr4_rst;
    wire                        c1_wr_rd_complete;


    reg                         c1_ddr4_aresetn;
    wire                        c1_ddr4_data_msmatch_err;
    wire                        c1_ddr4_write_err;
    wire                        c1_ddr4_read_err;
    wire                        c1_ddr4_test_cmptd;
    wire                        c1_ddr4_write_cmptd;
    wire                        c1_ddr4_read_cmptd;
    wire                        c1_ddr4_cmptd_one_wr_rd;

    // Slave Interface Write Address Ports
    wire [7:0]                  c1_ddr4_s_axi_awid;
    wire [31:0]                 c1_ddr4_s_axi_awaddr;
    wire [7:0]                  c1_ddr4_s_axi_awlen;
    wire [2:0]                  c1_ddr4_s_axi_awsize;
    wire [1:0]                  c1_ddr4_s_axi_awburst;
    wire [3:0]                  c1_ddr4_s_axi_awcache;
    wire [2:0]                  c1_ddr4_s_axi_awprot;
    wire                        c1_ddr4_s_axi_awvalid;
    wire                        c1_ddr4_s_axi_awready;
     // Slave Interface Write Data Ports
    wire [255:0]                c1_ddr4_s_axi_wdata;
    wire [31:0]                 c1_ddr4_s_axi_wstrb;
    wire                        c1_ddr4_s_axi_wlast;
    wire                        c1_ddr4_s_axi_wvalid;
    wire                        c1_ddr4_s_axi_wready;
     // Slave Interface Write Response Ports
    wire                        c1_ddr4_s_axi_bready;
    wire [0:0]                  c1_ddr4_s_axi_bid;
    wire [1:0]                  c1_ddr4_s_axi_bresp;
    wire                        c1_ddr4_s_axi_bvalid;
     // Slave Interface Read Address Ports
    wire [3:0]                  c1_ddr4_s_axi_arid;
    wire [31:0]                 c1_ddr4_s_axi_araddr;
    wire [7:0]                  c1_ddr4_s_axi_arlen;
    wire [2:0]                  c1_ddr4_s_axi_arsize;
    wire [1:0]                  c1_ddr4_s_axi_arburst;
    wire [3:0]                  c1_ddr4_s_axi_arcache;
    wire                        c1_ddr4_s_axi_arvalid;
    wire                        c1_ddr4_s_axi_arready;
     // Slave Interface Read Data Ports
    wire                        c1_ddr4_s_axi_rready;
    wire [0:0]                  c1_ddr4_s_axi_rid;
    wire [255:0]                c1_ddr4_s_axi_rdata;
    wire [1:0]                  c1_ddr4_s_axi_rresp;
    wire                        c1_ddr4_s_axi_rlast;
    wire                        c1_ddr4_s_axi_rvalid;

    wire                        c1_ddr4_cmp_data_valid;
    wire [255:0]                c1_ddr4_cmp_data;     // Compare data
    wire [255:0]                c1_ddr4_rdata_cmp;      // Read data

    wire                        c1_ddr4_dbg_wr_sts_vld;
    wire [DBG_WR_STS_WIDTH-1:0] c1_ddr4_dbg_wr_sts;
    wire                        c1_ddr4_dbg_rd_sts_vld;
    wire [DBG_RD_STS_WIDTH-1:0] c1_ddr4_dbg_rd_sts;
    assign c1_data_compare_error = c1_ddr4_data_msmatch_err | c1_ddr4_write_err | c1_ddr4_read_err;

  
    wire c1_ddr4_reset_n_int;
    assign c1_ddr4_reset_n = c1_ddr4_reset_n_int;

    ddr4_0 u_ddr4_c1(
        .sys_rst                  (sys_rst                ),
        .c0_sys_clk_p             (c1_sys_clk_p           ),
        .c0_sys_clk_n             (c1_sys_clk_n           ),
        .c0_init_calib_complete   (c1_init_calib_complete ),
        .c0_ddr4_act_n            (c1_ddr4_act_n          ),
        .c0_ddr4_adr              (c1_ddr4_adr            ),
        .c0_ddr4_ba               (c1_ddr4_ba             ),
        .c0_ddr4_bg               (c1_ddr4_bg             ),
        .c0_ddr4_cke              (c1_ddr4_cke            ),
        .c0_ddr4_odt              (c1_ddr4_odt            ),
        .c0_ddr4_cs_n             (c1_ddr4_cs_n           ),
        .c0_ddr4_ck_t             (c1_ddr4_ck_t           ),
        .c0_ddr4_ck_c             (c1_ddr4_ck_c           ),
        .c0_ddr4_reset_n          (c1_ddr4_reset_n_int    ),
        .c0_ddr4_dm_dbi_n         (c1_ddr4_dm_dbi_n       ),
        .c0_ddr4_dq               (c1_ddr4_dq             ),
        .c0_ddr4_dqs_c            (c1_ddr4_dqs_c          ),
        .c0_ddr4_dqs_t            (c1_ddr4_dqs_t          ),
        .c0_ddr4_ui_clk           (c1_ddr4_clk            ),
        .c0_ddr4_ui_clk_sync_rst  (c1_ddr4_rst            ),
        // Slave Interface Write Address Ports
        .c0_ddr4_aresetn          (c1_ddr4_aresetn        ),
        .c0_ddr4_s_axi_awid       (c1_ddr4_s_axi_awid     ),
        .c0_ddr4_s_axi_awaddr     (c1_ddr4_s_axi_awaddr   ),
        .c0_ddr4_s_axi_awlen      (c1_ddr4_s_axi_awlen    ),
        .c0_ddr4_s_axi_awsize     (c1_ddr4_s_axi_awsize   ),
        .c0_ddr4_s_axi_awburst    (c1_ddr4_s_axi_awburst  ),
        .c0_ddr4_s_axi_awlock     (1'b0                   ),
        .c0_ddr4_s_axi_awcache    (c1_ddr4_s_axi_awcache  ),
        .c0_ddr4_s_axi_awprot     (c1_ddr4_s_axi_awprot   ),
        .c0_ddr4_s_axi_awqos      (4'b0                   ),
        .c0_ddr4_s_axi_awvalid    (c1_ddr4_s_axi_awvalid  ),
        .c0_ddr4_s_axi_awready    (c1_ddr4_s_axi_awready  ),
        // Slave Interface Write Data Ports
        .c0_ddr4_s_axi_wdata      (c1_ddr4_s_axi_wdata    ),
        .c0_ddr4_s_axi_wstrb      (c1_ddr4_s_axi_wstrb    ),
        .c0_ddr4_s_axi_wlast      (c1_ddr4_s_axi_wlast    ),
        .c0_ddr4_s_axi_wvalid     (c1_ddr4_s_axi_wvalid   ),
        .c0_ddr4_s_axi_wready     (c1_ddr4_s_axi_wready   ),
        // Slave Interface Write Response Ports
        .c0_ddr4_s_axi_bid        (c1_ddr4_s_axi_bid      ),
        .c0_ddr4_s_axi_bresp      (c1_ddr4_s_axi_bresp    ),
        .c0_ddr4_s_axi_bvalid     (c1_ddr4_s_axi_bvalid   ),
        .c0_ddr4_s_axi_bready     (c1_ddr4_s_axi_bready   ),
        // Slave Interface Read Address Ports
        .c0_ddr4_s_axi_arid       (c1_ddr4_s_axi_arid     ),
        .c0_ddr4_s_axi_araddr     (c1_ddr4_s_axi_araddr   ),
        .c0_ddr4_s_axi_arlen      (c1_ddr4_s_axi_arlen    ),
        .c0_ddr4_s_axi_arsize     (c1_ddr4_s_axi_arsize   ),
        .c0_ddr4_s_axi_arburst    (c1_ddr4_s_axi_arburst  ),
        .c0_ddr4_s_axi_arlock     (1'b0                   ),
        .c0_ddr4_s_axi_arcache    (c1_ddr4_s_axi_arcache  ),
        .c0_ddr4_s_axi_arprot     (3'b0                   ),
        .c0_ddr4_s_axi_arqos      (4'b0                   ),
        .c0_ddr4_s_axi_arvalid    (c1_ddr4_s_axi_arvalid  ),
        .c0_ddr4_s_axi_arready    (c1_ddr4_s_axi_arready  ),
        // Slave Interface Read Data Ports
        .c0_ddr4_s_axi_rid        (c1_ddr4_s_axi_rid      ),
        .c0_ddr4_s_axi_rdata      (c1_ddr4_s_axi_rdata    ),
        .c0_ddr4_s_axi_rresp      (c1_ddr4_s_axi_rresp    ),
        .c0_ddr4_s_axi_rlast      (c1_ddr4_s_axi_rlast    ),
        .c0_ddr4_s_axi_rvalid     (c1_ddr4_s_axi_rvalid   ),
        .c0_ddr4_s_axi_rready     (c1_ddr4_s_axi_rready   )
    );

    always @(posedge c1_ddr4_clk) begin
        c1_ddr4_aresetn <= ~c1_ddr4_rst;
    end

// simulation core

    always @ (posedge core_clk) begin
        core_rst_r <= (c0_ddr4_rst | c1_ddr4_rst | ~c0_init_calib_complete | ~c1_init_calib_complete);
    end

    localparam DATA_FILE_NAME   = "test_data.txt";
    localparam STORE_ADDR       = 32'h0000_0000;
    localparam STORE_BURST      = 8;
    localparam LOG_FILE_NAME    = "test_log.txt";
    localparam LOAD_ADDR        = 32'h0000_0001;
    localparam LOAD_BURST       = 4;

    integer fp_r,fp_w;
    integer count;

    initial begin 
       
		// ------------- logic of read file and write ddr1 -------------- //
        c0_ddr4_s_axi_awid    = 0;
        c0_ddr4_s_axi_awcache = 3;
		c0_ddr4_s_axi_awprot  = 0;    
        c0_ddr4_s_axi_awqos   = 0;
        c0_ddr4_s_axi_bready  = 1;

        fp_r=$fopen(DATA_FILE_NAME, "r");                              //open file with read mode
        for (integer burst = 0; burst < STORE_BURST; burst+=1) begin   // write data from file to ddr

			#500; 						// write data into ddr1   address
			@(posedge clk);
			c0_ddr4_s_axi_awaddr  <= STORE_ADDR + 32*burst;
            c0_ddr4_s_axi_awlen   <= 8'b0000_0000;
            c0_ddr4_s_axi_awsize  <= 3'b101;
            c0_ddr4_s_axi_awburst <= 2'b01;
			c0_ddr4_s_axi_awvalid <= 1'b1;
           	@(posedge clk);
			while (~c0_ddr4_s_axi_awready) begin
				@(posedge clk);
			end 
            c0_ddr4_s_axi_awlen   <= 8'b0000_0000;
            c0_ddr4_s_axi_awsize  <= 3'b000;
            c0_ddr4_s_axi_awburst <= 2'b00;
			c0_ddr4_s_axi_awvalid <= 1'b0;

                                        // write data into ddr1   data
            count = $fscanf (fp_r, "%b", c0_ddr4_s_axi_wdata);        //read one line from file to reg
            $display("%d::::%b", count,  c0_ddr4_s_axi_wdata);        //print
            c0_ddr4_s_axi_wstrb   <= 32'hffff_ffff;
            c0_ddr4_s_axi_wlast   <= 1'b1;
			#50;
			@(posedge clk);
            c0_ddr4_s_axi_wvalid  <= 1'b1;
			@(posedge clk);
			while (~ddr1_out_ready) begin
				@(posedge clk);
			end 
			c0_ddr4_s_axi_wvalid  <= 1'b0;
			c0_ddr4_s_axi_wlast   <= 1'b0;
			c0_ddr4_s_axi_wstrb   <= 32'h0000_0000;

		end
        $fclose(fp_r);                                               //close file when over
		
        // ------------- logic of read ddr1 and write file -------------- //
        c0_ddr4_s_axi_awid    = 0;
        c0_ddr4_s_axi_awcache = 3;
		c0_ddr4_s_axi_awprot  = 0;    
        c0_ddr4_s_axi_awqos   = 0;
        c0_ddr4_s_axi_bready  = 1;

        for (integer burst = 0; burst < LOAD_BURST; burst+=1) begin  // write data from ddr to file 

            #1000; 						// read data from ddr1    address
            @(posedge clk);
			c0_ddr4_s_axi_araddr  <= LOAD_ADDR + 32*burst;
            c0_ddr4_s_axi_arlen   <= 8'b0000_0000;
            c0_ddr4_s_axi_arsize  <= 3'b101;
            c0_ddr4_s_axi_arburst <= 2'b01;
			c0_ddr4_s_axi_arvalid <= 1'b1;
           	@(posedge clk);
			while (~c0_ddr4_s_axi_arready) begin
				@(posedge clk);
			end 
            c0_ddr4_s_axi_arlen   <= 8'b0000_0000;
            c0_ddr4_s_axi_arsize  <= 3'b000;
            c0_ddr4_s_axi_arburst <= 2'b00;
			c0_ddr4_s_axi_arvalid <= 1'b0;

		end

	end

    initial begin

        fp_w=$fopen(LOG_FILE_NAME , "w");                             //open file with write mode
        while(1) begin
            @(posedge clk)
            if (ddr1_in_valid) begin
                if (ddr1_in_ready) begin
                    receive_1       <= ddr1_in_data;
                    $fwrite(fp_w, "%b\n", receive_1);                 //write from reg to file
                    ddr1_in_ready_r <= 1'b0;
                end
                else begin
                    ddr1_in_ready_r <= 1'b1;
                end
            end
            else ddr1_in_ready_r <= 1'b1;
        end
        $fclose(fp_w);

    end    

   
endmodule
