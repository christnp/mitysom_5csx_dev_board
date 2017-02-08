set_global_assignment -entity "cv_video_pll" -library "lib_cv_video_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "cv_video_pll" -library "lib_cv_video_pll" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "cv_video_pll" -library "lib_cv_video_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_cv_video_pll" -name SPD_FILE [file join $::quartus(sip_path) "cv_video_pll.spd"]

set_global_assignment -library "lib_cv_video_pll" -name MISC_FILE [file join $::quartus(sip_path) "cv_video_pll_sim/cv_video_pll.vo"]
