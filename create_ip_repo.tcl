create_project managed_ip_project ./ip/managed_ip_project -part $CHIP -ip
set_property board_part $BOARD [current_project]
set_property target_simulator XSim [current_project]