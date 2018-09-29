ipx::package_project -root_dir /home/kaiyuan/workspace/vivado/fpga_cnn_train_core -vendor user.org -library user -taxonomy /UserIP
set_property core_revision 2 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  /home/kaiyuan/workspace/vivado/fpga_cnn_train_core [current_project]
update_ip_catalog