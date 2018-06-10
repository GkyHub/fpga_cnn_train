`timescale 1ps/1ps

`ifdef XILINX_SIMULATOR
module short(in1, in1);
    inout in1;
endmodule
`endif

module ddr4_wrapper#(
    parameter ADDR_WIDTH            = 17,
    parameter DQ_WIDTH              = 64,
    parameter DQS_WIDTH             = 8,
    parameter DM_WIDTH              = 8,
    parameter DRAM_WIDTH            = 16,
    parameter tCK                   = 833, //DDR4 interface clock period in ps
    parameter RANK_WIDTH            = 1,
    parameter CS_WIDTH              = 1,
    parameter ODT_WIDTH             = 1,
    parameter CA_MIRROR             = "OFF"
    )(
    input                       sys_rst,

    input                       init_calib_complete,
    input                       data_compare_error,
    output                      sys_clk_p,
    output                      sys_clk_n,
    input                       ddr4_act_n,
    input   [ADDR_WIDTH -1 : 0] ddr4_adr,
    input   [1             : 0] ddr4_ba,
    input   [0             : 0] ddr4_bg,
    input   [0             : 0] ddr4_cke,
    input   [ODT_WIDTH  -1 : 0] ddr4_odt,
    input   [CS_WIDTH   -1 : 0] ddr4_cs_n,
    input   [0             : 0] ddr4_ck_t,
    input   [0             : 0] ddr4_ck_c,
    input                       ddr4_reset_n,
    inout   [DM_WIDTH   -1 : 0] ddr4_dm_dbi_n,
    inout   [DQ_WIDTH   -1 : 0] ddr4_dq,
    inout   [DQS_WIDTH  -1 : 0] ddr4_dqs_t,
    inout   [DQS_WIDTH  -1 : 0] ddr4_dqs_c
    );

    localparam real SYSCLK_PERIOD    = tCK; 
    localparam NUM_PHYSICAL_PARTS    = (DQ_WIDTH/DRAM_WIDTH);
    localparam CLAMSHELL_PARTS       = (NUM_PHYSICAL_PARTS/2);
    localparam ODD_PARTS             = ((CLAMSHELL_PARTS*2) < NUM_PHYSICAL_PARTS) ? 1 : 0;

    localparam MRS  = 3'b000;
    localparam REF  = 3'b001;
    localparam PRE  = 3'b010;
    localparam ACT  = 3'b011;
    localparam WR   = 3'b100;
    localparam RD   = 3'b101;
    localparam ZQC  = 3'b110;
    localparam NOP  = 3'b111;

`ifndef SAMSUNG
    import arch_package::*;
    parameter UTYPE_density CONFIGURED_DENSITY = _4G;
