# project property
# FPGA chip
set     CHIP    xcku115-flvb2104-2-e
# development board
set     BOARD   xilinx.com:kcu1500:part0:1.1

# create project
create_project project_1 ./vivado_prj -part $CHIP
set_property board_part $BOARD [current_project]

# add source files
add_files -fileset sources_1 ./src
update_compile_order -fileset sources_1

# add simulation files
add_files -fileset sim_1 ./sim
update_compile_order -fileset sim_1

# add ip
# source ./add_ip.tcl
