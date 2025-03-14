# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a100tfgg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.cache/wt [current_project]
set_property parent.project_path C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths c:/Users/ainse/Desktop/CPU_project/refer_proj2.2.ip_user_files/SEU_CSE_507_user_uart_bmpg_1.3 [current_project]
set_property ip_output_repo c:/Users/ainse/Desktop/CPU_project/refer_proj2.2.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files C:/Users/ainse/Desktop/CPU_project/coe/dmem32.coe
add_files C:/Users/ainse/Desktop/CPU_project/coe/prgmip32.coe
add_files {{C:/Users/ainse/Desktop/dmem32 .coe}}
add_files {{C:/Users/ainse/Desktop/prgmip32 .coe}}
add_files C:/Users/ainse/Desktop/asm_test/2/dmem32.coe
add_files C:/Users/ainse/Desktop/asm_test/2/prgmip32.coe
read_verilog -library xil_defaultlib {
  C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/new/Ifetch.v
  C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/new/LED.v
  C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/new/MemOrIO.v
  C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/new/control32.v
  C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/new/debounce.v
  C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/new/decode32.v
  C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/new/divclk.v
  C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/new/dmemory32.v
  C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/new/executs32.v
  C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/new/programrom.v
  C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/new/cpu.v
}
read_ip -quiet C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/ip/programrom/programrom.xci
set_property used_in_implementation false [get_files -all c:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/ip/programrom/programrom_ooc.xdc]

read_ip -quiet C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/ip/cpuclk/cpuclk.xci
set_property used_in_implementation false [get_files -all c:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/ip/cpuclk/cpuclk_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/ip/cpuclk/cpuclk.xdc]
set_property used_in_implementation false [get_files -all c:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/ip/cpuclk/cpuclk_ooc.xdc]

read_ip -quiet C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/ip/prgrom/prgrom.xci
set_property used_in_implementation false [get_files -all c:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/ip/prgrom/prgrom_ooc.xdc]

read_ip -quiet C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/ip/RAM_1/RAM.xci
set_property used_in_implementation false [get_files -all c:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/sources_1/ip/RAM_1/RAM_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/constrs_1/new/cpu_xdc.xdc
set_property used_in_implementation false [get_files C:/Users/ainse/Desktop/CPU_project/refer_proj2.2.srcs/constrs_1/new/cpu_xdc.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top cpu -part xc7a100tfgg484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef cpu.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file cpu_utilization_synth.rpt -pb cpu_utilization_synth.pb"