`endif

    // Input clock is assumed to be equal to the memory clock frequency
    // User should change the parameter as necessary if a different input
    // clock frequency is used
    localparam real CLKIN_PERIOD_NS = 3332 / 1000.0;

    //initial begin
    //   $shm_open("waves.shm");
    //   $shm_probe("ACMTF");
    //end

    reg sys_clk_i;

    initial
        sys_clk_i = 1'b0;
    always
        sys_clk_i = #(3332/2.0) ~sys_clk_i;

    genvar rnk;
    genvar i;
    genvar r;
    genvar s;

    reg     [ADDR_WIDTH -1 : 0] ddr4_adr_sdram[1:0];
    reg     [1             : 0] ddr4_ba_sdram[1:0];
    reg     [0             : 0] ddr4_bg_sdram[1:0];
            
    wire    [0             : 0] ddr4_ck_t_int;
    wire    [0             : 0] ddr4_ck_c_int;

    wire            ddr4_ck_t;
    wire            ddr4_ck_c;

    wire            ddr4_reset_n;

    reg     [31: 0] cmdName;
    bit     en_model;
    tri     model_enable = en_model;

    initial begin
       #200
       en_model = 1'b0; 
       #5 en_model = 1'b1;
    end

//**************************************************************************//
// Clock Generation
//**************************************************************************//

    assign sys_clk_p = sys_clk_i;
    assign sys_clk_n = ~sys_clk_i;

    assign ddr4_ck_t = ddr4_ck_t_int[0];
    assign ddr4_ck_c = ddr4_ck_c_int[0];

    always @( * ) begin
        ddr4_adr_sdram[0]   <=  ddr4_adr;
        ddr4_adr_sdram[1]   <=  (CA_MIRROR == "ON") ?
                                       {ddr4_adr[ADDR_WIDTH-1:14],
                                        ddr4_adr[11], ddr4_adr[12],
                                        ddr4_adr[13], ddr4_adr[10:9],
                                        ddr4_adr[7], ddr4_adr[8],
                                        ddr4_adr[5], ddr4_adr[6],
                                        ddr4_adr[3], ddr4_adr[4],
                                        ddr4_adr[2:0]} :
                                        ddr4_adr;
        ddr4_ba_sdram[0]    <=  ddr4_ba;
        ddr4_ba_sdram[1]    <=  (CA_MIRROR == "ON") ?
                                        {ddr4_ba[0],
                                         ddr4_ba[1]} :
                                         ddr4_ba;
        ddr4_bg_sdram[0]    <=  ddr4_bg;
        ddr4_bg_sdram[1]    <=  ddr4_bg;
    end


//===========================================================================
// FPGA Memory Controller instantiation
//===========================================================================

    reg [ADDR_WIDTH-1:0] DDR4_ADRMOD[RANK_WIDTH-1:0];

    always @(*)
        if (ddr4_cs_n == 4'b1111)
            cmdName = "DSEL";
        else
        if (ddr4_act_n)
            casez (DDR4_ADRMOD[0][16:14])
            MRS:     cmdName = "MRS";
            REF:     cmdName = "REF";
            PRE:     cmdName = "PRE";
            WR:      cmdName = "WR";
            RD:      cmdName = "RD";
            ZQC:     cmdName = "ZQC";
            NOP:     cmdName = "NOP";
            default: cmdName = "***";
            endcase
        else
            cmdName = "ACT";

    reg wr_en;

    always@(posedge ddr4_ck_t)begin
        if(!ddr4_reset_n)begin
            wr_en <= #100 1'b0 ;
        end 
        else begin
            if(cmdName == "WR")begin
                wr_en <= #100 1'b1 ;
            end 
            else if (cmdName == "RD")begin
                wr_en <= #100 1'b0 ;
            end
        end
    end

    generate
        for (rnk = 0; rnk < CS_WIDTH; rnk++) begin:rankup
            always @(*)
                if (ddr4_act_n)
                    casez (ddr4_adr_sdram[0][16:14])
                    WR, RD: begin
                        DDR4_ADRMOD[rnk] = ddr4_adr_sdram[rnk] & 18'h1C7FF;
                    end
                    default: begin
                        DDR4_ADRMOD[rnk] = ddr4_adr_sdram[rnk];
                    end
                    endcase
                else begin
                    DDR4_ADRMOD[rnk] = ddr4_adr_sdram[rnk];
            end
        end
    endgenerate

//===========================================================================
// Memory Model instantiation
//===========================================================================

    localparam DQ_BW =  (DRAM_WIDTH == 4) ? 4 :
                       ((DRAM_WIDTH == 8) ? 8 : 16);

    generate

        DDR4_if #(.CONFIGURED_DQ_BITS (DQ_BW)) iDDR4[0:(RANK_WIDTH*NUM_PHYSICAL_PARTS)-1]();

        for (r = 0; r < RANK_WIDTH; r++) begin:memModels_Ri
            for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:memModel
                ddr4_model  #
                (
                    .CONFIGURED_DQ_BITS (DQ_BW),
                    .CONFIGURED_DENSITY (CONFIGURED_DENSITY)
                ) ddr4_model(
                    .model_enable (model_enable),
                    .iDDR4        (iDDR4[(r*NUM_PHYSICAL_PARTS)+i])
                );
            end
        end

        for (r = 0; r < RANK_WIDTH; r++) begin:tranDQ
            for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranDQ1
                for (s = 0; s < DQ_BW; s++) begin:tranDQp
`ifdef XILINX_SIMULATOR
                    short bidiDQ(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQ[s], ddr4_dq[s+i*DQ_BW]);
