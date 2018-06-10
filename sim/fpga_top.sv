`ifdef MODEL_TECH
    `define SIMULATION_MODE
`elsif INCA
    `define SIMULATION_MODE
`elsif VCS
    `define SIMULATION_MODE
`elsif XILINX_SIMULATOR
    `define SIMULATION_MODE
`endif

`timescale 1ps/1ps

import GLOBAL_PARAM::*;
import INS_CONST::*;

module fpga_top #(
    parameter nCK_PER_CLK           = 4,    // This parameter is controllerwise
    parameter APP_DATA_WIDTH        = 512,  // This parameter is controllerwise
    parameter APP_MASK_WIDTH        = 64,   // This parameter is controllerwise
    parameter C_AXI_ID_WIDTH        = 1,    // Width of all master and slave ID signals.
                                            // # = >= 1.
    parameter C_AXI_ADDR_WIDTH      = 31,   // Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and
                                            // M_AXI_ARADDR for all SI/MI slots.
                                            // # = 32.
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
// AXI 0 Datamover instantiation
//***************************************************************************

    reg c0_datamover_rstn_r;

    always @ (posedge c1_ddr4_clk) begin
        c0_datamover_rstn_r     <= !c0_ddr4_rst & c0_init_calib_complete;
    end

    wire  [255: 0]  s_axis_s2mm_tdata_c0;
    wire  [31 : 0]  s_axis_s2mm_tkeep_c0 = 0;
    wire            s_axis_s2mm_tlast_c0 = 0;
    wire            s_axis_s2mm_tvalid_c0;
    wire            s_axis_s2mm_tready_c0;

    wire  [255: 0]  m_axis_mm2s_tdata_c0;
    wire  [31 : 0]  m_axis_mm2s_tkeep_c0;
    wire            m_axis_mm2s_tlast_c0;
    wire            m_axis_mm2s_tvalid_c0;
    wire            m_axis_mm2s_tready_c0;


    wire  [71 : 0]  s_axis_mm2s_cmd_tdata_c0;
    wire            s_axis_mm2s_cmd_tvalid_c0;
    wire            s_axis_mm2s_cmd_tready_c0;


    wire  [71 : 0]  s_axis_s2mm_cmd_tdata_c0;
    wire            s_axis_s2mm_cmd_tvalid_c0;
    wire            s_axis_s2mm_cmd_tready_c0;

    wire  [31 : 0]  ddr1_in_addr;
    wire  [22 : 0]  ddr1_in_size;
    assign s_axis_mm2s_cmd_tdata_c0 [22:0] = ddr1_in_size;
    assign s_axis_mm2s_cmd_tdata_c0 [23] = 1;
    assign s_axis_mm2s_cmd_tdata_c0 [31:24] = 0;
    assign s_axis_mm2s_cmd_tdata_c0 [63:32] = ddr1_in_addr;
    assign s_axis_mm2s_cmd_tdata_c0 [71:64] = 0; 


    wire[31 : 0]  ddr1_out_addr;
    wire [22 : 0] ddr1_out_size;
    assign s_axis_s2mm_cmd_tdata_c0 [22:0] = ddr1_out_size;
    assign s_axis_s2mm_cmd_tdata_c0 [23] = 1;
    assign s_axis_s2mm_cmd_tdata_c0 [31:24] = 0;
    assign s_axis_s2mm_cmd_tdata_c0 [63:32] = ddr1_out_addr;
    assign s_axis_s2mm_cmd_tdata_c0 [71:64] = 0;


    axi_datamover_0 datamover_c0 (
        .m_axi_mm2s_aclk            (c0_ddr4_clk                    ),  // input wire m_axi_mm2s_aclk
        .m_axi_mm2s_aresetn         (c0_datamover_rstn_r            ),  // input wire m_axi_mm2s_aresetn
        .mm2s_err                   (mm2s_err                       ),  // output wire mm2s_err
        
        .m_axis_mm2s_cmdsts_aclk    (core_clk                       ),  // input wire m_axis_mm2s_cmdsts_aclk
        .m_axis_mm2s_cmdsts_aresetn (core_rst_r                     ),  // input wire m_axis_mm2s_cmdsts_aresetn
        .s_axis_mm2s_cmd_tvalid     (s_axis_mm2s_cmd_tvalid_c0      ),  // input wire s_axis_mm2s_cmd_tvalid
        .s_axis_mm2s_cmd_tready     (s_axis_mm2s_cmd_tready_c0      ),  // output wire s_axis_mm2s_cmd_tready
        .s_axis_mm2s_cmd_tdata      (s_axis_mm2s_cmd_tdata_c0       ),  // input wire [71 : 0] s_axis_mm2s_cmd_tdata
        .m_axis_mm2s_sts_tvalid     (m_axis_mm2s_sts_tvalid_c0      ),  // output wire m_axis_mm2s_sts_tvalid
        .m_axis_mm2s_sts_tready     (m_axis_mm2s_sts_tready_c0      ),  // input wire m_axis_mm2s_sts_tready
        .m_axis_mm2s_sts_tdata      (/* not used */                 ),  // output wire [7 : 0] m_axis_mm2s_sts_tdata
        .m_axis_mm2s_sts_tkeep      (m_axis_mm2s_sts_tkeep_c0       ),  // output wire [0 : 0] m_axis_mm2s_sts_tkeep
        .m_axis_mm2s_sts_tlast      (m_axis_mm2s_sts_tlast_c0       ),  // output wire m_axis_mm2s_sts_tlast
        .m_axi_mm2s_arid            (c0_ddr4_s_axi_arid             ),  // output wire [3 : 0] m_axi_mm2s_arid
        .m_axi_mm2s_araddr          (c0_ddr4_s_axi_araddr           ),  // output wire [31 : 0] m_axi_mm2s_araddr
        .m_axi_mm2s_arlen           (c0_ddr4_s_axi_arlen            ),  // output wire [7 : 0] m_axi_mm2s_arlen
        .m_axi_mm2s_arsize          (c0_ddr4_s_axi_arsize           ),  // output wire [2 : 0] m_axi_mm2s_arsize
        .m_axi_mm2s_arburst         (c0_ddr4_s_axi_arburst          ),  // output wire [1 : 0] m_axi_mm2s_arburst
        .m_axi_mm2s_arprot          (/* not used */                 ),  // output wire [2 : 0] m_axi_mm2s_arprot
        .m_axi_mm2s_arcache         (c0_ddr4_s_axi_arcache          ),  // output wire [3 : 0] m_axi_mm2s_arcache
        .m_axi_mm2s_aruser          (/* not used */                 ),  // output wire [3 : 0] m_axi_mm2s_aruser
        .m_axi_mm2s_arvalid         (c0_ddr4_s_axi_arvalid          ),  // output wire m_axi_mm2s_arvalid
        .m_axi_mm2s_arready         (c0_ddr4_s_axi_arready          ),  // input wire m_axi_mm2s_arready
        .m_axi_mm2s_rdata           (c0_ddr4_s_axi_rdata            ),  // input wire [255 : 0] m_axi_mm2s_rdata
        .m_axi_mm2s_rresp           (c0_ddr4_s_axi_rresp            ),  // input wire [1 : 0] m_axi_mm2s_rresp
        .m_axi_mm2s_rlast           (c0_ddr4_s_axi_rlast            ),  // input wire m_axi_mm2s_rlast
        .m_axi_mm2s_rvalid          (c0_ddr4_s_axi_rvalid           ),  // input wire m_axi_mm2s_rvalid
        .m_axi_mm2s_rready          (c0_ddr4_s_axi_rready           ),  // output wire m_axi_mm2s_rready
        .m_axis_mm2s_tdata          (m_axis_mm2s_tdata_c0           ),  // output wire [255 : 0] m_axis_mm2s_tdata
        .m_axis_mm2s_tkeep          (m_axis_mm2s_tkeep_c0           ),  // output wire [31 : 0] m_axis_mm2s_tkeep
        .m_axis_mm2s_tlast          (m_axis_mm2s_tlast_c0           ),  // output wire m_axis_mm2s_tlast
        .m_axis_mm2s_tvalid         (m_axis_mm2s_tvalid_c0          ),  // output wire m_axis_mm2s_tvalid
        .m_axis_mm2s_tready         (m_axis_mm2s_tready_c0          ),  // input wire m_axis_mm2s_tready

        .m_axi_s2mm_aclk            (c0_ddr4_clk                    ),  // input wire m_axi_s2mm_aclk
        .m_axi_s2mm_aresetn         (c0_datamover_rstn_r            ),  // input wire m_axi_s2mm_aresetn
        .s2mm_err                   (s2mm_err                       ),  // output wire s2mm_err

        .m_axis_s2mm_cmdsts_awclk   (core_clk                       ),  // input wire m_axis_s2mm_cmdsts_awclk
        .m_axis_s2mm_cmdsts_aresetn (core_rst_r                     ),  // input wire m_axis_s2mm_cmdsts_aresetn
        .s_axis_s2mm_cmd_tvalid     (s_axis_s2mm_cmd_tvalid_c0      ),  // input wire s_axis_s2mm_cmd_tvalid
        .s_axis_s2mm_cmd_tready     (s_axis_s2mm_cmd_tready_c0      ),  // output wire s_axis_s2mm_cmd_tready
        .s_axis_s2mm_cmd_tdata      (s_axis_s2mm_cmd_tdata_c0       ),  // input wire [71 : 0] s_axis_s2mm_cmd_tdata
        .m_axis_s2mm_sts_tvalid     (m_axis_s2mm_sts_tvalid_c0      ),  // output wire m_axis_s2mm_sts_tvalid
        .m_axis_s2mm_sts_tready     (m_axis_s2mm_sts_tready_c0      ),  // input wire m_axis_s2mm_sts_tready
        .m_axis_s2mm_sts_tdata      (/* not used */                 ),  // output wire [7 : 0] m_axis_s2mm_sts_tdata
        .m_axis_s2mm_sts_tkeep      (m_axis_s2mm_sts_tkeep_c0       ),  // output wire [0 : 0] m_axis_s2mm_sts_tkeep
        .m_axis_s2mm_sts_tlast      (m_axis_s2mm_sts_tlast_c0       ),  // output wire m_axis_s2mm_sts_tlast
        .m_axi_s2mm_awid            (c0_ddr4_s_axi_awid             ),  // output wire [7 : 0] m_axi_s2mm_awid
        .m_axi_s2mm_awaddr          (c0_ddr4_s_axi_awaddr           ),  // output wire [31 : 0] m_axi_s2mm_awaddr
        .m_axi_s2mm_awlen           (c0_ddr4_s_axi_awlen            ),  // output wire [7 : 0] m_axi_s2mm_awlen
        .m_axi_s2mm_awsize          (c0_ddr4_s_axi_awsize           ),  // output wire [2 : 0] m_axi_s2mm_awsize
        .m_axi_s2mm_awburst         (c0_ddr4_s_axi_awburst          ),  // output wire [1 : 0] m_axi_s2mm_awburst
        .m_axi_s2mm_awprot          (c0_ddr4_s_axi_awprot           ),  // output wire [2 : 0] m_axi_s2mm_awprot
        .m_axi_s2mm_awcache         (c0_ddr4_s_axi_awcache          ),  // output wire [3 : 0] m_axi_s2mm_awcache
        .m_axi_s2mm_awuser          (/* not used */                 ),  // output wire [3 : 0] m_axi_s2mm_awuser
        .m_axi_s2mm_awvalid         (c0_ddr4_s_axi_awvalid          ),  // output wire m_axi_s2mm_awvalid
        .m_axi_s2mm_awready         (c0_ddr4_s_axi_awready          ),  // input wire m_axi_s2mm_awready
        .m_axi_s2mm_wdata           (c0_ddr4_s_axi_wdata            ),  // output wire [255 : 0] m_axi_s2mm_wdata
        .m_axi_s2mm_wstrb           (c0_ddr4_s_axi_wstrb            ),  // output wire [31 : 0] m_axi_s2mm_wstrb
        .m_axi_s2mm_wlast           (c0_ddr4_s_axi_wlast            ),  // output wire m_axi_s2mm_wlast
        .m_axi_s2mm_wvalid          (c0_ddr4_s_axi_wvalid           ),  // output wire m_axi_s2mm_wvalid
        .m_axi_s2mm_wready          (c0_ddr4_s_axi_wready           ),  // input wire m_axi_s2mm_wready
        .m_axi_s2mm_bresp           (c0_ddr4_s_axi_bresp            ),  // input wire [1 : 0] m_axi_s2mm_bresp
        .m_axi_s2mm_bvalid          (c0_ddr4_s_axi_bvalid           ),  // input wire m_axi_s2mm_bvalid
        .m_axi_s2mm_bready          (c0_ddr4_s_axi_bready           ),  // output wire m_axi_s2mm_bready
        .s_axis_s2mm_tdata          (s_axis_s2mm_tdata_c0           ),  // input wire [255 : 0] s_axis_s2mm_tdata
        .s_axis_s2mm_tkeep          (32'b0                          ),  // input wire [31 : 0] s_axis_s2mm_tkeep
        .s_axis_s2mm_tlast          (1'b0                           ),  // input wire s_axis_s2mm_tlast
        .s_axis_s2mm_tvalid         (s_axis_s2mm_tvalid_c0          ),  // input wire s_axis_s2mm_tvalid
        .s_axis_s2mm_tready         (s_axis_s2mm_tready_c0          )   // output wire s_axis_s2mm_tready
    );
    // 0000000000000000000000000000000000000000000000000000000

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

//***************************************************************************
// AXI 1 Datamover instantiation
//***************************************************************************

    reg c1_datamover_rstn_r;

    always @ (posedge c1_ddr4_clk) begin
        c1_datamover_rstn_r     <= !c1_ddr4_rst & c1_init_calib_complete;
    end

    wire  [255: 0]  s_axis_s2mm_tdata_c1;
    wire  [31 : 0]  s_axis_s2mm_tkeep_c1 = 0;
    wire            s_axis_s2mm_tlast_c1 = 0;
    wire            s_axis_s2mm_tvalid_c1;
    wire            s_axis_s2mm_tready_c1;

    wire  [255: 0]  m_axis_mm2s_tdata_c1;
    wire  [31 : 0]  m_axis_mm2s_tkeep_c1;
    wire            m_axis_mm2s_tlast_c1;
    wire            m_axis_mm2s_tvalid_c1;
    wire            m_axis_mm2s_tready_c1;


    wire  [71 : 0]  s_axis_mm2s_cmd_tdata_c1;
    wire            s_axis_mm2s_cmd_tvalid_c1;
    wire            s_axis_mm2s_cmd_tready_c1;


    wire  [71 : 0]  s_axis_s2mm_cmd_tdata_c1;
    wire            s_axis_s2mm_cmd_tvalid_c1;
    wire            s_axis_s2mm_cmd_tready_c1;

    wire  [31 : 0]  ddr2_in_addr;
    wire  [22 : 0]  ddr2_in_size;
    assign s_axis_mm2s_cmd_tdata_c1 [22:0] = ddr2_in_size;
    assign s_axis_mm2s_cmd_tdata_c1 [23] = 1;
    assign s_axis_mm2s_cmd_tdata_c1 [31:24] = 0;
    assign s_axis_mm2s_cmd_tdata_c1 [63:32] = ddr2_in_addr;
    assign s_axis_mm2s_cmd_tdata_c1 [71:64] = 0; 

    wire[31 : 0]  ddr2_out_addr;
    wire [22 : 0] ddr2_out_size;
    assign s_axis_s2mm_cmd_tdata_c1 [22:0] = ddr2_out_size;
    assign s_axis_s2mm_cmd_tdata_c1 [23] = 1;
    assign s_axis_s2mm_cmd_tdata_c1 [31:24] = 0;
    assign s_axis_s2mm_cmd_tdata_c1 [63:32] = ddr2_out_addr;
    assign s_axis_s2mm_cmd_tdata_c1 [71:64] = 0;


    axi_datamover_0 datamover_c1 (
        .m_axi_mm2s_aclk            (c1_ddr4_clk                    ),
        .m_axi_mm2s_aresetn         (c1_datamover_rstn_r            ),
        .mm2s_err                   (mm2s_err                       ),

        .m_axis_mm2s_cmdsts_aclk    (core_clk                       ),  // input wire m_axis_mm2s_cmdsts_aclk
        .m_axis_mm2s_cmdsts_aresetn (core_rst_r                     ),  // input wire m_axis_mm2s_cmdsts_aresetn
        .s_axis_mm2s_cmd_tvalid     (s_axis_mm2s_cmd_tvalid_c1      ),  // input wire s_axis_mm2s_cmd_tvalid
        .s_axis_mm2s_cmd_tready     (s_axis_mm2s_cmd_tready_c1      ),  // output wire s_axis_mm2s_cmd_tready
        .s_axis_mm2s_cmd_tdata      (s_axis_mm2s_cmd_tdata_c1       ),  // input wire [71 : 0] s_axis_mm2s_cmd_tdata
        .m_axis_mm2s_sts_tvalid     (m_axis_mm2s_sts_tvalid_c1      ),  // output wire m_axis_mm2s_sts_tvalid
        .m_axis_mm2s_sts_tready     (m_axis_mm2s_sts_tready_c1      ),  // input wire m_axis_mm2s_sts_tready
        .m_axis_mm2s_sts_tdata      (/* not used */                 ),  // output wire [7 : 0] m_axis_mm2s_sts_tdata
        .m_axis_mm2s_sts_tkeep      (m_axis_mm2s_sts_tkeep_c1       ),  // output wire [0 : 0] m_axis_mm2s_sts_tkeep
        .m_axis_mm2s_sts_tlast      (m_axis_mm2s_sts_tlast_c1       ),  // output wire m_axis_mm2s_sts_tlast
        .m_axi_mm2s_arid            (c1_ddr4_s_axi_arid             ),  // output wire [3 : 0] m_axi_mm2s_arid
        .m_axi_mm2s_araddr          (c1_ddr4_s_axi_araddr           ),  // output wire [31 : 0] m_axi_mm2s_araddr
        .m_axi_mm2s_arlen           (c1_ddr4_s_axi_arlen            ),  // output wire [7 : 0] m_axi_mm2s_arlen
        .m_axi_mm2s_arsize          (c1_ddr4_s_axi_arsize           ),  // output wire [2 : 0] m_axi_mm2s_arsize
        .m_axi_mm2s_arburst         (c1_ddr4_s_axi_arburst          ),  // output wire [1 : 0] m_axi_mm2s_arburst
        .m_axi_mm2s_arprot          (/* not used */                 ),  // output wire [2 : 0] m_axi_mm2s_arprot
        .m_axi_mm2s_arcache         (c1_ddr4_s_axi_arcache          ),  // output wire [3 : 0] m_axi_mm2s_arcache
        .m_axi_mm2s_aruser          (/* not used */                 ),  // output wire [3 : 0] m_axi_mm2s_aruser
        .m_axi_mm2s_arvalid         (c1_ddr4_s_axi_arvalid          ),  // output wire m_axi_mm2s_arvalid
        .m_axi_mm2s_arready         (c1_ddr4_s_axi_arready          ),  // input wire m_axi_mm2s_arready
        .m_axi_mm2s_rdata           (c1_ddr4_s_axi_rdata            ),  // input wire [255 : 0] m_axi_mm2s_rdata
        .m_axi_mm2s_rresp           (c1_ddr4_s_axi_rresp            ),  // input wire [1 : 0] m_axi_mm2s_rresp
        .m_axi_mm2s_rlast           (c1_ddr4_s_axi_rlast            ),  // input wire m_axi_mm2s_rlast
        .m_axi_mm2s_rvalid          (c1_ddr4_s_axi_rvalid           ),  // input wire m_axi_mm2s_rvalid
        .m_axi_mm2s_rready          (c1_ddr4_s_axi_rready           ),  // output wire m_axi_mm2s_rready
        .m_axis_mm2s_tdata          (m_axis_mm2s_tdata_c1           ),  // output wire [255 : 0] m_axis_mm2s_tdata
        .m_axis_mm2s_tkeep          (m_axis_mm2s_tkeep_c1           ),  // output wire [31 : 0] m_axis_mm2s_tkeep
        .m_axis_mm2s_tlast          (m_axis_mm2s_tlast_c1           ),  // output wire m_axis_mm2s_tlast
        .m_axis_mm2s_tvalid         (m_axis_mm2s_tvalid_c1          ),  // output wire m_axis_mm2s_tvalid
        .m_axis_mm2s_tready         (m_axis_mm2s_tready_c1          ),  // input wire m_axis_mm2s_tready

        .m_axi_s2mm_aclk            (c1_ddr4_clk                    ),  // input wire m_axi_s2mm_aclk
        .m_axi_s2mm_aresetn         (c1_datamover_rstn_r            ),  // input wire m_axi_s2mm_aresetn
        .s2mm_err                   (s2mm_err                       ),  // output wire s2mm_err

        .m_axis_s2mm_cmdsts_awclk   (core_clk                       ),  // input wire m_axis_s2mm_cmdsts_awclk
        .m_axis_s2mm_cmdsts_aresetn (core_rst_r                     ),  // input wire m_axis_s2mm_cmdsts_aresetn
        .s_axis_s2mm_cmd_tvalid     (s_axis_s2mm_cmd_tvalid_c1      ),  // input wire s_axis_s2mm_cmd_tvalid
        .s_axis_s2mm_cmd_tready     (s_axis_s2mm_cmd_tready_c1      ),  // output wire s_axis_s2mm_cmd_tready
        .s_axis_s2mm_cmd_tdata      (s_axis_s2mm_cmd_tdata_c1       ),  // input wire [71 : 0] s_axis_s2mm_cmd_tdata
        .m_axis_s2mm_sts_tvalid     (m_axis_s2mm_sts_tvalid_c1      ),  // output wire m_axis_s2mm_sts_tvalid
        .m_axis_s2mm_sts_tready     (m_axis_s2mm_sts_tready_c1      ),  // input wire m_axis_s2mm_sts_tready
        .m_axis_s2mm_sts_tdata      (/* not used */                 ),  // output wire [7 : 0] m_axis_s2mm_sts_tdata
        .m_axis_s2mm_sts_tkeep      (m_axis_s2mm_sts_tkeep_c1       ),  // output wire [0 : 0] m_axis_s2mm_sts_tkeep
        .m_axis_s2mm_sts_tlast      (m_axis_s2mm_sts_tlast_c1       ),  // output wire m_axis_s2mm_sts_tlast
        .m_axi_s2mm_awid            (c1_ddr4_s_axi_awid             ),  // output wire [7 : 0] m_axi_s2mm_awid
        .m_axi_s2mm_awaddr          (c1_ddr4_s_axi_awaddr           ),  // output wire [31 : 0] m_axi_s2mm_awaddr
        .m_axi_s2mm_awlen           (c1_ddr4_s_axi_awlen            ),  // output wire [7 : 0] m_axi_s2mm_awlen
        .m_axi_s2mm_awsize          (c1_ddr4_s_axi_awsize           ),  // output wire [2 : 0] m_axi_s2mm_awsize
        .m_axi_s2mm_awburst         (c1_ddr4_s_axi_awburst          ),  // output wire [1 : 0] m_axi_s2mm_awburst
        .m_axi_s2mm_awprot          (c1_ddr4_s_axi_awprot           ),  // output wire [2 : 0] m_axi_s2mm_awprot
        .m_axi_s2mm_awcache         (c1_ddr4_s_axi_awcache          ),  // output wire [3 : 0] m_axi_s2mm_awcache
        .m_axi_s2mm_awuser          (/* not used */                 ),  // output wire [3 : 0] m_axi_s2mm_awuser
        .m_axi_s2mm_awvalid         (c1_ddr4_s_axi_awvalid          ),  // output wire m_axi_s2mm_awvalid
        .m_axi_s2mm_awready         (c1_ddr4_s_axi_awready          ),  // input wire m_axi_s2mm_awready
        .m_axi_s2mm_wdata           (c1_ddr4_s_axi_wdata            ),  // output wire [255 : 0] m_axi_s2mm_wdata
        .m_axi_s2mm_wstrb           (c1_ddr4_s_axi_wstrb            ),  // output wire [31 : 0] m_axi_s2mm_wstrb
        .m_axi_s2mm_wlast           (c1_ddr4_s_axi_wlast            ),  // output wire m_axi_s2mm_wlast
        .m_axi_s2mm_wvalid          (c1_ddr4_s_axi_wvalid           ),  // output wire m_axi_s2mm_wvalid
        .m_axi_s2mm_wready          (c1_ddr4_s_axi_wready           ),  // input wire m_axi_s2mm_wready
        .m_axi_s2mm_bresp           (c1_ddr4_s_axi_bresp            ),  // input wire [1 : 0] m_axi_s2mm_bresp
        .m_axi_s2mm_bvalid          (c1_ddr4_s_axi_bvalid           ),  // input wire m_axi_s2mm_bvalid
        .m_axi_s2mm_bready          (c1_ddr4_s_axi_bready           ),  // output wire m_axi_s2mm_bready
        .s_axis_s2mm_tdata          (s_axis_s2mm_tdata_c1           ),  // input wire [255 : 0] s_axis_s2mm_tdata
        .s_axis_s2mm_tkeep          (32'b0                          ),  // input wire [31 : 0] s_axis_s2mm_tkeep
        .s_axis_s2mm_tlast          (1'b0                           ),  // input wire s_axis_s2mm_tlast
        .s_axis_s2mm_tvalid         (s_axis_s2mm_tvalid_c1          ),  // input wire s_axis_s2mm_tvalid
        .s_axis_s2mm_tready         (s_axis_s2mm_tready_c1          )   // output wire s_axis_s2mm_tready
    );

//***************************************************************************
// data FIFO instantiation
//***************************************************************************

    wire    [256        -1 : 0] ddr1_in_data;
    wire                        ddr1_in_valid;
    wire                        ddr1_in_ready;

    wire    [256        -1 : 0] ddr2_in_data;
    wire                        ddr2_in_valid;
    wire                        ddr2_in_ready;

    wire    [DDR_W      -1 : 0] ddr1_out_data;
    wire                        ddr1_out_valid;
    wire                        ddr1_out_ready;

    wire    [DDR_W      -1 : 0] ddr2_out_data;
    wire                        ddr2_out_valid;
    wire                        ddr2_out_ready;

    axis_data_fifo_0 mm2s_fifo_0 (
        .s_axis_aresetn     (c0_datamover_rstn_r    ),
        .s_axis_aclk        (c0_ddr4_clk            ),
        .s_axis_tvalid      (m_axis_mm2s_tvalid_c0  ),
        .s_axis_tready      (m_axis_mm2s_tready_c0  ),
        .s_axis_tdata       (m_axis_mm2s_tdata_c0   ),
        .m_axis_aclk        (core_clk               ),
        .m_axis_aresetn     (core_rst_r             ),
        .m_axis_tvalid      (ddr1_in_valid          ),
        .m_axis_tready      (ddr1_in_ready          ),
        .m_axis_tdata       (ddr1_in_data           ),
        .axis_data_count    (/*not used*/           ),
        .axis_wr_data_count (/*not used*/           ),
        .axis_rd_data_count (/*not used*/           ) 
    );

    axis_data_fifo_0 mm2s_fifo_1 (
        .s_axis_aresetn     (c1_datamover_rstn_r    ),
        .s_axis_aclk        (c1_ddr4_clk            ),
        .s_axis_tvalid      (m_axis_mm2s_tvalid_c1  ),
        .s_axis_tready      (m_axis_mm2s_tready_c1  ),
        .s_axis_tdata       (m_axis_mm2s_tdata_c1   ),
        .m_axis_aclk        (core_clk               ),
        .m_axis_aresetn     (core_rst_r             ),
        .m_axis_tvalid      (ddr2_in_valid          ),
        .m_axis_tready      (ddr2_in_ready          ),
        .m_axis_tdata       (ddr2_in_data           ),
        .axis_data_count    (/*not used*/           ),
        .axis_wr_data_count (/*not used*/           ),
        .axis_rd_data_count (/*not used*/           ) 
    );

    axis_data_fifo_0 s2mm_fifo_0 (
        .s_axis_aresetn     (core_rst_r             ),
        .s_axis_aclk        (core_clk               ),
        .s_axis_tvalid      (ddr1_in_valid          ),
        .s_axis_tready      (ddr1_in_ready          ),
        .s_axis_tdata       (ddr1_in_data           ),
        .m_axis_aresetn     (c0_datamover_rstn_r    ),
        .m_axis_aclk        (c0_ddr4_clk            ),
        .m_axis_tvalid      (m_axis_mm2s_tvalid_c0  ),
        .m_axis_tready      (m_axis_mm2s_tready_c0  ),
        .m_axis_tdata       (m_axis_mm2s_tdata_c0   ),
        .axis_data_count    (/*not used*/           ),
        .axis_wr_data_count (/*not used*/           ),
        .axis_rd_data_count (/*not used*/           ) 
    );

    axis_data_fifo_0 s2mm_fifo_1 (
        .s_axis_aresetn     (core_rst_r             ),
        .s_axis_aclk        (core_clk               ),
        .s_axis_tvalid      (ddr2_in_valid          ),
        .s_axis_tready      (ddr2_in_ready          ),
        .s_axis_tdata       (ddr2_in_data           ),
        .m_axis_aresetn     (c1_datamover_rstn_r    ),
        .m_axis_aclk        (c1_ddr4_clk            ),
        .m_axis_tvalid      (m_axis_mm2s_tvalid_c1  ),
        .m_axis_tready      (m_axis_mm2s_tready_c1  ),
        .m_axis_tdata       (m_axis_mm2s_tdata_c1   ),
        .axis_data_count    (/*not used*/           ),
        .axis_wr_data_count (/*not used*/           ),
        .axis_rd_data_count (/*not used*/           ) 
    );

//***************************************************************************
// Core
//***************************************************************************

    reg                 ins_valid;
    wire                ins_ready;
    reg     [64 -1 : 0] ins;
    wire                working;

    always @ (posedge core_clk) begin
        core_rst_r <= (c0_ddr4_rst | ~c0_init_calib_complete | ~c1_init_calib_complete);
    end
    
    fpga_cnn_train_top top_inst(

        .clk                (core_clk                   ),
        .rst                (core_rst_r                 ),

        .ins_valid          (ins_valid                  ),
        .ins_ready          (ins_ready                  ),
        .ins                (ins                        ),

        .working            (working                    ),

        .ddr1_in_addr       (ddr1_in_addr               ),
        .ddr1_in_size       (ddr1_in_size               ),
        .ddr1_in_addr_valid (s_axis_mm2s_cmd_tvalid_c0  ),
        .ddr1_in_addr_ready (s_axis_mm2s_cmd_tready_c0  ),

        .ddr2_in_addr       (ddr2_in_addr               ),
        .ddr2_in_size       (ddr2_in_size               ),
        .ddr2_in_addr_valid (s_axis_mm2s_cmd_tvalid_c1  ),
        .ddr2_in_addr_ready (s_axis_mm2s_cmd_tready_c1  ),

        .ddr1_in_data       (ddr1_in_data               ),
        .ddr1_in_valid      (ddr1_in_valid              ),
        .ddr1_in_ready      (ddr1_in_ready              ),

        .ddr2_in_data       (ddr2_in_data               ),
        .ddr2_in_valid      (ddr2_in_valid              ),
        .ddr2_in_ready      (ddr2_in_ready              ),

        .ddr1_out_addr      (ddr1_out_addr              ),
        .ddr1_out_size      (ddr1_out_size              ),
        .ddr1_out_addr_valid(s_axis_s2mm_cmd_tvalid_c0  ),
        .ddr1_out_addr_ready(s_axis_s2mm_cmd_tready_c0  ),

        .ddr2_out_addr      (ddr2_out_addr              ),
        .ddr2_out_size      (ddr2_out_size              ),
        .ddr2_out_addr_valid(s_axis_s2mm_cmd_tvalid_c1  ),
        .ddr2_out_addr_ready(s_axis_s2mm_cmd_tready_c1  ),

        .ddr1_out_data      (ddr1_out_data              ),
        .ddr1_out_valid     (ddr1_out_valid             ),
        .ddr1_out_ready     (ddr1_out_ready             ),

        .ddr2_out_data      (ddr2_out_data              ),
        .ddr2_out_valid     (ddr2_out_valid             ),
        .ddr2_out_ready     (ddr2_out_ready             )

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





































