# TCL hook script for STEPS.WRITE_BITSTREAM.TCL.POST
# NOTE: This script cannot be sourced in Vivado TCL console because it expects its environment to be that of a TCL hook script.

proc tclpost_export_hw { } {
  # Figure out project name by deconstructing current working directory
  # e.g. [pwd] = "C:/path/to/<proj name>.runs/impl_1" => proj_name = "<proj name>"
  set current_dir [pwd]
  set run_dir [file dirname "${current_dir}"]
  set run_dirname [file tail "${run_dir}"]
  set proj_name [lindex [split "${run_dirname}" {.}] 0]

  # Can get top entity name / bitstream name from properties of current design
  set top_name [get_property TOP [current_design]]

  set vitis_ws [file normalize "${current_dir}/../../${proj_name}.vitis"]
  file mkdir "${vitis_ws}"

#  puts "------ current_project:"
#  report_prop -all [current_project]
#  puts "------ current_design:"
#  report_prop -all [current_design]
#  puts "------ current_run:"
#  report_prop -all [current_run]
#  puts "------"
#
#  FIXME: figure out how to get write_hw_platform to work in Tcl hook script
#         without going over 260 character limit
#  cd [get_property XLNX_PROJ_DIR [current_design]]
#  write_hw_platform -fixed -force -file "${vitis_ws}/${top_name}.xsa"
#  cd $current_dir
}

tclpost_export_hw