`else
                    tran bidiDQ(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQ[s], ddr4_dq[s+i*DQ_BW]);
`endif
                end
            end
        end

        for (r = 0; r < RANK_WIDTH; r++) begin:tranDQS
            for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranDQS1
                if (DQ_BW == 4) begin: X4_TRANSDQ
`ifdef XILINX_SIMULATOR
                    short bidiDQS(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t, ddr4_dqs_t[i]);
                    short bidiDQS_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c, ddr4_dqs_c[i]);
`else
                    tran bidiDQS(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t, ddr4_dqs_t[i]);
                    tran bidiDQS_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c, ddr4_dqs_c[i]);
`endif          
                end: X4_TRANSDQ
                else if (DQ_BW == 8) begin: X8_TRANSDQ
`ifdef XILINX_SIMULATOR
                    short bidiDQS(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t, ddr4_dqs_t[i]);
                    short bidiDQS_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c, ddr4_dqs_c[i]);
                    short bidiDM(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n, ddr4_dm_dbi_n[i]);
`else
                    tran bidiDQS(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t, ddr4_dqs_t[i]);
                    tran bidiDQS_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c, ddr4_dqs_c[i]);
                    tran bidiDM(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n, ddr4_dm_dbi_n[i]);
`endif
                end: X8_TRANSDQ 
                else begin: X16_TRANSDQ
`ifdef XILINX_SIMULATOR
                    short bidiDQS0(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t[0], ddr4_dqs_t[(2*i)]);
                    short bidiDQS0_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c[0], ddr4_dqs_c[(2*i)]);
                    short bidiDM0(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n[0], ddr4_dm_dbi_n[(2*i)]);
                    short bidiDQS1(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t[1], ddr4_dqs_t[((2*i)+1)]);
                    short bidiDQS1_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c[1], ddr4_dqs_c[((2*i)+1)]);
                    short bidiDM1(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n[1], ddr4_dm_dbi_n[((2*i)+1)]);
  
`else
                    tran bidiDQS0(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t[0], ddr4_dqs_t[(2*i)]);
                    tran bidiDQS0_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c[0], ddr4_dqs_c[(2*i)]);
                    tran bidiDM0(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n[0], ddr4_dm_dbi_n[(2*i)]);
                    tran bidiDQS1(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t[1], ddr4_dqs_t[((2*i)+1)]);
                    tran bidiDQS1_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c[1], ddr4_dqs_c[((2*i)+1)]);
                    tran bidiDM1(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n[1], ddr4_dm_dbi_n[((2*i)+1)]);
`endif
                end: X16_TRANSDQ
            end
        end

        for (r = 0; r < RANK_WIDTH; r++) begin:ADDR_RANKS
            for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:ADDR_R

                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].BG      = ddr4_bg_sdram[r];
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].BA      = ddr4_ba_sdram[r];
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ADDR_17 = (ADDR_WIDTH == 18) ? DDR4_ADRMOD[r][ADDR_WIDTH-1] : 1'b0;
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ADDR    = DDR4_ADRMOD[r][13:0];
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CS_n    = ddr4_cs_n[r];

            end
        end

        for (r = 0; r < RANK_WIDTH; r++) begin:tranADCTL_RANKS
            for (i = 0; i < NUM_PHYSICAL_PARTS; i++) begin:tranADCTL
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CK = {ddr4_ck_t, ddr4_ck_c};
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ACT_n     = ddr4_act_n;
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].RAS_n_A16 = DDR4_ADRMOD[r][16];
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CAS_n_A15 = DDR4_ADRMOD[r][15];
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].WE_n_A14  = DDR4_ADRMOD[r][14];
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CKE       = ddr4_cke[r];
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ODT       = ddr4_odt[r];
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].PARITY = 1'b0;
                assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].RESET_n = ddr4_reset_n;
            end
        end


        if ((DQ_BW == 16) && (DQ_WIDTH%16)) begin: mem_extra_bits
            // DDR4 X16 dual rank is not supported
            DDR4_if #(.CONFIGURED_DQ_BITS (16)) iDDR4[(DQ_WIDTH/DRAM_WIDTH):(DQ_WIDTH/DRAM_WIDTH)]();

            ddr4_model #(
               .CONFIGURED_DQ_BITS (16),
               .CONFIGURED_DENSITY (CONFIGURED_DENSITY)
            ) ddr4_model (
                .model_enable (model_enable),
                .iDDR4        (iDDR4[(DQ_WIDTH/DRAM_WIDTH)])
            );

            for (i = (DQ_WIDTH/DRAM_WIDTH)*16; i < DQ_WIDTH; i=i+1) begin:tranDQ
`ifdef XILINX_SIMULATOR
                short bidiDQ(iDDR4[i/16].DQ[i%16], ddr4_dq[i]);
                short bidiDQ_msb(iDDR4[i/16].DQ[(i%16)+8], ddr4_dq[i]);
