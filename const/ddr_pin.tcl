###################################################
# adr port
###################################################
set_property PACKAGE_PIN    AM34    [get_ports "DDR4_C0_A0"] ;  
set_property PACKAGE_PIN    AW33    [get_ports "DDR4_C0_A1"] ;  
set_property PACKAGE_PIN    AL33    [get_ports "DDR4_C0_A2"] ;
set_property PACKAGE_PIN    AR33    [get_ports "DDR4_C0_A3"] ;  
set_property PACKAGE_PIN    AV33    [get_ports "DDR4_C0_A4"] ;  
set_property PACKAGE_PIN    AW34    [get_ports "DDR4_C0_A5"] ;  
set_property PACKAGE_PIN    AV34    [get_ports "DDR4_C0_A6"] ;  
set_property PACKAGE_PIN    AT34    [get_ports "DDR4_C0_A7"] ;  
set_property PACKAGE_PIN    AL32    [get_ports "DDR4_C0_A8"] ;  
set_property PACKAGE_PIN    AP33    [get_ports "DDR4_C0_A9"] ;  
set_property PACKAGE_PIN    AM32    [get_ports "DDR4_C0_A10"] ;  
set_property PACKAGE_PIN    AN33    [get_ports "DDR4_C0_A11"] ;  
set_property PACKAGE_PIN    AT33    [get_ports "DDR4_C0_A12"] ;  
set_property PACKAGE_PIN    AP34    [get_ports "DDR4_C0_A13"] ;
set_property PACKAGE_PIN    AL34    [get_ports "DDR4_C0_A14_WE_B"];  
set_property PACKAGE_PIN    AN34    [get_ports "DDR4_C0_A15_CAS_B"];  
set_property PACKAGE_PIN    AN32    [get_ports "DDR4_C0_A16_RAS_B"];

set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A0"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A1"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A2"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A3"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A4"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A5"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A6"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A7"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A8"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A9"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A10"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A11"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A12"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A13"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A14_WE_B"];
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A15_CAS_B"];
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_A16_RAS_B"];

###################################################
# act_n port
###################################################
set_property PACKAGE_PIN    BA33    [get_ports "DDR4_C0_ACT_B"];
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_ACT_B"];

###################################################
# ba port
###################################################
set_property PACKAGE_PIN    AY35    [get_ports "DDR4_C0_BA0"] ;
set_property PACKAGE_PIN    AY36    [get_ports "DDR4_C0_BA1"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_BA0"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_BA1"] ;

###################################################
# bg port
###################################################
set_property PACKAGE_PIN    AY33    [get_ports "DDR4_C0_BG0"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_BG0"] ;

###################################################
# ck port
###################################################
set_property PACKAGE_PIN    AW36        [get_ports "DDR4_C0_CK_C"] ;
set_property PACKAGE_PIN    AW35        [get_ports "DDR4_C0_CK_T"] ;
set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports "DDR4_C0_CK_C"] ;
set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports "DDR4_C0_CK_T"] ;

