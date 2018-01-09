# name of the testbench
open_project ./vivado_prj/project_1.xpr
set top_module test_top

# run simulation
set_property top $top_module [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1
launch_simulation