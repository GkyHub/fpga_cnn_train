set IP_SRC_PATH         ./ip
set IP_DIR              ./vivado_prj/project_1.srcs/sources_1/ip
set IP_USER_FILES_DIR   ./vivado_prj/project_1.ip_user_files
set SIM_LIB_DIR         ./vivado_prj/project_1.cache/compile_simlib

set IP_LIST [glob ./ip/*.tcl]
foreach IP_TCL $IP_LIST {
    source $IP_TCL
}