`else
                tran bidiDQ(iDDR4[i/16].DQ[i%16], ddr4_dq[i]);
                tran bidiDQ_msb(iDDR4[i/16].DQ[(i%16)+8], ddr4_dq[i]);
`endif
            end

`ifdef XILINX_SIMULATOR
            short bidiDQS0(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_t[0], ddr4_dqs_t[DQS_WIDTH-1]);
            short bidiDQS0_(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_c[0], ddr4_dqs_c[DQS_WIDTH-1]);
            short bidiDM0(iDDR4[DQ_WIDTH/DRAM_WIDTH].DM_n[0], ddr4_dm_dbi_n[DM_WIDTH-1]);
            short bidiDQS1(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_t[1], ddr4_dqs_t[DQS_WIDTH-1]);
            short bidiDQS1_(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_c[1], ddr4_dqs_c[DQS_WIDTH-1]);
            short bidiDM1(iDDR4[DQ_WIDTH/DRAM_WIDTH].DM_n[1], ddr4_dm_dbi_n[DM_WIDTH-1]);
`else   
            tran bidiDQS0(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_t[0], ddr4_dqs_t[DQS_WIDTH-1]);
            tran bidiDQS0_(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_c[0], ddr4_dqs_c[DQS_WIDTH-1]);
            tran bidiDM0(iDDR4[DQ_WIDTH/DRAM_WIDTH].DM_n[0], ddr4_dm_dbi_n[DM_WIDTH-1]);
            tran bidiDQS1(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_t[1], ddr4_dqs_t[DQS_WIDTH-1]);
            tran bidiDQS1_(iDDR4[DQ_WIDTH/DRAM_WIDTH].DQS_c[1], ddr4_dqs_c[DQS_WIDTH-1]);
            tran bidiDM1(iDDR4[DQ_WIDTH/DRAM_WIDTH].DM_n[1], ddr4_dm_dbi_n[DM_WIDTH-1]);
`endif

            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].CK = {ddr4_ck_t, ddr4_ck_c};
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].ACT_n = ddr4_act_n;
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].RAS_n_A16 = DDR4_ADRMOD[0][16];
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].CAS_n_A15 = DDR4_ADRMOD[0][15];
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].WE_n_A14 = DDR4_ADRMOD[0][14];
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].CKE = ddr4_cke[0];
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].ODT = ddr4_odt[0];
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].BG = ddr4_bg_sdram[0];
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].BA = ddr4_ba_sdram[0];
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].ADDR_17 = (ADDR_WIDTH == 18) ? DDR4_ADRMOD[0][ADDR_WIDTH-1] : 1'b0;
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].ADDR = DDR4_ADRMOD[0][13:0];
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].RESET_n = ddr4_reset_n;
            assign iDDR4[DQ_WIDTH/DRAM_WIDTH].CS_n = ddr4_cs_n[0];
        end

    endgenerate

endmodule