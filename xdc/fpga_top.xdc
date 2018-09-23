##################################################
### KCU1500 Rev1.0 Master XDC file 05-24-2017 ####
##################################################
#Other net   PACKAGE_PIN AJ18     - DXP_0_N                   Bank   0 - DXN
#Other net   PACKAGE_PIN AF19     - VCCDAC                    Bank   0 - VCCADC
#Other net   PACKAGE_PIN AF18     - GNDADC                    Bank   0 - GNDADC
#Other net   PACKAGE_PIN AJ19     - DXP_0_P                   Bank   0 - DXP
#Other net   PACKAGE_PIN AH19     - VREFP_ADC                 Bank   0 - VREFP
#Other net   PACKAGE_PIN AG18     - GNDADC                    Bank   0 - VREFN
#Other net   PACKAGE_PIN AG19     - VP_ADC                    Bank   0 - VP
#Other net   PACKAGE_PIN AH18     - VN_ADC                    Bank   0 - VN
#Other net   PACKAGE_PIN V12      - M0_0                      Bank   0 - M0_0
#Other net   PACKAGE_PIN U12      - M1_0                      Bank   0 - M1_0
#Other net   PACKAGE_PIN Y12      - INIT_B_0                  Bank   0 - INIT_B_0
#Other net   PACKAGE_PIN R12      - M2_0                      Bank   0 - M2_0
#Other net   PACKAGE_PIN W12      - CFGBVS_0_W12              Bank   0 - CFGBVS_0
#Other net   PACKAGE_PIN AA12     - PUDC_B_0                  Bank   0 - PUDC_B_0
#Other net   PACKAGE_PIN AD12     - N17282053                 Bank   0 - POR_OVERRIDE
#Other net   PACKAGE_PIN AC12     - DONE_0                    Bank   0 - DONE_0
#Other net   PACKAGE_PIN AE12     - PROGRAM_B_0               Bank   0 - PROGRAM_B_0
#Other net   PACKAGE_PIN AE15     - TDI_0                     Bank   0 - TDI_0
#Other net   PACKAGE_PIN AG12     - SPI0_CS_B                 Bank   0 - RDWR_FCS_B_0
#Other net   PACKAGE_PIN AL12     - SPI0_WP_                  Bank   0 - D02_0
#Other net   PACKAGE_PIN AK12     - SPI0_DQ0                  Bank   0 - D00_MOSI_0
#Other net   PACKAGE_PIN AH12     - SPI0_HOLD_B               Bank   0 - D03_0
#Other net   PACKAGE_PIN AJ12     - SPI0_DQ1                  Bank   0 - D01_DIN_0
#Other net   PACKAGE_PIN AG15     - TMS_0                     Bank   0 - TMS_0
#Other net   PACKAGE_PIN AG13     - FPGA_CCLK                 Bank   0 - CCLK_0
#Other net   PACKAGE_PIN AE13     - TCK_0                     Bank   0 - TCK_0
#Other net   PACKAGE_PIN AM12     - N17282696                 Bank   0 - VBATT
#Other net   PACKAGE_PIN AC13     - TDO_0                     Bank   1 - TDO_0
set_property PACKAGE_PIN AL29      [get_ports {c0_ddr4_dq[29]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[29]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_44
set_property PACKAGE_PIN AL30      [get_ports {c0_ddr4_dq[31]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[31]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_44
set_property PACKAGE_PIN AM31      [get_ports {c0_ddr4_dq[30]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[30]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_44
set_property PACKAGE_PIN AN31      [get_ports {c0_ddr4_dq[28]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[28]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_44

set_property PACKAGE_PIN AM29      [get_ports {c0_ddr4_dqs_t[3]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_44
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_t[3]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_44
set_property PACKAGE_PIN AM30      [get_ports {c0_ddr4_dqs_c[3]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_44
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_c[3]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_44

set_property PACKAGE_PIN AN29      [get_ports {c0_ddr4_dq[24]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[24]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_44
set_property PACKAGE_PIN AP29      [get_ports {c0_ddr4_dq[26]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[26]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_44
set_property PACKAGE_PIN AP30      [get_ports {c0_ddr4_dq[27]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[27]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_44
set_property PACKAGE_PIN AR30      [get_ports {c0_ddr4_dq[25]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[25]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_44
set_property PACKAGE_PIN AP31      [get_ports {c0_ddr4_dm_dbi_n[3]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L19P_T3L_N0_DBC_AD9P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dm_dbi_n[3]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L19P_T3L_N0_DBC_AD9P_44
set_property PACKAGE_PIN AT29      [get_ports {c0_ddr4_dq[20]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[20]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_44
set_property PACKAGE_PIN AT30      [get_ports {c0_ddr4_dq[17]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[17]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_44
set_property PACKAGE_PIN AU30      [get_ports {c0_ddr4_dq[16]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[16]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_44
set_property PACKAGE_PIN AU31      [get_ports {c0_ddr4_dq[21]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[21]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_44

set_property PACKAGE_PIN AU29      [get_ports {c0_ddr4_dqs_t[2]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_44
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_t[2]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_44
set_property PACKAGE_PIN AV29      [get_ports {c0_ddr4_dqs_c[2]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_44
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_c[2]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_44

set_property PACKAGE_PIN AU32      [get_ports {c0_ddr4_dq[19]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[19]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_44
set_property PACKAGE_PIN AV32      [get_ports {c0_ddr4_dq[23]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[23]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_44
set_property PACKAGE_PIN AV31      [get_ports {c0_ddr4_dq[18]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[18]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_44
set_property PACKAGE_PIN AW31      [get_ports {c0_ddr4_dq[22]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[22]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_44


set_property PACKAGE_PIN AW29      [get_ports {c0_ddr4_dm_dbi_n[2]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dm_dbi_n[2]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_44


set_property PACKAGE_PIN AW30      [get_ports "RANK44_PIN_AW30"] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_44
set_property IOSTANDARD  SSTL12_DCI [get_ports "RANK44_PIN_AW30"] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_44


set_property PACKAGE_PIN AY31      [get_ports {c0_ddr4_dq[14]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[14]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_44
set_property PACKAGE_PIN AY32      [get_ports {c0_ddr4_dq[9]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[9]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_44
set_property PACKAGE_PIN AY30      [get_ports {c0_ddr4_dq[11]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[11]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_44
set_property PACKAGE_PIN BA30      [get_ports {c0_ddr4_dq[12]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[12]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_44

set_property PACKAGE_PIN BA32      [get_ports {c0_ddr4_dqs_t[1]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_44
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_t[1]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_44
set_property PACKAGE_PIN BB32      [get_ports {c0_ddr4_dqs_c[1]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_44
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_c[1]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_44

set_property PACKAGE_PIN BA29      [get_ports {c0_ddr4_dq[10]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[10]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_44
set_property PACKAGE_PIN BB29      [get_ports {c0_ddr4_dq[8]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[8]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_44
set_property PACKAGE_PIN BB30      [get_ports {c0_ddr4_dq[15]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[15]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_44
set_property PACKAGE_PIN BB31      [get_ports {c0_ddr4_dq[13]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[13]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_44

set_property PACKAGE_PIN BC31      [get_ports {c0_ddr4_dm_dbi_n[1]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dm_dbi_n[1]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_44

set_property PACKAGE_PIN BC29      [get_ports {c0_ddr4_dq[7]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[7]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_44
set_property PACKAGE_PIN BD29      [get_ports {c0_ddr4_dq[4]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[4]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_44
set_property PACKAGE_PIN BD33      [get_ports {c0_ddr4_dq[5]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[5]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_44
set_property PACKAGE_PIN BE33      [get_ports {c0_ddr4_dq[3]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[3]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_44

set_property PACKAGE_PIN BD30      [get_ports {c0_ddr4_dqs_t[0]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_44
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_t[0]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_44
set_property PACKAGE_PIN BD31      [get_ports {c0_ddr4_dqs_c[0]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_44
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_c[0]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_44

set_property PACKAGE_PIN BE30      [get_ports {c0_ddr4_dq[6]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[6]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_44
set_property PACKAGE_PIN BF30      [get_ports {c0_ddr4_dq[1]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[1]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_44
set_property PACKAGE_PIN BE31      [get_ports {c0_ddr4_dq[2]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[2]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_44
set_property PACKAGE_PIN BE32      [get_ports {c0_ddr4_dq[0]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[0]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_44

set_property PACKAGE_PIN BF34      [get_ports "VRP_44"] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_44
set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_44"] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_44
set_property PACKAGE_PIN BF32      [get_ports {c0_ddr4_dm_dbi_n[0]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L1P_T0L_N0_DBC_44
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dm_dbi_n[0]}] ;# Bank  44 VCCO - VCC1V2_FPGA - IO_L1P_T0L_N0_DBC_44


#Other net   PACKAGE_PIN AK30     - VREF_44                   Bank  44 - VREF_44
set_property PACKAGE_PIN AL34      [get_ports {c0_ddr4_adr[14]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[14]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_45
set_property PACKAGE_PIN AM34      [get_ports {c0_ddr4_adr[0]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_45
set_property IOSTANDARD  SSTL12_DCU [get_ports {c0_ddr4_adr[0]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_45
set_property PACKAGE_PIN AL33      [get_ports {c0_ddr4_adr[2]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_T3U_N12_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[2]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_T3U_N12_45
set_property PACKAGE_PIN AL32      [get_ports {c0_ddr4_adr[8]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[8]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_45
set_property PACKAGE_PIN AM32      [get_ports {c0_ddr4_adr[10]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[10]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_45
set_property PACKAGE_PIN AN32      [get_ports {c0_ddr4_adr[16]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[16]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_45
set_property PACKAGE_PIN AN33      [get_ports {c0_ddr4_adr[11]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[11]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_45
set_property PACKAGE_PIN AN34      [get_ports {c0_ddr4_adr[15]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[15]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_45
set_property PACKAGE_PIN AP34      [get_ports {c0_ddr4_adr[13]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[13]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_45
set_property PACKAGE_PIN AP33      [get_ports {c0_ddr4_adr[9]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[9]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_45
set_property PACKAGE_PIN AR33      [get_ports {c0_ddr4_adr[3]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[3]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_45
set_property PACKAGE_PIN AT33      [get_ports {c0_ddr4_adr[12]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L19P_T3L_N0_DBC_AD9P_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[12]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L19P_T3L_N0_DBC_AD9P_45
set_property PACKAGE_PIN AT34      [get_ports {c0_ddr4_adr[7]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L19N_T3L_N1_DBC_AD9N_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[7]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L19N_T3L_N1_DBC_AD9N_45
set_property PACKAGE_PIN AV33      [get_ports {c0_ddr4_adr[4]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[4]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_45
set_property PACKAGE_PIN AW33      [get_ports {c0_ddr4_adr[1]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[1]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_45
set_property PACKAGE_PIN AV34      [get_ports {c0_ddr4_adr[6]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[6]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_45
set_property PACKAGE_PIN AW34      [get_ports {c0_ddr4_adr[5]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_adr[5]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_45

set_property PACKAGE_PIN AW35            [get_ports {c0_ddr4_ck_t}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_45
set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports {c0_ddr4_ck_t}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_45
set_property PACKAGE_PIN AW36            [get_ports {c0_ddr4_ck_c}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_45
set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports {c0_ddr4_ck_c}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_45

set_property PACKAGE_PIN AY33      [get_ports {c0_ddr4_bg[0]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_bg[0]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_45
set_property PACKAGE_PIN BA33      [get_ports {c0_ddr4_act_n}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_act_n}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_45
set_property PACKAGE_PIN AY35      [get_ports {c0_ddr4_ba[0]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_ba[0]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_45
set_property PACKAGE_PIN AY36      [get_ports {c0_ddr4_ba[1]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_ba[1]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_45
set_property PACKAGE_PIN AU34      [get_ports "DDR4_C0_ALERT_B"] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_T2U_N12_45
set_property IOSTANDARD  SSTL12_DCI [get_ports "DDR4_C0_ALERT_B"] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_T2U_N12_45

set_property PACKAGE_PIN BA34      [get_ports {c0_sys_clk_p}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_45
set_property IOSTANDARD  DIFF_SSTL12 [get_ports {c0_sys_clk_p}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_45
set_property PACKAGE_PIN BB34      [get_ports {c0_sys_clk_n}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_45
set_property IOSTANDARD  DIFF_SSTL12 [get_ports {c0_sys_clk_n}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_45

set_property PACKAGE_PIN BA35      [get_ports {c0_ddr4_dq[64]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_45
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[64]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_45
set_property PACKAGE_PIN BB35      [get_ports {c0_ddr4_dq[65]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_45
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[65]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_45

set_property PACKAGE_PIN BF35       [get_ports {c0_ddr4_cke}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_T1U_N12_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_cke}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_T1U_N12_45

set_property PACKAGE_PIN BB36      [get_ports {c0_ddr4_dq[66]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_45
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[66]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_45
set_property PACKAGE_PIN BC36      [get_ports {c0_ddr4_dq[67]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_45
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[67]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_45

set_property PACKAGE_PIN BB37      [get_ports {c0_ddr4_dqs_t[8]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_45
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_t[8]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_45
set_property PACKAGE_PIN BC37      [get_ports {c0_ddr4_dqs_c[8]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_45
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_c[8]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_45

set_property PACKAGE_PIN BD36      [get_ports {c0_ddr4_dq[68]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_45
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[68]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_45
set_property PACKAGE_PIN BE36      [get_ports {c0_ddr4_dq[69]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_45
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[69]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_45
set_property PACKAGE_PIN BD35      [get_ports {c0_ddr4_dq[70]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_45
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[70]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_45
set_property PACKAGE_PIN BE35      [get_ports {c0_ddr4_dq[71]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_45
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[71]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_45

set_property PACKAGE_PIN BC34      [get_ports {c0_ddr4_dm_dbi_n[8]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_45
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dm_dbi_n[8]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_45
set_property PACKAGE_PIN BD34      [get_ports {c0_ddr4_odt}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L7N_T1L_N1_QBC_AD13N_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_odt}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L7N_T1L_N1_QBC_AD13N_45
set_property PACKAGE_PIN BB38      [get_ports "DDR4_C0_CS_TOP_B"] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_45
set_property IOSTANDARD  SSTL12_DCI [get_ports "DDR4_C0_CS_TOP_B"] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_45
set_property PACKAGE_PIN BC38      [get_ports {c0_ddr4_cs_n[0]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_45
set_property IOSTANDARD  SSTL12_DCI [get_ports {c0_ddr4_cs_n[0]}] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_45
set_property PACKAGE_PIN BD38      [get_ports "VRP_45"] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_45
set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_45"] ;# Bank  45 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_45


#Other net   PACKAGE_PIN AK33     - VREF45                    Bank  45 - VREF_45
set_property PACKAGE_PIN W33       [get_ports {c0_ddr4_dq[56]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[56]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_46
set_property PACKAGE_PIN W34       [get_ports {c0_ddr4_dq[63]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[63]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_46
set_property PACKAGE_PIN Y32       [get_ports {c0_ddr4_dq[57]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[57]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_46
set_property PACKAGE_PIN Y33       [get_ports {c0_ddr4_dq[58]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[58]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_46

set_property PACKAGE_PIN W31       [get_ports {c0_ddr4_dqs_t[7]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_46
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_t[7]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_46
set_property PACKAGE_PIN Y31       [get_ports {c0_ddr4_dqs_c[7]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_46
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_c[7]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_46

set_property PACKAGE_PIN W30       [get_ports {c0_ddr4_dq[60]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[60]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_46
set_property PACKAGE_PIN Y30       [get_ports {c0_ddr4_dq[61]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[61]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_46
set_property PACKAGE_PIN AA34      [get_ports {c0_ddr4_dq[59]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[59]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_46
set_property PACKAGE_PIN AB34      [get_ports {c0_ddr4_dq[62]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[62]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_46

set_property PACKAGE_PIN AA32      [get_ports {c0_ddr4_dm_dbi_n[7]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L19P_T3L_N0_DBC_AD9P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dm_dbi_n[7]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L19P_T3L_N0_DBC_AD9P_46

set_property PACKAGE_PIN AC34      [get_ports {c0_ddr4_dq[51]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[51]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_46
set_property PACKAGE_PIN AD34      [get_ports {c0_ddr4_dq[50]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[50]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_46
set_property PACKAGE_PIN AC32      [get_ports {c0_ddr4_dq[48]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[48]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_46
set_property PACKAGE_PIN AC33      [get_ports {c0_ddr4_dq[52]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[52]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_46

set_property PACKAGE_PIN AC31      [get_ports {c0_ddr4_dqs_t[6]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_46
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_t[6]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_46
set_property PACKAGE_PIN AD31      [get_ports {c0_ddr4_dqs_c[6]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_46
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_c[6]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_46

set_property PACKAGE_PIN AE30      [get_ports {c0_ddr4_dq[53]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[53]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_46
set_property PACKAGE_PIN AF30      [get_ports {c0_ddr4_dq[49]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[49]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_46
set_property PACKAGE_PIN AD33      [get_ports {c0_ddr4_dq[54]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[54]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_46
set_property PACKAGE_PIN AE33      [get_ports {c0_ddr4_dq[55]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[55]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_46

set_property PACKAGE_PIN AE31      [get_ports {c0_ddr4_dm_dbi_n[6]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dm_dbi_n[6]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_46

set_property PACKAGE_PIN AF32      [get_ports {c0_ddr4_dq[47]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[47]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_46
set_property PACKAGE_PIN AF33      [get_ports {c0_ddr4_dq[42]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[42]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_46
set_property PACKAGE_PIN AG31      [get_ports {c0_ddr4_dq[44]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[44]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_46
set_property PACKAGE_PIN AG32      [get_ports {c0_ddr4_dq[45]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[45]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_46

set_property PACKAGE_PIN AH31      [get_ports {c0_ddr4_dqs_t[5]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_46
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_t[5]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_46
set_property PACKAGE_PIN AH32      [get_ports {c0_ddr4_dqs_c[5]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_46
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_c[5]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_46

set_property PACKAGE_PIN AF34      [get_ports {c0_ddr4_dq[46]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[46]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_46
set_property PACKAGE_PIN AG34      [get_ports {c0_ddr4_dq[43]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[43]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_46
set_property PACKAGE_PIN AH33      [get_ports {c0_ddr4_dq[40]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[40]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_46
set_property PACKAGE_PIN AJ33      [get_ports {c0_ddr4_dq[41]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[41]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_46

set_property PACKAGE_PIN AH34      [get_ports {c0_ddr4_dm_dbi_n[5]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dm_dbi_n[5]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_46
set_property PACKAGE_PIN AJ34      [get_ports {c0_ddr4_reset_n}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L7N_T1L_N1_QBC_AD13N_46
set_property IOSTANDARD  LVCOS12   [get_ports {c0_ddr4_reset_n}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L7N_T1L_N1_QBC_AD13N_46

set_property PACKAGE_PIN AJ31      [get_ports {c0_ddr4_dq[33]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[33]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_46
set_property PACKAGE_PIN AK31      [get_ports {c0_ddr4_dq[38]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[38]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_46
set_property PACKAGE_PIN AG29      [get_ports {c0_ddr4_dq[37]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[37]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_46
set_property PACKAGE_PIN AG30      [get_ports {c0_ddr4_dq[35]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[35]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_46

set_property PACKAGE_PIN AH28      [get_ports {c0_ddr4_dqs_t[4]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_46
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_t[4]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_46
set_property PACKAGE_PIN AH29      [get_ports {c0_ddr4_dqs_c[4]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_46
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c0_ddr4_dqs_c[4]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_46

set_property PACKAGE_PIN AJ29      [get_ports {c0_ddr4_dq[34]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[34]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_46
set_property PACKAGE_PIN AJ30      [get_ports {c0_ddr4_dq[39]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[39]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_46
set_property PACKAGE_PIN AJ28      [get_ports {c0_ddr4_dq[36]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[36]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_46
set_property PACKAGE_PIN AK28      [get_ports {c0_ddr4_dq[32]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dq[32]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_46
set_property PACKAGE_PIN AK26      [get_ports "VRP_46"] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_46
set_property IOSTANDARD  LVCMOSxx  [get_ports "VRP_46"] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_46
set_property PACKAGE_PIN AJ27      [get_ports {c0_ddr4_dm_dbi_n[4]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L1P_T0L_N0_DBC_46
set_property IOSTANDARD  POD12_DCI [get_ports {c0_ddr4_dm_dbi_n[4]}] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L1P_T0L_N0_DBC_46
set_property PACKAGE_PIN AK27       [get_ports "RANK_46_PIN_AK27"] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L1N_T0L_N1_DBC_46
set_property IOSTANDARD  SSTL12_DCI [get_ports "RANK_46_PIN_AK27"] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_L1N_T0L_N1_DBC_46



#Other net   PACKAGE_PIN T29      - VREF_52                   Bank  53 - VREF_53
#Other net   PACKAGE_PIN AK25     - N17295924                 Bank  65 - VREF_65
set_property PACKAGE_PIN AY28     [get_ports "DDR4_RESET_GATING"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L12N_T1U_N11_GC_A09_D25_65
set_property IOSTANDARD  LVCMOS18 [get_ports "DDR4_RESET_GATING"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L12N_T1U_N11_GC_A09_D25_65
set_property PACKAGE_PIN AW25     [get_ports "USER_LED_0"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L10P_T1U_N6_QBC_AD4P_A12_D28_65
set_property IOSTANDARD  LVCMOS18 [get_ports "USER_LED_0"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L10P_T1U_N6_QBC_AD4P_A12_D28_65
set_property PACKAGE_PIN AY25     [get_ports "USER_LED_1"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L10N_T1U_N7_QBC_AD4N_A13_D29_65
set_property IOSTANDARD  LVCMOS18 [get_ports "USER_LED_1"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L10N_T1U_N7_QBC_AD4N_A13_D29_65
set_property PACKAGE_PIN BA27     [get_ports "USER_LED_2"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L9P_T1L_N4_AD12P_A14_D30_65
set_property IOSTANDARD  LVCMOS18 [get_ports "USER_LED_2"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L9P_T1L_N4_AD12P_A14_D30_65
set_property PACKAGE_PIN BA28     [get_ports "USER_LED_3"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L9N_T1L_N5_AD12N_A15_D31_65
set_property IOSTANDARD  LVCMOS18 [get_ports "USER_LED_3"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L9N_T1L_N5_AD12N_A15_D31_65
set_property PACKAGE_PIN BB26     [get_ports "USER_LED_4"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L8P_T1L_N2_AD5P_A16_65
set_property IOSTANDARD  LVCMOS18 [get_ports "USER_LED_4"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L8P_T1L_N2_AD5P_A16_65
set_property PACKAGE_PIN BB27     [get_ports "USER_LED_5"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L8N_T1L_N3_AD5N_A17_65
set_property IOSTANDARD  LVCMOS18 [get_ports "USER_LED_5"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L8N_T1L_N3_AD5N_A17_65
set_property PACKAGE_PIN BA25     [get_ports "USER_LED_6"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L7P_T1L_N0_QBC_AD13P_A18_65
set_property IOSTANDARD  LVCMOS18 [get_ports "USER_LED_6"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L7P_T1L_N0_QBC_AD13P_A18_65
set_property PACKAGE_PIN BB25     [get_ports "USER_LED_7"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L7N_T1L_N1_QBC_AD13N_A19_65
set_property IOSTANDARD  LVCMOS18 [get_ports "USER_LED_7"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L7N_T1L_N1_QBC_AD13N_A19_65
set_property PACKAGE_PIN BE26     [get_ports "CPU_RESET"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L4N_T0U_N7_DBC_AD7N_A25_65
set_property IOSTANDARD  LVCMOS18 [get_ports "CPU_RESET"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L4N_T0U_N7_DBC_AD7N_A25_65
set_property PACKAGE_PIN BF28     [get_ports "TESTCLK_OUT"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L1P_T0L_N0_DBC_RS0_65
set_property IOSTANDARD  LVCMOS18 [get_ports "TESTCLK_OUT"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L1P_T0L_N0_DBC_RS0_65

set_property PACKAGE_PIN AL20      [get_ports {c1_ddr4_dq[29]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[29]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_66
set_property PACKAGE_PIN AM20      [get_ports {c1_ddr4_dq[31]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[31]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_66
set_property PACKAGE_PIN AL19      [get_ports {c1_ddr4_dq[30]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[30]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_66
set_property PACKAGE_PIN AM19      [get_ports {c1_ddr4_dq[28]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[28]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_66

set_property PACKAGE_PIN AL17       [get_ports {c1_ddr4_dqs_t[3]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_66
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_t[3]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_66
set_property PACKAGE_PIN AM17       [get_ports {c1_ddr4_dqs_c[3]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_66
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_c[3]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_66

set_property PACKAGE_PIN AM16      [get_ports {c1_ddr4_dq[24]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[24]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_66
set_property PACKAGE_PIN AN16      [get_ports {c1_ddr4_dq[26]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[26]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_66
set_property PACKAGE_PIN AN19      [get_ports {c1_ddr4_dq[27]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[27]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_66
set_property PACKAGE_PIN AP19      [get_ports {c1_ddr4_dq[25]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[25]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_66
set_property PACKAGE_PIN AN18      [get_ports {c1_ddr4_dm_dbi_n[3]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L19P_T3L_N0_DBC_AD9P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dm_dbi_n[3]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L19P_T3L_N0_DBC_AD9P_66
set_property PACKAGE_PIN AP20      [get_ports {c1_ddr4_dq[20]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[20]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_66
set_property PACKAGE_PIN AR20      [get_ports {c1_ddr4_dq[17]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[17]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_66
set_property PACKAGE_PIN AP18      [get_ports {c1_ddr4_dq[16]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[16]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_66
set_property PACKAGE_PIN AR18      [get_ports {c1_ddr4_dq[21]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[21]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_66

set_property PACKAGE_PIN AR17      [get_ports {c1_ddr4_dqs_t[2]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_66
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_t[2]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_66
set_property PACKAGE_PIN AT17      [get_ports {c1_ddr4_dqs_c[2]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_66
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_c[2]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_66

set_property PACKAGE_PIN AT18      [get_ports {c1_ddr4_dq[19]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[19]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_66
set_property PACKAGE_PIN AU17      [get_ports {c1_ddr4_dq[23]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[23]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_66
set_property PACKAGE_PIN AT20      [get_ports {c1_ddr4_dq[18]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[18]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_66
set_property PACKAGE_PIN AU20      [get_ports {c1_ddr4_dq[22]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[22]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_66

set_property PACKAGE_PIN AT19      [get_ports {c1_ddr4_dm_dbi_n[2]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dm_dbi_n[2]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_66
set_property PACKAGE_PIN AU19      [get_ports {c1_ddr4_reset_n}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_66
set_property IOSTANDARD  LVCMOS12  [get_ports {c1_ddr4_reset_n}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_66

set_property PACKAGE_PIN AV19      [get_ports {c1_ddr4_dq[14]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[14]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_66
set_property PACKAGE_PIN AW19      [get_ports {c1_ddr4_dq[9]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[9]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_66

set_property PACKAGE_PIN AV17      [get_ports "DDR4_C1_ALERT_B"] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_T1U_N12_66
set_property IOSTANDARD  SSTL12_DCI [get_ports "DDR4_C1_ALERT_B"] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_T1U_N12_66

set_property PACKAGE_PIN AV18      [get_ports {c1_ddr4_dq[11]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[11]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_66
set_property PACKAGE_PIN AW18      [get_ports {c1_ddr4_dq[12]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[12]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_66

set_property PACKAGE_PIN AV21      [get_ports {c1_ddr4_dqs_t[1]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_66
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_t[1]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_66
set_property PACKAGE_PIN AW21      [get_ports {c1_ddr4_dqs_c[1]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_66
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_c[1]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_66

set_property PACKAGE_PIN AW20      [get_ports {c1_ddr4_dq[10]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[10]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_66
set_property PACKAGE_PIN AY20      [get_ports {c1_ddr4_dq[8]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[8]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_66
set_property PACKAGE_PIN AY18      [get_ports {c1_ddr4_dq[15]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[15]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_66
set_property PACKAGE_PIN BA18      [get_ports {c1_ddr4_dq[13]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[13]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_66
set_property PACKAGE_PIN AY17      [get_ports {c1_ddr4_dm_dbi_n[1]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dm_dbi_n[1]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_66
set_property PACKAGE_PIN BB19      [get_ports {c1_ddr4_dq[7]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[7]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_66
set_property PACKAGE_PIN BC18      [get_ports {c1_ddr4_dq[4]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[4]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_66
set_property PACKAGE_PIN BB17      [get_ports {c1_ddr4_dq[5]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[5]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_66
set_property PACKAGE_PIN BC17      [get_ports {c1_ddr4_dq[3]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[3]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_66

set_property PACKAGE_PIN BC19      [get_ports {c1_ddr4_dqs_t[0]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_66
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_t[0]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_66
set_property PACKAGE_PIN BD19      [get_ports {c1_ddr4_dqs_c[0]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_66
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_c[0]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_66

set_property PACKAGE_PIN BD18      [get_ports {c1_ddr4_dq[6]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[6]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_66
set_property PACKAGE_PIN BE18      [get_ports {c1_ddr4_dq[1]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[1]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_66
set_property PACKAGE_PIN BF19      [get_ports {c1_ddr4_dq[2]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[2]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_66
set_property PACKAGE_PIN BF18      [get_ports {c1_ddr4_dq[0]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[0]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_66
set_property PACKAGE_PIN BA19      [get_ports "VRP_66"] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_66
set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_66"] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_66
set_property PACKAGE_PIN BE17      [get_ports {c1_ddr4_dm_dbi_n[0]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L1P_T0L_N0_DBC_66
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dm_dbi_n[0]}] ;# Bank  66 VCCO - VCC1V2_FPGA - IO_L1P_T0L_N0_DBC_66


#Other net   PACKAGE_PIN AL18     - VREF_66                   Bank  66 - VREF_66
set_property PACKAGE_PIN AL14       [get_ports {c1_ddr4_adr[14]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[14]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_67
set_property PACKAGE_PIN AM14       [get_ports {c1_ddr4_adr[0]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[0]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_67
set_property PACKAGE_PIN AT13       [get_ports {c1_ddr4_adr[2]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_T3U_N12_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[2]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_T3U_N12_67
set_property PACKAGE_PIN AL15       [get_ports {c1_ddr4_adr[8]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[8]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_67
set_property PACKAGE_PIN AM15       [get_ports {c1_ddr4_adr[10]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[10]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_67
set_property PACKAGE_PIN AP13       [get_ports {c1_ddr4_adr[16]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[16]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_67
set_property PACKAGE_PIN AR13      [get_ports {c1_ddr4_adr[11]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[11]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_67
set_property PACKAGE_PIN AN14      [get_ports {c1_ddr4_adr[15]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[15]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_67
set_property PACKAGE_PIN AN13      [get_ports {c1_ddr4_adr[13]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[13]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_67
set_property PACKAGE_PIN AP15      [get_ports {c1_ddr4_adr[9]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[9]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_67
set_property PACKAGE_PIN AP14      [get_ports {c1_ddr4_adr[3]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[3]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_67
set_property PACKAGE_PIN AR16      [get_ports {c1_ddr4_adr[12]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L19P_T3L_N0_DBC_AD9P_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[12]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L19P_T3L_N0_DBC_AD9P_67
set_property PACKAGE_PIN AR15      [get_ports {c1_ddr4_adr[7]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L19N_T3L_N1_DBC_AD9N_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[7]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L19N_T3L_N1_DBC_AD9N_67
set_property PACKAGE_PIN AU16      [get_ports {c1_ddr4_adr[4]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[4]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_67
set_property PACKAGE_PIN AV16      [get_ports {c1_ddr4_adr[1]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[1]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_67
set_property PACKAGE_PIN AT15      [get_ports {c1_ddr4_adr[6]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[6]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_67
set_property PACKAGE_PIN AU15      [get_ports {c1_ddr4_adr[5]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_adr[5]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_67


set_property PACKAGE_PIN AU14            [get_ports {c1_ddr4_ck_t}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_67
set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports {c1_ddr4_ck_t}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_67
set_property PACKAGE_PIN AV14            [get_ports {c1_ddr4_ck_c}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_67
set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports {c1_ddr4_ck_c}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_67


set_property PACKAGE_PIN AU13      [get_ports {c1_ddr4_bg[0]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_bg[0]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_67
set_property PACKAGE_PIN AV13      [get_ports {c1_ddr4_act_n}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_act_n}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_67
set_property PACKAGE_PIN AW16      [get_ports {c1_ddr4_ba[0]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_ba[0]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_67
set_property PACKAGE_PIN AW15      [get_ports {c1_ddr4_ba[1]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_ba[1]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_67
set_property PACKAGE_PIN AT14      [get_ports {c1_ddr4_cs_n[0]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_T2U_N12_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_cs_n[0]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_T2U_N12_67
set_property PACKAGE_PIN AW14      [get_ports {c1_sys_clk_p}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_67
set_property IOSTANDARD  DIFF_SSTL12 [get_ports {c1_sys_clk_p}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L13P_T2L_N0_GC_QBC_67
set_property PACKAGE_PIN AW13      [get_ports {c1_sys_clk_n}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_67
set_property IOSTANDARD  DIFF_SSTL12 [get_ports {c1_sys_clk_n}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_67
set_property PACKAGE_PIN AY13      [get_ports {c1_ddr4_dq[47]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[47]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_67
set_property PACKAGE_PIN BA13      [get_ports {c1_ddr4_dq[42]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[42]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_67
set_property PACKAGE_PIN BB16       [get_ports {c1_ddr4_cke}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_T1U_N12_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_cke}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_T1U_N12_67
set_property PACKAGE_PIN BA15      [get_ports {c1_ddr4_dq[44]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[44]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_67
set_property PACKAGE_PIN BA14      [get_ports {c1_ddr4_dq[45]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[45]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_67
set_property PACKAGE_PIN BB15      [get_ports {c1_ddr4_dqs_t[5]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_67
set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports {c1_ddr4_dqs_t[5]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_67
set_property PACKAGE_PIN BB14      [get_ports {c1_ddr4_dqs_c[5]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_67
set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports {c1_ddr4_dqs_c[5]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_67
set_property PACKAGE_PIN AY16      [get_ports {c1_ddr4_dq[46]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[46]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_67
set_property PACKAGE_PIN AY15      [get_ports {c1_ddr4_dq[43]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[43]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_67
set_property PACKAGE_PIN AY12      [get_ports {c1_ddr4_dq[40]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[40]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_67
set_property PACKAGE_PIN AY11      [get_ports {c1_ddr4_dq[41]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[41]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_67
set_property PACKAGE_PIN BA12      [get_ports {c1_ddr4_dm_dbi_n[5]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dm_dbi_n[5]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_67
set_property PACKAGE_PIN BB12      [get_ports {c1_ddr4_odt}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L7N_T1L_N1_QBC_AD13N_67
set_property IOSTANDARD  SSTL12_DCI [get_ports {c1_ddr4_odt}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L7N_T1L_N1_QBC_AD13N_67
set_property PACKAGE_PIN BC14      [get_ports {c1_ddr4_dq[33]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[33]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_67
set_property PACKAGE_PIN BC13      [get_ports {c1_ddr4_dq[38]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[38]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_67
set_property PACKAGE_PIN BD15      [get_ports {c1_ddr4_dq[37]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[37]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_67
set_property PACKAGE_PIN BD14      [get_ports {c1_ddr4_dq[35]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[35]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_67
set_property PACKAGE_PIN BD13      [get_ports {c1_ddr4_dqs_t[4]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_67
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_t[4]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_67
set_property PACKAGE_PIN BE13      [get_ports {c1_ddr4_dqs_c[4]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_67
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_c[4]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_67
set_property PACKAGE_PIN BD16      [get_ports {c1_ddr4_dq[34]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[34]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_67
set_property PACKAGE_PIN BE16      [get_ports {c1_ddr4_dq[39]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[39]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_67
set_property PACKAGE_PIN BE15      [get_ports {c1_ddr4_dq[36]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[36]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_67
set_property PACKAGE_PIN BF15      [get_ports {c1_ddr4_dq[32]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[32]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_67
set_property PACKAGE_PIN BC16      [get_ports "VRP_67"] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_67
set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_67"] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_67
set_property PACKAGE_PIN BF14      [get_ports {c1_ddr4_dm_dbi_n[4]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L1P_T0L_N0_DBC_67
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dm_dbi_n[4]}] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L1P_T0L_N0_DBC_67
set_property PACKAGE_PIN BF13      [get_ports "DDR4_C1_CS_TOP_B"] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L1N_T0L_N1_DBC_67
set_property IOSTANDARD  SSTL12_DCI [get_ports "DDR4_C1_CS_TOP_B"] ;# Bank  67 VCCO - VCC1V2_FPGA - IO_L1N_T0L_N1_DBC_67


#Other net   PACKAGE_PIN AL13     - VREF67                    Bank  67 - VREF_67
set_property PACKAGE_PIN BA9       [get_ports {c1_ddr4_dq[56]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[56]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_68
set_property PACKAGE_PIN BA8       [get_ports {c1_ddr4_dq[63]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[63]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_68
set_property PACKAGE_PIN BB9       [get_ports {c1_ddr4_dq[57]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[57]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_68
set_property PACKAGE_PIN BC9       [get_ports {c1_ddr4_dq[58]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[58]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_68
set_property PACKAGE_PIN BA7       [get_ports {c1_ddr4_dqs_t[7]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_68
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_t[7]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_68
set_property PACKAGE_PIN BB7        [get_ports {c1_ddr4_dqs_c[7]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_68
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_c[7]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_68
set_property PACKAGE_PIN BC8       [get_ports {c1_ddr4_dq[60]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[60]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_68
set_property PACKAGE_PIN BC7       [get_ports {c1_ddr4_dq[61]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[61]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_68
set_property PACKAGE_PIN BB11      [get_ports {c1_ddr4_dq[59]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[59]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_68
set_property PACKAGE_PIN BB10      [get_ports {c1_ddr4_dq[62]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[62]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_68
set_property PACKAGE_PIN BC12      [get_ports {c1_ddr4_dm_dbi_n[7]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dm_dbi_n[7]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L7P_T1L_N0_QBC_AD13P_68
set_property PACKAGE_PIN BD9       [get_ports {c1_ddr4_dq[51]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[51]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_68
set_property PACKAGE_PIN BD8       [get_ports {c1_ddr4_dq[50]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[50]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_68
set_property PACKAGE_PIN BE12      [get_ports {c1_ddr4_dq[48]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[48]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_68
set_property PACKAGE_PIN BF12      [get_ports {c1_ddr4_dq[52]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[52]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_68
set_property PACKAGE_PIN BE11      [get_ports {c1_ddr4_dqs_t[6]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_68
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_t[6]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_68
set_property PACKAGE_PIN BE10      [get_ports {c1_ddr4_dqs_c[6]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_68
set_property IOSTANDARD  DIFF_POD12_DCI [get_ports {c1_ddr4_dqs_c[6]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_68
set_property PACKAGE_PIN BF10      [get_ports {c1_ddr4_dq[53]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[53]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_68
set_property PACKAGE_PIN BF9       [get_ports {c1_ddr4_dq[49]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[49]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_68
set_property PACKAGE_PIN BE8       [get_ports {c1_ddr4_dq[54]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[54]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_68
set_property PACKAGE_PIN BF8       [get_ports {c1_ddr4_dq[55]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dq[55]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_68
set_property PACKAGE_PIN BD10      [get_ports "VRP68"] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_68
set_property IOSTANDARD  LVCMOSxx  [get_ports "VRP68"] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_68
set_property PACKAGE_PIN BE7       [get_ports {c1_ddr4_dm_dbi_n[6]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L1P_T0L_N0_DBC_68
set_property IOSTANDARD  POD12_DCI [get_ports {c1_ddr4_dm_dbi_n[6]}] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L1P_T0L_N0_DBC_68
set_property PACKAGE_PIN BF7        [get_ports "RANK68_PIN_BF7"] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L1N_T0L_N1_DBC_68
set_property IOSTANDARD  SSTL12_DCI [get_ports "RANK68_PIN_BF7"] ;# Bank  68 VCCO - VCC1V2_FPGA - IO_L1N_T0L_N1_DBC_68
#Other net   PACKAGE_PIN BA10     - VREF68                    Bank  68 - VREF_68
#Other net   PACKAGE_PIN R22      - VREF_72                   Bank  73 - VREF_73
set_property PACKAGE_PIN AV24      [get_ports "USER_SI570_CLOCK_P"] ;# Bank  84 VCCO - VCC1V8_FPGA - IO_L14P_T2L_N2_GC_84
set_property IOSTANDARD  LVDS_25   [get_ports "USER_SI570_CLOCK_P"] ;# Bank  84 VCCO - VCC1V8_FPGA - IO_L14P_T2L_N2_GC_84
set_property PACKAGE_PIN AW24      [get_ports "USER_SI570_CLOCK_N"] ;# Bank  84 VCCO - VCC1V8_FPGA - IO_L14N_T2L_N3_GC_84
set_property IOSTANDARD  LVDS_25   [get_ports "USER_SI570_CLOCK_N"] ;# Bank  84 VCCO - VCC1V8_FPGA - IO_L14N_T2L_N3_GC_84
#Other net   PACKAGE_PIN AL23     - No Connect                Bank  84 - VREF_84
#Other net   PACKAGE_PIN AY21     - N17282565                 Bank  94 - VREF_94
#Other net   PACKAGE_PIN BE42     - MGTAVTT_FPGA              Bank 128 - MGTAVTTRCAL_LS
#Other net   PACKAGE_PIN B42      - MGTAVTT_FPGA              Bank 133 - MGTAVTTRCAL_LN
#Other net   PACKAGE_PIN BA5      - MGTAVTT_FPGA              Bank 226 - MGTAVTTRCAL_RS
#Other net   PACKAGE_PIN C7       - MGTAVTT_FPGA              Bank 231 - MGTAVTTRCAL_RN
