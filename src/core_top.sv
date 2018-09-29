`timescale 1ps/1ps

import GLOBAL_PARAM::*;
import INS_CONST::*;

module core_wrapper (
    input       rst,        // core reset
    input       clk,        // core clock

    // axi_datamover 0
    input   [255: 0]    s_axis_mm2s_tdata_c0,
    input   [31 : 0]    s_axis_mm2s_tkeep_c0,
    input               s_axis_mm2s_tlast_c0,
    input               s_axis_mm2s_tvalid_c0,
    output              s_axis_mm2s_tready_c0,

    output  [255: 0]    m_axis_s2mm_tdata_c0,
    output  [31 : 0]    m_axis_s2mm_tkeep_c0,
    output              m_axis_s2mm_tlast_c0,
    output              m_axis_s2mm_tvalid_c0,
    input               m_axis_s2mm_tready_c0,

    output  [71 : 0]    m_axis_mm2s_cmd_tdata_c0,
    output              m_axis_mm2s_cmd_tvalid_c0,
    input               m_axis_mm2s_cmd_tready_c0,

    output  [71 : 0]    m_axis_s2mm_cmd_tdata_c0,
    output              m_axis_s2mm_cmd_tvalid_c0,
    input               m_axis_s2mm_cmd_tready_c0,

    // axi_datamover 1
    input   [255: 0]    s_axis_mm2s_tdata_c1,
    input   [31 : 0]    s_axis_mm2s_tkeep_c1,
    input               s_axis_mm2s_tlast_c1,
    input               s_axis_mm2s_tvalid_c1,
    output              s_axis_mm2s_tready_c1,

    output  [255: 0]    m_axis_s2mm_tdata_c1,
    output  [31 : 0]    m_axis_s2mm_tkeep_c1,
    output              m_axis_s2mm_tlast_c1,
    output              m_axis_s2mm_tvalid_c1,
    input               m_axis_s2mm_tready_c1,

    output  [71 : 0]    m_axis_mm2s_cmd_tdata_c1,
    output              m_axis_mm2s_cmd_tvalid_c1,
    input               m_axis_mm2s_cmd_tready_c1,

    output  [71 : 0]    m_axis_s2mm_cmd_tdata_c1,
    output              m_axis_s2mm_cmd_tvalid_c1,
    input               m_axis_s2mm_cmd_tready_c1,

    // control interface
    input                   s_axis_ins_tvalid,
    output                  s_axis_ins_tready,
    input   [64 -1 : 0]     s_axis_ins_tdata,
    output                  working
    );

//***************************************************************************
// AXI Datamover interface connection
//***************************************************************************

    assign  m_axis_s2mm_tkeep_c0 = 0;
    assign  m_axis_s2mm_tlast_c0 = 0;

    wire  [31 : 0]  ddr1_in_addr;
    wire  [22 : 0]  ddr1_in_size;
    assign  m_axis_mm2s_cmd_tdata_c0 [22: 0] = ddr1_in_size;
    assign  m_axis_mm2s_cmd_tdata_c0 [23:23] = 1;
    assign  m_axis_mm2s_cmd_tdata_c0 [31:24] = 0;
    assign  m_axis_mm2s_cmd_tdata_c0 [63:32] = ddr1_in_addr;
    assign  m_axis_mm2s_cmd_tdata_c0 [71:64] = 0; 


    wire [31 : 0] ddr1_out_addr;
    wire [22 : 0] ddr1_out_size;
    assign  m_axis_s2mm_cmd_tdata_c0 [22: 0] = ddr1_out_size;
    assign  m_axis_s2mm_cmd_tdata_c0 [23:23] = 1;
    assign  m_axis_s2mm_cmd_tdata_c0 [31:24] = 0;
    assign  m_axis_s2mm_cmd_tdata_c0 [63:32] = ddr1_out_addr;
    assign  m_axis_s2mm_cmd_tdata_c0 [71:64] = 0;

    assign  m_axis_s2mm_tkeep_c1 = 0;
    assign  m_axis_s2mm_tlast_c1 = 0;

    wire  [31 : 0]  ddr2_in_addr;
    wire  [22 : 0]  ddr2_in_size;
    assign  m_axis_mm2s_cmd_tdata_c1 [22: 0] = ddr1_in_size;
    assign  m_axis_mm2s_cmd_tdata_c1 [23:23] = 1;
    assign  m_axis_mm2s_cmd_tdata_c1 [31:24] = 0;
    assign  m_axis_mm2s_cmd_tdata_c1 [63:32] = ddr1_in_addr;
    assign  m_axis_mm2s_cmd_tdata_c1 [71:64] = 0; 


    wire [31 : 0] ddr2_out_addr;
    wire [22 : 0] ddr2_out_size;
    assign  m_axis_s2mm_cmd_tdata_c1 [22: 0] = ddr2_out_size;
    assign  m_axis_s2mm_cmd_tdata_c1 [23:23] = 1;
    assign  m_axis_s2mm_cmd_tdata_c1 [31:24] = 0;
    assign  m_axis_s2mm_cmd_tdata_c1 [63:32] = ddr2_out_addr;
    assign  m_axis_s2mm_cmd_tdata_c1 [71:64] = 0;

//***************************************************************************
// Core instantiation
//***************************************************************************

    // 1 cycle delay to reduce reset fanout
    reg rst_r;
    always @ (posedge clk) begin
        rst_r <= rst;
    end
    
    fpga_cnn_train_top top_inst(

        .clk                (clk                        ),
        .rst                (rst_r                      ),

        .ins_valid          (s_axis_ins_tvalid          ),
        .ins_ready          (s_axis_ins_tready          ),
        .ins                (s_axis_ins_tdata           ),

        .working            (working                    ),

        .ddr1_in_addr       (ddr1_in_addr               ),
        .ddr1_in_size       (ddr1_in_size               ),
        .ddr1_in_addr_valid (m_axis_mm2s_cmd_tvalid_c0  ),
        .ddr1_in_addr_ready (m_axis_mm2s_cmd_tready_c0  ),

        .ddr2_in_addr       (ddr2_in_addr               ),
        .ddr2_in_size       (ddr2_in_size               ),
        .ddr2_in_addr_valid (m_axis_mm2s_cmd_tvalid_c1  ),
        .ddr2_in_addr_ready (m_axis_mm2s_cmd_tready_c1  ),

        .ddr1_in_data       (s_axis_mm2s_tdata_c0       ),
        .ddr1_in_valid      (s_axis_mm2s_tvalid_c0      ),
        .ddr1_in_ready      (s_axis_mm2s_tready_c0      ),

        .ddr2_in_data       (s_axis_mm2s_tdata_c1       ),
        .ddr2_in_valid      (s_axis_mm2s_tvalid_c1      ),
        .ddr2_in_ready      (s_axis_mm2s_tready_c1      ),

        .ddr1_out_addr      (ddr1_out_addr              ),
        .ddr1_out_size      (ddr1_out_size              ),
        .ddr1_out_addr_valid(m_axis_s2mm_cmd_tvalid_c0  ),
        .ddr1_out_addr_ready(m_axis_s2mm_cmd_tready_c0  ),

        .ddr2_out_addr      (ddr2_out_addr              ),
        .ddr2_out_size      (ddr2_out_size              ),
        .ddr2_out_addr_valid(m_axis_s2mm_cmd_tvalid_c1  ),
        .ddr2_out_addr_ready(m_axis_s2mm_cmd_tready_c1  ),

        .ddr1_out_data      (m_axis_s2mm_tdata_c0       ),
        .ddr1_out_valid     (m_axis_s2mm_tvalid_c0      ),
        .ddr1_out_ready     (m_axis_s2mm_tready_c0      ),

        .ddr2_out_data      (m_axis_s2mm_tdata_c1       ),
        .ddr2_out_valid     (m_axis_s2mm_tvalid_c1      ),
        .ddr2_out_ready     (m_axis_s2mm_tready_c1      )

    );

endmodule