###################################################
# cke port
###################################################
set_property PACKAGE_PIN    BF35    [get_ports "DDR4_C0_CKE"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_CKE"] ;

###################################################
# odt port
###################################################
set_property PACKAGE_PIN    BD34    [get_ports "DDR4_C0_ODT"] ;
set_property IOSTANDARD SSTL12_DCI  [get_ports "DDR4_C0_ODT"] ;

###################################################
# reset_n port
###################################################
set_property PACKAGE_PIN    AJ34    [get_ports "DDR4_C0_RESET_C"] ;
set_property IOSTANDARD LVCMOS12    [get_ports "DDR4_C0_RESET_C"] ;

###################################################
# dm_dbi_n port
###################################################

set_property PACKAGE_PIN    BF32    [get_ports "DDR4_C0_DM0"] ;
set_property PACKAGE_PIN    BC31    [get_ports "DDR4_C0_DM1"] ;
set_property PACKAGE_PIN    AW29    [get_ports "DDR4_C0_DM2"] ;
set_property PACKAGE_PIN    AP31    [get_ports "DDR4_C0_DM3"] ;
set_property PACKAGE_PIN    AJ27    [get_ports "DDR4_C0_DM4"] ;
set_property PACKAGE_PIN    AH34    [get_ports "DDR4_C0_DM5"] ;
set_property PACKAGE_PIN    AE31    [get_ports "DDR4_C0_DM6"] ;
set_property PACKAGE_PIN    AA32    [get_ports "DDR4_C0_DM7"] ;
set_property PACKAGE_PIN    BC34    [get_ports "DDR4_C0_DM8"] ;

set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DM0"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DM1"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DM2"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DM3"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DM4"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DM5"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DM6"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DM7"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DM8"] ;

###################################################
# dq port
###################################################

set_property PACKAGE_PIN    BE32    [get_ports "DDR4_C0_DQ0"] ;
set_property PACKAGE_PIN    BF30    [get_ports "DDR4_C0_DQ1"] ;
set_property PACKAGE_PIN    BE31    [get_ports "DDR4_C0_DQ2"] ;
set_property PACKAGE_PIN    BE33    [get_ports "DDR4_C0_DQ3"] ;
set_property PACKAGE_PIN    BD29    [get_ports "DDR4_C0_DQ4"] ;
set_property PACKAGE_PIN    BD33    [get_ports "DDR4_C0_DQ5"] ;
set_property PACKAGE_PIN    BE30    [get_ports "DDR4_C0_DQ6"] ;
set_property PACKAGE_PIN    BC29    [get_ports "DDR4_C0_DQ7"] ;
set_property PACKAGE_PIN    BB29    [get_ports "DDR4_C0_DQ8"] ;
set_property PACKAGE_PIN    AY32    [get_ports "DDR4_C0_DQ9"] ;
set_property PACKAGE_PIN    BA29    [get_ports "DDR4_C0_DQ10"] ;
set_property PACKAGE_PIN    AY30    [get_ports "DDR4_C0_DQ11"] ;
set_property PACKAGE_PIN    BA30    [get_ports "DDR4_C0_DQ12"] ;
set_property PACKAGE_PIN    BB31    [get_ports "DDR4_C0_DQ13"] ;
set_property PACKAGE_PIN    AY31    [get_ports "DDR4_C0_DQ14"] ;
set_property PACKAGE_PIN    BB30    [get_ports "DDR4_C0_DQ15"] ;
set_property PACKAGE_PIN    AU30    [get_ports "DDR4_C0_DQ16"] ;
set_property PACKAGE_PIN    AT30    [get_ports "DDR4_C0_DQ17"] ;
set_property PACKAGE_PIN    AV31    [get_ports "DDR4_C0_DQ18"] ;
set_property PACKAGE_PIN    AU32    [get_ports "DDR4_C0_DQ19"] ;
set_property PACKAGE_PIN    AT29    [get_ports "DDR4_C0_DQ20"] ;
set_property PACKAGE_PIN    AU31    [get_ports "DDR4_C0_DQ21"] ;
set_property PACKAGE_PIN    AW31    [get_ports "DDR4_C0_DQ22"] ;
set_property PACKAGE_PIN    AV32    [get_ports "DDR4_C0_DQ23"] ;
set_property PACKAGE_PIN    AN29    [get_ports "DDR4_C0_DQ24"] ;
set_property PACKAGE_PIN    AR30    [get_ports "DDR4_C0_DQ25"] ;
set_property PACKAGE_PIN    AP29    [get_ports "DDR4_C0_DQ26"] ;
set_property PACKAGE_PIN    AP30    [get_ports "DDR4_C0_DQ27"] ;
set_property PACKAGE_PIN    AN31    [get_ports "DDR4_C0_DQ28"] ;
set_property PACKAGE_PIN    AL29    [get_ports "DDR4_C0_DQ29"] ;
set_property PACKAGE_PIN    AM31    [get_ports "DDR4_C0_DQ30"] ;
set_property PACKAGE_PIN    AL30    [get_ports "DDR4_C0_DQ31"] ;
set_property PACKAGE_PIN    AK28    [get_ports "DDR4_C0_DQ32"] ;
set_property PACKAGE_PIN    AJ31    [get_ports "DDR4_C0_DQ33"] ;
set_property PACKAGE_PIN    AJ29    [get_ports "DDR4_C0_DQ34"] ;
set_property PACKAGE_PIN    AG30    [get_ports "DDR4_C0_DQ35"] ;
set_property PACKAGE_PIN    AJ28    [get_ports "DDR4_C0_DQ36"] ;
set_property PACKAGE_PIN    AG29    [get_ports "DDR4_C0_DQ37"] ;
set_property PACKAGE_PIN    AK31    [get_ports "DDR4_C0_DQ38"] ;
set_property PACKAGE_PIN    AJ30    [get_ports "DDR4_C0_DQ39"] ;
set_property PACKAGE_PIN    AH33    [get_ports "DDR4_C0_DQ40"] ;
set_property PACKAGE_PIN    AJ33    [get_ports "DDR4_C0_DQ41"] ;
set_property PACKAGE_PIN    AF33    [get_ports "DDR4_C0_DQ42"] ;
set_property PACKAGE_PIN    AG34    [get_ports "DDR4_C0_DQ43"] ;
set_property PACKAGE_PIN    AG31    [get_ports "DDR4_C0_DQ44"] ;
set_property PACKAGE_PIN    AG32    [get_ports "DDR4_C0_DQ45"] ;
set_property PACKAGE_PIN    AF34    [get_ports "DDR4_C0_DQ46"] ;
set_property PACKAGE_PIN    AF32    [get_ports "DDR4_C0_DQ47"] ;
set_property PACKAGE_PIN    AC32    [get_ports "DDR4_C0_DQ48"] ;
set_property PACKAGE_PIN    AF30    [get_ports "DDR4_C0_DQ49"] ;
set_property PACKAGE_PIN    AD34    [get_ports "DDR4_C0_DQ50"] ;
set_property PACKAGE_PIN    AC34    [get_ports "DDR4_C0_DQ51"] ;
set_property PACKAGE_PIN    AC33    [get_ports "DDR4_C0_DQ52"] ;
set_property PACKAGE_PIN    AE30    [get_ports "DDR4_C0_DQ53"] ;
set_property PACKAGE_PIN    AD33    [get_ports "DDR4_C0_DQ54"] ;
set_property PACKAGE_PIN    AE33    [get_ports "DDR4_C0_DQ55"] ;
set_property PACKAGE_PIN    W33     [get_ports "DDR4_C0_DQ56"] ;
set_property PACKAGE_PIN    Y32     [get_ports "DDR4_C0_DQ57"] ;
set_property PACKAGE_PIN    Y33     [get_ports "DDR4_C0_DQ58"] ;
set_property PACKAGE_PIN    AA34    [get_ports "DDR4_C0_DQ59"] ;
set_property PACKAGE_PIN    W30     [get_ports "DDR4_C0_DQ60"] ;
set_property PACKAGE_PIN    Y30     [get_ports "DDR4_C0_DQ61"] ;
set_property PACKAGE_PIN    AB34    [get_ports "DDR4_C0_DQ62"] ;
set_property PACKAGE_PIN    W34     [get_ports "DDR4_C0_DQ63"] ;
set_property PACKAGE_PIN    BA35    [get_ports "DDR4_C0_DQ64"] ;
set_property PACKAGE_PIN    BB35    [get_ports "DDR4_C0_DQ65"] ;
set_property PACKAGE_PIN    BB36    [get_ports "DDR4_C0_DQ66"] ;
set_property PACKAGE_PIN    BC36    [get_ports "DDR4_C0_DQ67"] ;
set_property PACKAGE_PIN    BD36    [get_ports "DDR4_C0_DQ68"] ;
set_property PACKAGE_PIN    BE36    [get_ports "DDR4_C0_DQ69"] ;
set_property PACKAGE_PIN    BD35    [get_ports "DDR4_C0_DQ70"] ;
set_property PACKAGE_PIN    BE35    [get_ports "DDR4_C0_DQ71"] ;

set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ0"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ1"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ2"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ3"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ4"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ5"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ6"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ7"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ8"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ9"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ10"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ11"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ12"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ13"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ14"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ15"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ16"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ17"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ18"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ19"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ20"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ21"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ22"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ23"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ24"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ25"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ26"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ27"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ28"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ29"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ30"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ31"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ32"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ33"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ34"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ35"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ36"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ37"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ38"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ39"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ40"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ41"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ42"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ43"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ44"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ45"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ46"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ47"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ48"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ49"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ50"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ51"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ52"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ53"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ54"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ55"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ56"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ57"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ58"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ59"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ60"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ61"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ62"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ63"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ64"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ65"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ66"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ67"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ68"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ69"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ70"] ;
set_property IOSTANDARD POD12_DCI   [get_ports "DDR4_C0_DQ71"] ;

###################################################
# dqs port
###################################################
set_property PACKAGE_PIN    BD31    [get_ports "DDR4_C0_DQS0_C"] ;
set_property PACKAGE_PIN    BD30    [get_ports "DDR4_C0_DQS0_T"] ;
set_property PACKAGE_PIN    BB32    [get_ports "DDR4_C0_DQS1_C"] ;
set_property PACKAGE_PIN    BA32    [get_ports "DDR4_C0_DQS1_T"] ;
set_property PACKAGE_PIN    AV29    [get_ports "DDR4_C0_DQS2_C"] ;
set_property PACKAGE_PIN    AU29    [get_ports "DDR4_C0_DQS2_T"] ;
set_property PACKAGE_PIN    AM30    [get_ports "DDR4_C0_DQS3_C"] ;
set_property PACKAGE_PIN    AM29    [get_ports "DDR4_C0_DQS3_T"] ;
set_property PACKAGE_PIN    AH29    [get_ports "DDR4_C0_DQS4_C"] ;
set_property PACKAGE_PIN    AH28    [get_ports "DDR4_C0_DQS4_T"] ;
set_property PACKAGE_PIN    AH32    [get_ports "DDR4_C0_DQS5_C"] ;
set_property PACKAGE_PIN    AH31    [get_ports "DDR4_C0_DQS5_T"] ;
set_property PACKAGE_PIN    AD31    [get_ports "DDR4_C0_DQS6_C"] ;
set_property PACKAGE_PIN    AC31    [get_ports "DDR4_C0_DQS6_T"] ;
set_property PACKAGE_PIN    Y31     [get_ports "DDR4_C0_DQS7_C"] ;
set_property PACKAGE_PIN    W31     [get_ports "DDR4_C0_DQS7_T"] ;
set_property PACKAGE_PIN    BC37    [get_ports "DDR4_C0_DQS8_C"] ;
set_property PACKAGE_PIN    BB37    [get_ports "DDR4_C0_DQS8_T"] ;

set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS0_C"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS0_T"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS1_C"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS1_T"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS2_C"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS2_T"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS3_C"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS3_T"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS4_C"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS4_T"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS5_C"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS5_T"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS6_C"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS6_T"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS7_C"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS7_T"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS8_C"] ;
set_property IOSTANDARD DIFF_POD12  [get_ports "DDR4_C0_DQS8_T"] ;


###################################################
# unknown
###################################################

set_property PACKAGE_PIN AU34 [get_ports "DDR4_C0_ALERT_B"] ;
set_property IOSTANDARD SSTL12_DCI [get_ports "DDR4_C0_ALERT_B"] ;

set_property PACKAGE_PIN BC38 [get_ports "DDR4_C0_CS_BOT_B"] ;
set_property IOSTANDARD SSTL12_DCI [get_ports "DDR4_C0_CS_BOT_B"] ;

set_property PACKAGE_PIN BB38 [get_ports "DDR4_C0_CS_TOP_B"] ;
set_property IOSTANDARD SSTL12_DCI [get_ports "DDR4_C0_CS_TOP_B"] ;