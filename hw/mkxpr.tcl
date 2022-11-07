proc make_project { } {
  global env
  # Get the directory containing this script. Source file paths are relative to this.
  set origin_dir [file dirname [file normalize [info script]]]

  # Set the number of cores here (must have a corresponding mkbd file
  set num_cores 8

  # Define versions of dependencies in one convenient place
  source "$origin_dir/version.tcl"

  set viv_ver [version -short]
  set viv_patch [lindex [split $viv_ver {_}] 1]
  set viv_spl [split [lindex [split $viv_ver {_}] 0] .]
  set viv_maj [lindex $viv_spl 0]
  set viv_min [lindex $viv_spl 1]

  if { $viv_maj < 2021 || ($viv_maj == 2021 && $viv_min < 1) } {
    send_msg_id {AD-MKXPR-001} {ERROR} "Vivado ${viv_ver} is not supported for this FPGA design. Minimum Vivado version is 2021.1."
  }

  if { [info exists ::env(ADM_HWREPO_PATH)] } {
    set hw_repo_path env(ADM_HWREPO_PATH)
  } else {
    send_msg_id {AD-MKXPR-001} {ERROR} "You must set the AlphaData hardware repository, ADM_HWREPO_PATH environment variable"
  }

  if { [info exists ::env(NERORV32_PATH)] } {
    set neorv32_repo_path env(NERORV32_PATH)
  } else {
    send_msg_id {AD-MKXPR-001} {ERROR} "You must set the NEORV32 root path, NERORV32_PATH environment variable"
  }

  # Create project
  set part {xcvm1802-vsva2197-2MP-e-S}
  set name {minotaur}
  set project [create_project -force -part $part $name "$origin_dir/$name"]
  current_project $project

  # Get the directory path for the new project
  set proj_dir [get_property {directory} $project]

  # Set project properties
  set_property {default_lib} {xil_defaultlib} $project
  set_property {part} $part $project
  set_property {simulator_language} {Mixed} $project
  set_property {target_language} {Verilog} $project
  set_property "ip_repo_paths" $env(ADM_HWREPO_PATH) $project
  update_ip_catalog

  # Create 'sources_1' fileset (if not found)
  set source_set [get_filesets sources_1]

  # Add CPU source files
  add_files [ glob $env(NERORV32_PATH)/rtl/core/*.vhd ]
  add_files [ glob $env(NERORV32_PATH)/rtl/core/mem/*.vhd ]
  add_files $env(NERORV32_PATH)/rtl/system_integration/neorv32_SystemTop_axi4lite.vhd

  set_property library neorv32 [ get_files [ glob $env(NERORV32_PATH)/rtl/core/*.vhd ]]
  set_property library neorv32 [ get_files [ glob $env(NERORV32_PATH)/rtl/core/mem/*.vhd ]]
  set_property library neorv32 [ get_files [ glob $env(NERORV32_PATH)/rtl/system_integration/neorv32_SystemTop_axi4lite.vhd ]]

  # This is a bit clunky, but replace the generic configuration file with our modified one
  remove_files $env(NERORV32_PATH)/rtl/core/neorv32_package.vhd
  add_files $origin_dir/src/neorv32_package.vhd
  set_property library neorv32 [ get_files $origin_dir/src/neorv32_package.vhd]

  # Create the Block Diagram design
  set bd [source "$origin_dir/mkbd-$num_cores.tcl"]
  # Make an HDL wrapper for it (let Vivado manage it => use add_files instead of import_files)
  make_wrapper -files [ get_files "$origin_dir/minotaur/minotaur.srcs/sources_1/bd/minotaur/minotaur.bd" ] -top
  add_files -norecurse -fileset $source_set "$origin_dir/minotaur/minotaur.gen/sources_1/bd/minotaur/hdl/minotaur_wrapper.v"

  update_compile_order -fileset $source_set

  # Create 'constrs_1' fileset (if not found)
  set constraint_set [get_filesets constrs_1]
  # Add constraints files
  # Put target .xdc as FIRST in list
  set constraint_files [list \
    [file normalize "$origin_dir/src/avr.xdc"] \
    [file normalize "$origin_dir/src/bitstream.xdc"] \
    [file normalize "$origin_dir/src/ddr4sdram_locs_b0_x72.xdc"] \
    [file normalize "$origin_dir/src/ddr4sdram_locs_b1_x72.xdc"] \
  ]
  add_files -norecurse -fileset $constraint_set $constraint_files
  set_property {target_constrs_file} [lindex $constraint_files 0] $constraint_set
  
  # Add utilities files (Tcl hook scripts etc.)
  set utils_set [get_filesets -quiet utils_1]
  if {[string equal $utils_set ""]} {
    # Utilities fileset introduced in Vivado 2018.3; fall back to using sources set if not present.
    set utils_set $source_set
  }
  set utils_files [list \
    [file normalize "$origin_dir/tclpost_export_hw.tcl"] \
  ]
  add_files -norecurse -fileset $utils_set $utils_files
  # Set used_in_XXX properties so that Vivado 2018.2 and earlier doesn't treat them as design sources.
  set_property -dict {
    {used_in_synthesis} {false} \
    {used_in_implementation} {false} \
    {used_in_simulation} {false} \
  } [get_files $utils_files]

  # Configure 'impl_1' run
  set impl_run [get_runs impl_1]
  set_property {steps.write_device_image.tcl.post} [get_files "tclpost_export_hw.tcl"] $impl_run

  return $project
}

return [make_project]
