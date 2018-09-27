# project property
# FPGA chip
set     CHIP    xcku115-flvb2104-2-e
# development board
set     BOARD   xilinx.com:kcu1500:part0:1.1
# top module name
set     SRC_TOP fpga_cnn_train_top
set     SIM_TOP sim_tb_top

# create project
create_project project_1 ./vivado_prj -part $CHIP
set     VIVADO_PRJ [current_project]

set_property board_part $BOARD $VIVADO_PRJ

# add source files
add_files -fileset sources_1 ./src
add_files -fileset sources_1 ./imports
# set_property top $SRC_TOP $VIVADO_PRJ
update_compile_order -fileset sources_1
# add ip files
set IP_LIST [glob -type d ./ip/*]
foreach IP_FOLDER $IP_LIST {
    # ignore project folder
    if {1 == [string match *managed_ip_project $IP_FOLDER]} {
        continue
    }
    # ignore ip_user_files folder
    if {1 == [string match *ip_user_files $IP_FOLDER]} {
        continue
    }
    # add the xci files
    set IP_NAME [string range $IP_FOLDER 5 end]
    set IP_XCI  $IP_FOLDER
    append IP_XCI "/" $IP_NAME ".xci"    
    add_files -norecurse $IP_XCI
}
update_compile_order -fileset sources_1

# add simulation files
add_files -fileset sim_1 ./sim
# set_property top $SIM_TOP $VIVADO_PRJ
update_compile_order -fileset sim_1

# add constraint files
add_files -fileset constrs_1 ./xdc

# add ip
# source ./add_ip.tcl
source ./create_ip_repo.tcl
