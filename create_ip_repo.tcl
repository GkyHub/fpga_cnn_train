# create ip project
create_project managed_ip_project ./ip/managed_ip_project -part $CHIP -ip
set IP_PRJ [current_project]

set_property board_part $BOARD $IP_PRJ
set_property target_simulator XSim $IP_PRJ

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

close_project