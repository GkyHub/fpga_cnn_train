set IP_NAME fp32_add
set LOCAL_IP_DIR $IP_DIR/$IP_NAME

# the following 2 commands should be replaced by vivado when a new ip is used for the first time
# change the module_name in the first command and the component_name in the second command to $IP_NAME
create_ip -name floating_point -vendor xilinx.com -library ip -version 7.1 -module_name $IP_NAME
set_property -dict [list CONFIG.Component_Name {$IP_NAME}] [get_ips $IP_NAME]

# do not change the following commands
generate_target {instantiation_template} [get_files $LOCAL_IP_DIR/$IP_NAME.xci]
update_compile_order -fileset sources_1
generate_target all [get_files $LOCAL_IP_DIR/$IP_NAME.xci]
catch { config_ip_cache -export [get_ips -all $IP_NAME] }
export_ip_user_files -of_objects [get_files $LOCAL_IP_DIR/$IP_NAME.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $LOCAL_IP_DIR/$IP_NAME.xci]

set SYNTH_NAME [format "%s_synth_1" $IP_NAME]
launch_runs -jobs 4 $SYNTH_NAME

export_simulation -of_objects [get_files $LOCAL_IP_DIR/$IP_NAME.xci] \
    -directory $IP_USER_FILES_DIR/sim_scripts \
    -ip_user_files_dir $IP_USER_FILES_DIR \
    -ipstatic_source_dir $IP_USER_FILES_DIR/ipstatic \
    -lib_map_path [list \
        {modelsim=$SIM_LIB_DIR/modelsim} \
        {questa=$SIM_LIB_DIR/questa} \
        {ies=$SIM_LIB_DIR/ies} \
        {vcs=$SIM_LIB_DIR/vcs} \
        {riviera=$SIM_LIB_DIR/riviera}] \
    -use_ip_compiled_libs -force -quiet
