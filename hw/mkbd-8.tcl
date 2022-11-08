
################################################################
# This is a generated script based on design: minotaur
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source minotaur_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# neorv32_SystemTop_axi4lite, neorv32_SystemTop_axi4lite, neorv32_SystemTop_axi4lite, neorv32_SystemTop_axi4lite, neorv32_SystemTop_axi4lite, neorv32_SystemTop_axi4lite, neorv32_SystemTop_axi4lite, neorv32_SystemTop_axi4lite

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvm1802-vsva2197-2MP-e-S
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name minotaur

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:versal_cips:3.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:emb_mem_gen:1.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlslice:1.0\
alpha-data.com:user:bci_versal:1.1\
xilinx.com:ip:xpm_cdc_gen:1.0\
xilinx.com:ip:axi_uartlite:2.0\
alpha-data.com:user:axi4_address_mangler:1.0\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
neorv32_SystemTop_axi4lite\
neorv32_SystemTop_axi4lite\
neorv32_SystemTop_axi4lite\
neorv32_SystemTop_axi4lite\
neorv32_SystemTop_axi4lite\
neorv32_SystemTop_axi4lite\
neorv32_SystemTop_axi4lite\
neorv32_SystemTop_axi4lite\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: cpu_7
proc create_hier_cell_cpu_7 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_cpu_7() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CONFIG_ROM_M03_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CTRL_S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DATA_DRAM_M00_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 INSTR_DRAM_M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 SHARED_URAM_M02_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 CPU_reset
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst interconnect_aresetn

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {9600} \
   CONFIG.C_ODD_PARITY {0} \
   CONFIG.C_USE_PARITY {0} \
   CONFIG.PARITY {No_Parity} \
 ] $axi_uartlite_0

  # Create instance: data_address_mangler, and set properties
  set data_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 data_address_mangler ]
  set_property -dict [ list \
   CONFIG.field00_used_bits {0x000000007FFFFFFF} \
   CONFIG.inject {0x0000050100000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $data_address_mangler

  # Create instance: gpio_gpio, and set properties
  set gpio_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {1} \
 ] $gpio_gpio

  # Create instance: instr_address_mangler, and set properties
  set instr_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 instr_address_mangler ]
  set_property -dict [ list \
   CONFIG.inject {0x0000050000000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $instr_address_mangler

  # Create instance: interrupt_gpio, and set properties
  set interrupt_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 interrupt_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {0} \
 ] $interrupt_gpio

  # Create instance: neorv32_SystemTop_ax_0, and set properties
  set block_name neorv32_SystemTop_axi4lite
  set block_cell_name neorv32_SystemTop_ax_0
  if { [catch {set neorv32_SystemTop_ax_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $neorv32_SystemTop_ax_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CLOCK_FREQUENCY {100000000} \
   CONFIG.CPU_EXTENSION_RISCV_B {true} \
   CONFIG.CPU_EXTENSION_RISCV_C {true} \
   CONFIG.CPU_EXTENSION_RISCV_M {true} \
   CONFIG.CPU_EXTENSION_RISCV_Zfinx {true} \
   CONFIG.FAST_MUL_EN {true} \
   CONFIG.FAST_SHIFT_EN {true} \
   CONFIG.HW_THREAD_ID {7} \
   CONFIG.ICACHE_ASSOCIATIVITY {2} \
   CONFIG.ICACHE_EN {true} \
   CONFIG.ICACHE_NUM_BLOCKS {8} \
   CONFIG.INT_BOOTLOADER_EN {false} \
   CONFIG.IO_NEOLED_EN {false} \
   CONFIG.IO_SPI_EN {false} \
   CONFIG.IO_TWI_EN {false} \
   CONFIG.IO_UART0_RX_FIFO {1} \
   CONFIG.IO_UART0_TX_FIFO {1} \
   CONFIG.IO_UART1_EN {false} \
   CONFIG.MEM_INT_DMEM_EN {false} \
   CONFIG.MEM_INT_IMEM_EN {false} \
   CONFIG.PMP_NUM_REGIONS {0} \
   CONFIG.XIRQ_NUM_CH {32} \
 ] $neorv32_SystemTop_ax_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_1

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {32} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net CTRL_S_AXI_1 [get_bd_intf_pins CTRL_S_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins INSTR_DRAM_M00_AXI] [get_bd_intf_pins instr_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi4_address_mangler_1_M_AXI [get_bd_intf_pins DATA_DRAM_M00_AXI1] [get_bd_intf_pins data_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net neorv32_SystemTop_ax_0_m_axi [get_bd_intf_pins neorv32_SystemTop_ax_0/m_axi] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins instr_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins data_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M01_AXI [get_bd_intf_pins gpio_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M02_AXI [get_bd_intf_pins interrupt_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M02_AXI]

  # Create port connections
  connect_bd_net -net Op2_1 [get_bd_pins CPU_reset] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins data_address_mangler/aclk] [get_bd_pins gpio_gpio/s_axi_aclk] [get_bd_pins instr_address_mangler/aclk] [get_bd_pins interrupt_gpio/s_axi_aclk] [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins data_address_mangler/aresetn] [get_bd_pins gpio_gpio/s_axi_aresetn] [get_bd_pins instr_address_mangler/aresetn] [get_bd_pins interrupt_gpio/s_axi_aresetn] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net axi_gpio_1_gpio2_io_o [get_bd_pins gpio_gpio/gpio2_io_o] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins interrupt_gpio/gpio_io_o] [get_bd_pins neorv32_SystemTop_ax_0/xirq_i]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_pins axi_uartlite_0/tx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_rxd_i]
  connect_bd_net -net neorv32_SystemTop_ax_0_gpio_o [get_bd_pins neorv32_SystemTop_ax_0/gpio_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net neorv32_SystemTop_ax_0_uart0_txd_o [get_bd_pins axi_uartlite_0/rx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_txd_o]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aresetn] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins neorv32_SystemTop_ax_0/gpio_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins neorv32_SystemTop_ax_0/cfs_in_i] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins gpio_gpio/gpio_io_i] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cpu_6
proc create_hier_cell_cpu_6 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_cpu_6() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CONFIG_ROM_M03_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CTRL_S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DATA_DRAM_M00_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 INSTR_DRAM_M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 SHARED_URAM_M02_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 CPU_reset
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst interconnect_aresetn

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {9600} \
   CONFIG.C_ODD_PARITY {0} \
   CONFIG.C_USE_PARITY {0} \
   CONFIG.PARITY {No_Parity} \
 ] $axi_uartlite_0

  # Create instance: data_address_mangler, and set properties
  set data_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 data_address_mangler ]
  set_property -dict [ list \
   CONFIG.field00_used_bits {0x000000007FFFFFFF} \
   CONFIG.inject {0x00000500E0000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $data_address_mangler

  # Create instance: gpio_gpio, and set properties
  set gpio_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {1} \
 ] $gpio_gpio

  # Create instance: instr_address_mangler, and set properties
  set instr_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 instr_address_mangler ]
  set_property -dict [ list \
   CONFIG.inject {0x0000050000000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $instr_address_mangler

  # Create instance: interrupt_gpio, and set properties
  set interrupt_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 interrupt_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {0} \
 ] $interrupt_gpio

  # Create instance: neorv32_SystemTop_ax_0, and set properties
  set block_name neorv32_SystemTop_axi4lite
  set block_cell_name neorv32_SystemTop_ax_0
  if { [catch {set neorv32_SystemTop_ax_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $neorv32_SystemTop_ax_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CLOCK_FREQUENCY {100000000} \
   CONFIG.CPU_EXTENSION_RISCV_B {true} \
   CONFIG.CPU_EXTENSION_RISCV_C {true} \
   CONFIG.CPU_EXTENSION_RISCV_M {true} \
   CONFIG.CPU_EXTENSION_RISCV_Zfinx {true} \
   CONFIG.FAST_MUL_EN {true} \
   CONFIG.FAST_SHIFT_EN {true} \
   CONFIG.HW_THREAD_ID {6} \
   CONFIG.ICACHE_ASSOCIATIVITY {2} \
   CONFIG.ICACHE_EN {true} \
   CONFIG.ICACHE_NUM_BLOCKS {8} \
   CONFIG.INT_BOOTLOADER_EN {false} \
   CONFIG.IO_NEOLED_EN {false} \
   CONFIG.IO_SPI_EN {false} \
   CONFIG.IO_TWI_EN {false} \
   CONFIG.IO_UART0_RX_FIFO {1} \
   CONFIG.IO_UART0_TX_FIFO {1} \
   CONFIG.IO_UART1_EN {false} \
   CONFIG.MEM_INT_DMEM_EN {false} \
   CONFIG.MEM_INT_IMEM_EN {false} \
   CONFIG.PMP_NUM_REGIONS {0} \
   CONFIG.XIRQ_NUM_CH {32} \
 ] $neorv32_SystemTop_ax_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_1

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {32} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net CTRL_S_AXI_1 [get_bd_intf_pins CTRL_S_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins INSTR_DRAM_M00_AXI] [get_bd_intf_pins instr_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi4_address_mangler_1_M_AXI [get_bd_intf_pins DATA_DRAM_M00_AXI1] [get_bd_intf_pins data_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net neorv32_SystemTop_ax_0_m_axi [get_bd_intf_pins neorv32_SystemTop_ax_0/m_axi] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins instr_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins data_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M01_AXI [get_bd_intf_pins gpio_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M02_AXI [get_bd_intf_pins interrupt_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M02_AXI]

  # Create port connections
  connect_bd_net -net Op2_1 [get_bd_pins CPU_reset] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins data_address_mangler/aclk] [get_bd_pins gpio_gpio/s_axi_aclk] [get_bd_pins instr_address_mangler/aclk] [get_bd_pins interrupt_gpio/s_axi_aclk] [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins data_address_mangler/aresetn] [get_bd_pins gpio_gpio/s_axi_aresetn] [get_bd_pins instr_address_mangler/aresetn] [get_bd_pins interrupt_gpio/s_axi_aresetn] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net axi_gpio_1_gpio2_io_o [get_bd_pins gpio_gpio/gpio2_io_o] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins interrupt_gpio/gpio_io_o] [get_bd_pins neorv32_SystemTop_ax_0/xirq_i]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_pins axi_uartlite_0/tx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_rxd_i]
  connect_bd_net -net neorv32_SystemTop_ax_0_gpio_o [get_bd_pins neorv32_SystemTop_ax_0/gpio_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net neorv32_SystemTop_ax_0_uart0_txd_o [get_bd_pins axi_uartlite_0/rx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_txd_o]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aresetn] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins neorv32_SystemTop_ax_0/gpio_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins neorv32_SystemTop_ax_0/cfs_in_i] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins gpio_gpio/gpio_io_i] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cpu_5
proc create_hier_cell_cpu_5 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_cpu_5() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CONFIG_ROM_M03_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CTRL_S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DATA_DRAM_M00_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 INSTR_DRAM_M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 SHARED_URAM_M02_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 CPU_reset
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst interconnect_aresetn

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {9600} \
   CONFIG.C_ODD_PARITY {0} \
   CONFIG.C_USE_PARITY {0} \
   CONFIG.PARITY {No_Parity} \
 ] $axi_uartlite_0

  # Create instance: data_address_mangler, and set properties
  set data_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 data_address_mangler ]
  set_property -dict [ list \
   CONFIG.field00_used_bits {0x000000007FFFFFFF} \
   CONFIG.inject {0x00000500C0000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $data_address_mangler

  # Create instance: gpio_gpio, and set properties
  set gpio_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {1} \
 ] $gpio_gpio

  # Create instance: instr_address_mangler, and set properties
  set instr_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 instr_address_mangler ]
  set_property -dict [ list \
   CONFIG.inject {0x0000050000000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $instr_address_mangler

  # Create instance: interrupt_gpio, and set properties
  set interrupt_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 interrupt_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {0} \
 ] $interrupt_gpio

  # Create instance: neorv32_SystemTop_ax_0, and set properties
  set block_name neorv32_SystemTop_axi4lite
  set block_cell_name neorv32_SystemTop_ax_0
  if { [catch {set neorv32_SystemTop_ax_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $neorv32_SystemTop_ax_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CLOCK_FREQUENCY {100000000} \
   CONFIG.CPU_EXTENSION_RISCV_B {true} \
   CONFIG.CPU_EXTENSION_RISCV_C {true} \
   CONFIG.CPU_EXTENSION_RISCV_M {true} \
   CONFIG.CPU_EXTENSION_RISCV_Zfinx {true} \
   CONFIG.FAST_MUL_EN {true} \
   CONFIG.FAST_SHIFT_EN {true} \
   CONFIG.HW_THREAD_ID {5} \
   CONFIG.ICACHE_ASSOCIATIVITY {2} \
   CONFIG.ICACHE_EN {true} \
   CONFIG.ICACHE_NUM_BLOCKS {8} \
   CONFIG.INT_BOOTLOADER_EN {false} \
   CONFIG.IO_NEOLED_EN {false} \
   CONFIG.IO_SPI_EN {false} \
   CONFIG.IO_TWI_EN {false} \
   CONFIG.IO_UART0_RX_FIFO {1} \
   CONFIG.IO_UART0_TX_FIFO {1} \
   CONFIG.IO_UART1_EN {false} \
   CONFIG.MEM_INT_DMEM_EN {false} \
   CONFIG.MEM_INT_IMEM_EN {false} \
   CONFIG.PMP_NUM_REGIONS {0} \
   CONFIG.XIRQ_NUM_CH {32} \
 ] $neorv32_SystemTop_ax_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_1

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {32} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net CTRL_S_AXI_1 [get_bd_intf_pins CTRL_S_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins INSTR_DRAM_M00_AXI] [get_bd_intf_pins instr_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi4_address_mangler_1_M_AXI [get_bd_intf_pins DATA_DRAM_M00_AXI1] [get_bd_intf_pins data_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net neorv32_SystemTop_ax_0_m_axi [get_bd_intf_pins neorv32_SystemTop_ax_0/m_axi] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins instr_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins data_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M01_AXI [get_bd_intf_pins gpio_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M02_AXI [get_bd_intf_pins interrupt_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M02_AXI]

  # Create port connections
  connect_bd_net -net Op2_1 [get_bd_pins CPU_reset] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins data_address_mangler/aclk] [get_bd_pins gpio_gpio/s_axi_aclk] [get_bd_pins instr_address_mangler/aclk] [get_bd_pins interrupt_gpio/s_axi_aclk] [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins data_address_mangler/aresetn] [get_bd_pins gpio_gpio/s_axi_aresetn] [get_bd_pins instr_address_mangler/aresetn] [get_bd_pins interrupt_gpio/s_axi_aresetn] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net axi_gpio_1_gpio2_io_o [get_bd_pins gpio_gpio/gpio2_io_o] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins interrupt_gpio/gpio_io_o] [get_bd_pins neorv32_SystemTop_ax_0/xirq_i]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_pins axi_uartlite_0/tx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_rxd_i]
  connect_bd_net -net neorv32_SystemTop_ax_0_gpio_o [get_bd_pins neorv32_SystemTop_ax_0/gpio_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net neorv32_SystemTop_ax_0_uart0_txd_o [get_bd_pins axi_uartlite_0/rx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_txd_o]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aresetn] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins neorv32_SystemTop_ax_0/gpio_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins neorv32_SystemTop_ax_0/cfs_in_i] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins gpio_gpio/gpio_io_i] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cpu_4
proc create_hier_cell_cpu_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_cpu_4() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CONFIG_ROM_M03_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CTRL_S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DATA_DRAM_M00_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 INSTR_DRAM_M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 SHARED_URAM_M02_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 CPU_reset
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst interconnect_aresetn

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {9600} \
   CONFIG.C_ODD_PARITY {0} \
   CONFIG.C_USE_PARITY {0} \
   CONFIG.PARITY {No_Parity} \
 ] $axi_uartlite_0

  # Create instance: data_address_mangler, and set properties
  set data_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 data_address_mangler ]
  set_property -dict [ list \
   CONFIG.field00_used_bits {0x000000007FFFFFFF} \
   CONFIG.inject {0x00000500A0000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $data_address_mangler

  # Create instance: gpio_gpio, and set properties
  set gpio_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {1} \
 ] $gpio_gpio

  # Create instance: instr_address_mangler, and set properties
  set instr_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 instr_address_mangler ]
  set_property -dict [ list \
   CONFIG.inject {0x0000050000000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $instr_address_mangler

  # Create instance: interrupt_gpio, and set properties
  set interrupt_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 interrupt_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {0} \
 ] $interrupt_gpio

  # Create instance: neorv32_SystemTop_ax_0, and set properties
  set block_name neorv32_SystemTop_axi4lite
  set block_cell_name neorv32_SystemTop_ax_0
  if { [catch {set neorv32_SystemTop_ax_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $neorv32_SystemTop_ax_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CLOCK_FREQUENCY {100000000} \
   CONFIG.CPU_EXTENSION_RISCV_B {true} \
   CONFIG.CPU_EXTENSION_RISCV_C {true} \
   CONFIG.CPU_EXTENSION_RISCV_M {true} \
   CONFIG.CPU_EXTENSION_RISCV_Zfinx {true} \
   CONFIG.FAST_MUL_EN {true} \
   CONFIG.FAST_SHIFT_EN {true} \
   CONFIG.HW_THREAD_ID {4} \
   CONFIG.ICACHE_ASSOCIATIVITY {2} \
   CONFIG.ICACHE_EN {true} \
   CONFIG.ICACHE_NUM_BLOCKS {8} \
   CONFIG.INT_BOOTLOADER_EN {false} \
   CONFIG.IO_NEOLED_EN {false} \
   CONFIG.IO_SPI_EN {false} \
   CONFIG.IO_TWI_EN {false} \
   CONFIG.IO_UART0_RX_FIFO {1} \
   CONFIG.IO_UART0_TX_FIFO {1} \
   CONFIG.IO_UART1_EN {false} \
   CONFIG.MEM_INT_DMEM_EN {false} \
   CONFIG.MEM_INT_IMEM_EN {false} \
   CONFIG.PMP_NUM_REGIONS {0} \
   CONFIG.XIRQ_NUM_CH {32} \
 ] $neorv32_SystemTop_ax_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_1

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {32} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net CTRL_S_AXI_1 [get_bd_intf_pins CTRL_S_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins INSTR_DRAM_M00_AXI] [get_bd_intf_pins instr_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi4_address_mangler_1_M_AXI [get_bd_intf_pins DATA_DRAM_M00_AXI1] [get_bd_intf_pins data_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net neorv32_SystemTop_ax_0_m_axi [get_bd_intf_pins neorv32_SystemTop_ax_0/m_axi] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins instr_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins data_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M01_AXI [get_bd_intf_pins gpio_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M02_AXI [get_bd_intf_pins interrupt_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M02_AXI]

  # Create port connections
  connect_bd_net -net Op2_1 [get_bd_pins CPU_reset] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins data_address_mangler/aclk] [get_bd_pins gpio_gpio/s_axi_aclk] [get_bd_pins instr_address_mangler/aclk] [get_bd_pins interrupt_gpio/s_axi_aclk] [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins data_address_mangler/aresetn] [get_bd_pins gpio_gpio/s_axi_aresetn] [get_bd_pins instr_address_mangler/aresetn] [get_bd_pins interrupt_gpio/s_axi_aresetn] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net axi_gpio_1_gpio2_io_o [get_bd_pins gpio_gpio/gpio2_io_o] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins interrupt_gpio/gpio_io_o] [get_bd_pins neorv32_SystemTop_ax_0/xirq_i]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_pins axi_uartlite_0/tx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_rxd_i]
  connect_bd_net -net neorv32_SystemTop_ax_0_gpio_o [get_bd_pins neorv32_SystemTop_ax_0/gpio_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net neorv32_SystemTop_ax_0_uart0_txd_o [get_bd_pins axi_uartlite_0/rx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_txd_o]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aresetn] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins neorv32_SystemTop_ax_0/gpio_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins neorv32_SystemTop_ax_0/cfs_in_i] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins gpio_gpio/gpio_io_i] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cpu_3
proc create_hier_cell_cpu_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_cpu_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CONFIG_ROM_M03_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CTRL_S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DATA_DRAM_M00_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 INSTR_DRAM_M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 SHARED_URAM_M02_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 CPU_reset
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst interconnect_aresetn

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {9600} \
   CONFIG.C_ODD_PARITY {0} \
   CONFIG.C_USE_PARITY {0} \
   CONFIG.PARITY {No_Parity} \
 ] $axi_uartlite_0

  # Create instance: data_address_mangler, and set properties
  set data_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 data_address_mangler ]
  set_property -dict [ list \
   CONFIG.field00_used_bits {0x000000007FFFFFFF} \
   CONFIG.inject {0x0000050080000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $data_address_mangler

  # Create instance: gpio_gpio, and set properties
  set gpio_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {1} \
 ] $gpio_gpio

  # Create instance: instr_address_mangler, and set properties
  set instr_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 instr_address_mangler ]
  set_property -dict [ list \
   CONFIG.inject {0x0000050000000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $instr_address_mangler

  # Create instance: interrupt_gpio, and set properties
  set interrupt_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 interrupt_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {0} \
 ] $interrupt_gpio

  # Create instance: neorv32_SystemTop_ax_0, and set properties
  set block_name neorv32_SystemTop_axi4lite
  set block_cell_name neorv32_SystemTop_ax_0
  if { [catch {set neorv32_SystemTop_ax_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $neorv32_SystemTop_ax_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CLOCK_FREQUENCY {100000000} \
   CONFIG.CPU_EXTENSION_RISCV_B {true} \
   CONFIG.CPU_EXTENSION_RISCV_C {true} \
   CONFIG.CPU_EXTENSION_RISCV_M {true} \
   CONFIG.CPU_EXTENSION_RISCV_Zfinx {true} \
   CONFIG.FAST_MUL_EN {true} \
   CONFIG.FAST_SHIFT_EN {true} \
   CONFIG.HW_THREAD_ID {3} \
   CONFIG.ICACHE_ASSOCIATIVITY {2} \
   CONFIG.ICACHE_EN {true} \
   CONFIG.ICACHE_NUM_BLOCKS {8} \
   CONFIG.INT_BOOTLOADER_EN {false} \
   CONFIG.IO_NEOLED_EN {false} \
   CONFIG.IO_SPI_EN {false} \
   CONFIG.IO_TWI_EN {false} \
   CONFIG.IO_UART0_RX_FIFO {1} \
   CONFIG.IO_UART0_TX_FIFO {1} \
   CONFIG.IO_UART1_EN {false} \
   CONFIG.MEM_INT_DMEM_EN {false} \
   CONFIG.MEM_INT_IMEM_EN {false} \
   CONFIG.PMP_NUM_REGIONS {0} \
   CONFIG.XIRQ_NUM_CH {32} \
 ] $neorv32_SystemTop_ax_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_1

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {32} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net CTRL_S_AXI_1 [get_bd_intf_pins CTRL_S_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins INSTR_DRAM_M00_AXI] [get_bd_intf_pins instr_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi4_address_mangler_1_M_AXI [get_bd_intf_pins DATA_DRAM_M00_AXI1] [get_bd_intf_pins data_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net neorv32_SystemTop_ax_0_m_axi [get_bd_intf_pins neorv32_SystemTop_ax_0/m_axi] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins instr_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins data_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M01_AXI [get_bd_intf_pins gpio_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M02_AXI [get_bd_intf_pins interrupt_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M02_AXI]

  # Create port connections
  connect_bd_net -net Op2_1 [get_bd_pins CPU_reset] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins data_address_mangler/aclk] [get_bd_pins gpio_gpio/s_axi_aclk] [get_bd_pins instr_address_mangler/aclk] [get_bd_pins interrupt_gpio/s_axi_aclk] [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins data_address_mangler/aresetn] [get_bd_pins gpio_gpio/s_axi_aresetn] [get_bd_pins instr_address_mangler/aresetn] [get_bd_pins interrupt_gpio/s_axi_aresetn] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net axi_gpio_1_gpio2_io_o [get_bd_pins gpio_gpio/gpio2_io_o] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins interrupt_gpio/gpio_io_o] [get_bd_pins neorv32_SystemTop_ax_0/xirq_i]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_pins axi_uartlite_0/tx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_rxd_i]
  connect_bd_net -net neorv32_SystemTop_ax_0_gpio_o [get_bd_pins neorv32_SystemTop_ax_0/gpio_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net neorv32_SystemTop_ax_0_uart0_txd_o [get_bd_pins axi_uartlite_0/rx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_txd_o]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aresetn] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins neorv32_SystemTop_ax_0/gpio_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins neorv32_SystemTop_ax_0/cfs_in_i] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins gpio_gpio/gpio_io_i] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cpu_2
proc create_hier_cell_cpu_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_cpu_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CONFIG_ROM_M03_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CTRL_S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DATA_DRAM_M00_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 INSTR_DRAM_M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 SHARED_URAM_M02_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 CPU_reset
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst interconnect_aresetn

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {9600} \
   CONFIG.C_ODD_PARITY {0} \
   CONFIG.C_USE_PARITY {0} \
   CONFIG.PARITY {No_Parity} \
 ] $axi_uartlite_0

  # Create instance: data_address_mangler, and set properties
  set data_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 data_address_mangler ]
  set_property -dict [ list \
   CONFIG.field00_used_bits {0x000000007FFFFFFF} \
   CONFIG.inject {0x0000050060000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $data_address_mangler

  # Create instance: gpio_gpio, and set properties
  set gpio_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {1} \
 ] $gpio_gpio

  # Create instance: instr_address_mangler, and set properties
  set instr_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 instr_address_mangler ]
  set_property -dict [ list \
   CONFIG.inject {0x0000050000000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $instr_address_mangler

  # Create instance: interrupt_gpio, and set properties
  set interrupt_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 interrupt_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {0} \
 ] $interrupt_gpio

  # Create instance: neorv32_SystemTop_ax_0, and set properties
  set block_name neorv32_SystemTop_axi4lite
  set block_cell_name neorv32_SystemTop_ax_0
  if { [catch {set neorv32_SystemTop_ax_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $neorv32_SystemTop_ax_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CLOCK_FREQUENCY {100000000} \
   CONFIG.CPU_EXTENSION_RISCV_B {true} \
   CONFIG.CPU_EXTENSION_RISCV_C {true} \
   CONFIG.CPU_EXTENSION_RISCV_M {true} \
   CONFIG.CPU_EXTENSION_RISCV_Zfinx {true} \
   CONFIG.FAST_MUL_EN {true} \
   CONFIG.FAST_SHIFT_EN {true} \
   CONFIG.HW_THREAD_ID {2} \
   CONFIG.ICACHE_ASSOCIATIVITY {2} \
   CONFIG.ICACHE_EN {true} \
   CONFIG.ICACHE_NUM_BLOCKS {8} \
   CONFIG.INT_BOOTLOADER_EN {false} \
   CONFIG.IO_NEOLED_EN {false} \
   CONFIG.IO_SPI_EN {false} \
   CONFIG.IO_TWI_EN {false} \
   CONFIG.IO_UART0_RX_FIFO {1} \
   CONFIG.IO_UART0_TX_FIFO {1} \
   CONFIG.IO_UART1_EN {false} \
   CONFIG.MEM_INT_DMEM_EN {false} \
   CONFIG.MEM_INT_IMEM_EN {false} \
   CONFIG.PMP_NUM_REGIONS {0} \
   CONFIG.XIRQ_NUM_CH {32} \
 ] $neorv32_SystemTop_ax_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_1

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {32} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net CTRL_S_AXI_1 [get_bd_intf_pins CTRL_S_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins INSTR_DRAM_M00_AXI] [get_bd_intf_pins instr_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi4_address_mangler_1_M_AXI [get_bd_intf_pins DATA_DRAM_M00_AXI1] [get_bd_intf_pins data_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net neorv32_SystemTop_ax_0_m_axi [get_bd_intf_pins neorv32_SystemTop_ax_0/m_axi] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins instr_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins data_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M01_AXI [get_bd_intf_pins gpio_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M02_AXI [get_bd_intf_pins interrupt_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M02_AXI]

  # Create port connections
  connect_bd_net -net Op2_1 [get_bd_pins CPU_reset] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins data_address_mangler/aclk] [get_bd_pins gpio_gpio/s_axi_aclk] [get_bd_pins instr_address_mangler/aclk] [get_bd_pins interrupt_gpio/s_axi_aclk] [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins data_address_mangler/aresetn] [get_bd_pins gpio_gpio/s_axi_aresetn] [get_bd_pins instr_address_mangler/aresetn] [get_bd_pins interrupt_gpio/s_axi_aresetn] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net axi_gpio_1_gpio2_io_o [get_bd_pins gpio_gpio/gpio2_io_o] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins interrupt_gpio/gpio_io_o] [get_bd_pins neorv32_SystemTop_ax_0/xirq_i]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_pins axi_uartlite_0/tx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_rxd_i]
  connect_bd_net -net neorv32_SystemTop_ax_0_gpio_o [get_bd_pins neorv32_SystemTop_ax_0/gpio_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net neorv32_SystemTop_ax_0_uart0_txd_o [get_bd_pins axi_uartlite_0/rx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_txd_o]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aresetn] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins neorv32_SystemTop_ax_0/gpio_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins neorv32_SystemTop_ax_0/cfs_in_i] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins gpio_gpio/gpio_io_i] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cpu_1
proc create_hier_cell_cpu_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_cpu_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CONFIG_ROM_M03_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CTRL_S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DATA_DRAM_M00_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 INSTR_DRAM_M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 SHARED_URAM_M02_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 CPU_reset
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst interconnect_aresetn

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {9600} \
   CONFIG.C_ODD_PARITY {0} \
   CONFIG.C_USE_PARITY {0} \
   CONFIG.PARITY {No_Parity} \
 ] $axi_uartlite_0

  # Create instance: data_address_mangler, and set properties
  set data_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 data_address_mangler ]
  set_property -dict [ list \
   CONFIG.field00_used_bits {0x000000007FFFFFFF} \
   CONFIG.inject {0x0000050040000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $data_address_mangler

  # Create instance: gpio_gpio, and set properties
  set gpio_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {1} \
 ] $gpio_gpio

  # Create instance: instr_address_mangler, and set properties
  set instr_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 instr_address_mangler ]
  set_property -dict [ list \
   CONFIG.inject {0x0000050000000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $instr_address_mangler

  # Create instance: interrupt_gpio, and set properties
  set interrupt_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 interrupt_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {0} \
 ] $interrupt_gpio

  # Create instance: neorv32_SystemTop_ax_0, and set properties
  set block_name neorv32_SystemTop_axi4lite
  set block_cell_name neorv32_SystemTop_ax_0
  if { [catch {set neorv32_SystemTop_ax_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $neorv32_SystemTop_ax_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CLOCK_FREQUENCY {100000000} \
   CONFIG.CPU_EXTENSION_RISCV_B {true} \
   CONFIG.CPU_EXTENSION_RISCV_C {true} \
   CONFIG.CPU_EXTENSION_RISCV_M {true} \
   CONFIG.CPU_EXTENSION_RISCV_Zfinx {true} \
   CONFIG.FAST_MUL_EN {true} \
   CONFIG.FAST_SHIFT_EN {true} \
   CONFIG.HW_THREAD_ID {1} \
   CONFIG.ICACHE_ASSOCIATIVITY {2} \
   CONFIG.ICACHE_EN {true} \
   CONFIG.ICACHE_NUM_BLOCKS {8} \
   CONFIG.INT_BOOTLOADER_EN {false} \
   CONFIG.IO_NEOLED_EN {false} \
   CONFIG.IO_SPI_EN {false} \
   CONFIG.IO_TWI_EN {false} \
   CONFIG.IO_UART0_RX_FIFO {1} \
   CONFIG.IO_UART0_TX_FIFO {1} \
   CONFIG.IO_UART1_EN {false} \
   CONFIG.MEM_INT_DMEM_EN {false} \
   CONFIG.MEM_INT_IMEM_EN {false} \
   CONFIG.PMP_NUM_REGIONS {0} \
   CONFIG.XIRQ_NUM_CH {32} \
 ] $neorv32_SystemTop_ax_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_1

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {32} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net CTRL_S_AXI_1 [get_bd_intf_pins CTRL_S_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins INSTR_DRAM_M00_AXI] [get_bd_intf_pins instr_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi4_address_mangler_1_M_AXI [get_bd_intf_pins DATA_DRAM_M00_AXI1] [get_bd_intf_pins data_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net neorv32_SystemTop_ax_0_m_axi [get_bd_intf_pins neorv32_SystemTop_ax_0/m_axi] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins instr_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins data_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M01_AXI [get_bd_intf_pins gpio_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M02_AXI [get_bd_intf_pins interrupt_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M02_AXI]

  # Create port connections
  connect_bd_net -net Op2_1 [get_bd_pins CPU_reset] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins data_address_mangler/aclk] [get_bd_pins gpio_gpio/s_axi_aclk] [get_bd_pins instr_address_mangler/aclk] [get_bd_pins interrupt_gpio/s_axi_aclk] [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins data_address_mangler/aresetn] [get_bd_pins gpio_gpio/s_axi_aresetn] [get_bd_pins instr_address_mangler/aresetn] [get_bd_pins interrupt_gpio/s_axi_aresetn] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net axi_gpio_1_gpio2_io_o [get_bd_pins gpio_gpio/gpio2_io_o] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins interrupt_gpio/gpio_io_o] [get_bd_pins neorv32_SystemTop_ax_0/xirq_i]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_pins axi_uartlite_0/tx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_rxd_i]
  connect_bd_net -net neorv32_SystemTop_ax_0_gpio_o [get_bd_pins neorv32_SystemTop_ax_0/gpio_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net neorv32_SystemTop_ax_0_uart0_txd_o [get_bd_pins axi_uartlite_0/rx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_txd_o]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aresetn] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins neorv32_SystemTop_ax_0/gpio_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins neorv32_SystemTop_ax_0/cfs_in_i] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins gpio_gpio/gpio_io_i] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cpu_0
proc create_hier_cell_cpu_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_cpu_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 CONFIG_ROM_M03_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CTRL_S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DATA_DRAM_M00_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 INSTR_DRAM_M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 SHARED_URAM_M02_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 CPU_reset
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst interconnect_aresetn

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {9600} \
   CONFIG.C_ODD_PARITY {0} \
   CONFIG.C_USE_PARITY {0} \
   CONFIG.PARITY {No_Parity} \
 ] $axi_uartlite_0

  # Create instance: data_address_mangler, and set properties
  set data_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 data_address_mangler ]
  set_property -dict [ list \
   CONFIG.field00_used_bits {0x000000007FFFFFFF} \
   CONFIG.inject {0x0000050020000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $data_address_mangler

  # Create instance: gpio_gpio, and set properties
  set gpio_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {1} \
 ] $gpio_gpio

  # Create instance: instr_address_mangler, and set properties
  set instr_address_mangler [ create_bd_cell -type ip -vlnv alpha-data.com:user:axi4_address_mangler:1.0 instr_address_mangler ]
  set_property -dict [ list \
   CONFIG.inject {0x0000050000000000} \
   CONFIG.m_axi_addr_width {64} \
 ] $instr_address_mangler

  # Create instance: interrupt_gpio, and set properties
  set interrupt_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 interrupt_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {0} \
 ] $interrupt_gpio

  # Create instance: neorv32_SystemTop_ax_0, and set properties
  set block_name neorv32_SystemTop_axi4lite
  set block_cell_name neorv32_SystemTop_ax_0
  if { [catch {set neorv32_SystemTop_ax_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $neorv32_SystemTop_ax_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CLOCK_FREQUENCY {100000000} \
   CONFIG.CPU_EXTENSION_RISCV_B {true} \
   CONFIG.CPU_EXTENSION_RISCV_C {true} \
   CONFIG.CPU_EXTENSION_RISCV_M {true} \
   CONFIG.CPU_EXTENSION_RISCV_Zfinx {true} \
   CONFIG.FAST_MUL_EN {true} \
   CONFIG.FAST_SHIFT_EN {true} \
   CONFIG.ICACHE_ASSOCIATIVITY {2} \
   CONFIG.ICACHE_EN {true} \
   CONFIG.ICACHE_NUM_BLOCKS {8} \
   CONFIG.INT_BOOTLOADER_EN {false} \
   CONFIG.IO_NEOLED_EN {false} \
   CONFIG.IO_SPI_EN {false} \
   CONFIG.IO_TWI_EN {false} \
   CONFIG.IO_UART0_RX_FIFO {1} \
   CONFIG.IO_UART0_TX_FIFO {1} \
   CONFIG.IO_UART1_EN {false} \
   CONFIG.MEM_INT_DMEM_EN {false} \
   CONFIG.MEM_INT_IMEM_EN {false} \
   CONFIG.PMP_NUM_REGIONS {0} \
   CONFIG.XIRQ_NUM_CH {32} \
 ] $neorv32_SystemTop_ax_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_1

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {64} \
   CONFIG.DOUT_WIDTH {32} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net CTRL_S_AXI_1 [get_bd_intf_pins CTRL_S_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins INSTR_DRAM_M00_AXI] [get_bd_intf_pins instr_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi4_address_mangler_1_M_AXI [get_bd_intf_pins DATA_DRAM_M00_AXI1] [get_bd_intf_pins data_address_mangler/M_AXI]
  connect_bd_intf_net -intf_net neorv32_SystemTop_ax_0_m_axi [get_bd_intf_pins neorv32_SystemTop_ax_0/m_axi] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins instr_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins data_address_mangler/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M01_AXI [get_bd_intf_pins gpio_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M02_AXI [get_bd_intf_pins interrupt_gpio/S_AXI] [get_bd_intf_pins smartconnect_1/M02_AXI]

  # Create port connections
  connect_bd_net -net Op2_1 [get_bd_pins CPU_reset] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins data_address_mangler/aclk] [get_bd_pins gpio_gpio/s_axi_aclk] [get_bd_pins instr_address_mangler/aclk] [get_bd_pins interrupt_gpio/s_axi_aclk] [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins data_address_mangler/aresetn] [get_bd_pins gpio_gpio/s_axi_aresetn] [get_bd_pins instr_address_mangler/aresetn] [get_bd_pins interrupt_gpio/s_axi_aresetn] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net axi_gpio_1_gpio2_io_o [get_bd_pins gpio_gpio/gpio2_io_o] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins interrupt_gpio/gpio_io_o] [get_bd_pins neorv32_SystemTop_ax_0/xirq_i]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_pins axi_uartlite_0/tx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_rxd_i]
  connect_bd_net -net neorv32_SystemTop_ax_0_gpio_o [get_bd_pins neorv32_SystemTop_ax_0/gpio_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net neorv32_SystemTop_ax_0_uart0_txd_o [get_bd_pins axi_uartlite_0/rx] [get_bd_pins neorv32_SystemTop_ax_0/uart0_txd_o]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins neorv32_SystemTop_ax_0/m_axi_aresetn] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins neorv32_SystemTop_ax_0/gpio_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins neorv32_SystemTop_ax_0/cfs_in_i] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins gpio_gpio/gpio_io_i] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: versal_bci
proc create_hier_cell_versal_bci { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_versal_bci() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv alpha-data.com:user:avr_rtl:1.0 avr

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 axil


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type clk dest_clk
  create_bd_pin -dir O -from 0 -to 0 dest_out

  # Create instance: bci, and set properties
  set bci [ create_bd_cell -type ip -vlnv alpha-data.com:user:bci_versal:1.1 bci ]

  # Create instance: bci_irq_cdc, and set properties
  set bci_irq_cdc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xpm_cdc_gen:1.0 bci_irq_cdc ]
  set_property -dict [ list \
   CONFIG.CDC_TYPE {xpm_cdc_single} \
   CONFIG.DEST_SYNC_FF {2} \
   CONFIG.INIT_SYNC_FF {true} \
   CONFIG.SRC_INPUT_REG {false} \
   CONFIG.WIDTH {1} \
 ] $bci_irq_cdc

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins avr] [get_bd_intf_pins bci/avr]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axil] [get_bd_intf_pins bci/axil]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins bci/aclk] [get_bd_pins bci_irq_cdc/src_clk]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins bci/aresetn]
  connect_bd_net -net bci_irq [get_bd_pins bci/irq] [get_bd_pins bci_irq_cdc/src_in]
  connect_bd_net -net bci_irq_cdc_dest_out [get_bd_pins dest_out] [get_bd_pins bci_irq_cdc/dest_out]
  connect_bd_net -net dest_clk_1 [get_bd_pins dest_clk] [get_bd_pins bci_irq_cdc/dest_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: CPUs
proc create_hier_cell_CPUs { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_CPUs() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 DATA_DRAM_M00_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 INSTR_M00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst interconnect_aresetn

  # Create instance: configuration_cpu_ctrl, and set properties
  set configuration_cpu_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 configuration_cpu_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $configuration_cpu_ctrl

  # Create instance: configuration_ctrl, and set properties
  set configuration_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 configuration_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $configuration_ctrl

  # Create instance: configuration_rom, and set properties
  set configuration_rom [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 configuration_rom ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH_A {14} \
   CONFIG.ADDR_WIDTH_B {14} \
   CONFIG.ENABLE_32BIT_ADDRESS {true} \
   CONFIG.ENABLE_BYTE_WRITES_A {false} \
   CONFIG.ENABLE_BYTE_WRITES_B {false} \
   CONFIG.MEMORY_DEPTH {4096} \
   CONFIG.MEMORY_INIT_FILE {/home/nbrown23/projects/risc-v-testbed/soft-cores/minotaur/mk2/hw/src/device_info.mem} \
   CONFIG.MEMORY_PRIMITIVE {BRAM} \
   CONFIG.MEMORY_SIZE {131072} \
   CONFIG.MEMORY_TYPE {True_Dual_Port_RAM} \
   CONFIG.READ_DATA_WIDTH_A {32} \
   CONFIG.READ_DATA_WIDTH_B {32} \
   CONFIG.READ_LATENCY_A {1} \
   CONFIG.READ_LATENCY_B {1} \
   CONFIG.USE_MEMORY_BLOCK {Stand_Alone} \
   CONFIG.WRITE_DATA_WIDTH_A {32} \
   CONFIG.WRITE_DATA_WIDTH_B {32} \
   CONFIG.WRITE_MODE_A {NO_CHANGE} \
   CONFIG.WRITE_MODE_B {NO_CHANGE} \
 ] $configuration_rom

  # Create instance: cpu_0
  create_hier_cell_cpu_0 $hier_obj cpu_0

  # Create instance: cpu_1
  create_hier_cell_cpu_1 $hier_obj cpu_1

  # Create instance: cpu_2
  create_hier_cell_cpu_2 $hier_obj cpu_2

  # Create instance: cpu_3
  create_hier_cell_cpu_3 $hier_obj cpu_3

  # Create instance: cpu_4
  create_hier_cell_cpu_4 $hier_obj cpu_4

  # Create instance: cpu_5
  create_hier_cell_cpu_5 $hier_obj cpu_5

  # Create instance: cpu_6
  create_hier_cell_cpu_6 $hier_obj cpu_6

  # Create instance: cpu_7
  create_hier_cell_cpu_7 $hier_obj cpu_7

  # Create instance: reset_gpio, and set properties
  set reset_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 reset_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {8} \
 ] $reset_gpio

  # Create instance: shared_mem_cpu_ctrl, and set properties
  set shared_mem_cpu_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 shared_mem_cpu_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $shared_mem_cpu_ctrl

  # Create instance: shared_mem_ctrl, and set properties
  set shared_mem_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 shared_mem_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $shared_mem_ctrl

  # Create instance: shared_memory, and set properties
  set shared_memory [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 shared_memory ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH_A {22} \
   CONFIG.ADDR_WIDTH_B {22} \
   CONFIG.MEMORY_PRIMITIVE {URAM} \
   CONFIG.MEMORY_TYPE {True_Dual_Port_RAM} \
   CONFIG.WRITE_MODE_A {NO_CHANGE} \
   CONFIG.WRITE_MODE_B {NO_CHANGE} \
 ] $shared_memory

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {11} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {8} \
 ] $smartconnect_1

  # Create instance: smartconnect_2, and set properties
  set smartconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_2 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {8} \
 ] $smartconnect_2

  # Create instance: smartconnect_3, and set properties
  set smartconnect_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_3 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {8} \
 ] $smartconnect_3

  # Create instance: smartconnect_4, and set properties
  set smartconnect_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_4 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {8} \
 ] $smartconnect_4

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {8} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create interface connections
  connect_bd_intf_net -intf_net CTRL_S_AXI_1 [get_bd_intf_pins cpu_0/CTRL_S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins shared_mem_ctrl/BRAM_PORTA] [get_bd_intf_pins shared_memory/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTA [get_bd_intf_pins shared_mem_cpu_ctrl/BRAM_PORTA] [get_bd_intf_pins shared_memory/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_2_BRAM_PORTA [get_bd_intf_pins configuration_ctrl/BRAM_PORTA] [get_bd_intf_pins configuration_rom/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_3_BRAM_PORTA [get_bd_intf_pins configuration_cpu_ctrl/BRAM_PORTA] [get_bd_intf_pins configuration_rom/BRAM_PORTB]
  connect_bd_intf_net -intf_net cpu_0_CONFIG_ROM_M03_AXI [get_bd_intf_pins cpu_0/CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_3/S00_AXI]
  connect_bd_intf_net -intf_net cpu_0_DATA_DRAM_M00_AXI1 [get_bd_intf_pins cpu_0/DATA_DRAM_M00_AXI1] [get_bd_intf_pins smartconnect_4/S00_AXI]
  connect_bd_intf_net -intf_net cpu_0_INSTR_DRAM_M00_AXI [get_bd_intf_pins cpu_0/INSTR_DRAM_M00_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net cpu_0_SHARED_URAM_M02_AXI [get_bd_intf_pins cpu_0/SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_2/S00_AXI]
  connect_bd_intf_net -intf_net cpu_1_CONFIG_ROM_M03_AXI [get_bd_intf_pins cpu_1/CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_3/S01_AXI]
  connect_bd_intf_net -intf_net cpu_1_DATA_DRAM_M00_AXI1 [get_bd_intf_pins cpu_1/DATA_DRAM_M00_AXI1] [get_bd_intf_pins smartconnect_4/S01_AXI]
  connect_bd_intf_net -intf_net cpu_1_INSTR_DRAM_M00_AXI [get_bd_intf_pins cpu_1/INSTR_DRAM_M00_AXI] [get_bd_intf_pins smartconnect_1/S01_AXI]
  connect_bd_intf_net -intf_net cpu_1_SHARED_URAM_M02_AXI [get_bd_intf_pins cpu_1/SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_2/S01_AXI]
  connect_bd_intf_net -intf_net cpu_2_CONFIG_ROM_M03_AXI [get_bd_intf_pins cpu_2/CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_3/S02_AXI]
  connect_bd_intf_net -intf_net cpu_2_DATA_DRAM_M00_AXI1 [get_bd_intf_pins cpu_2/DATA_DRAM_M00_AXI1] [get_bd_intf_pins smartconnect_4/S02_AXI]
  connect_bd_intf_net -intf_net cpu_2_INSTR_DRAM_M00_AXI [get_bd_intf_pins cpu_2/INSTR_DRAM_M00_AXI] [get_bd_intf_pins smartconnect_1/S02_AXI]
  connect_bd_intf_net -intf_net cpu_2_SHARED_URAM_M02_AXI [get_bd_intf_pins cpu_2/SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_2/S02_AXI]
  connect_bd_intf_net -intf_net cpu_3_CONFIG_ROM_M03_AXI [get_bd_intf_pins cpu_3/CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_3/S03_AXI]
  connect_bd_intf_net -intf_net cpu_3_DATA_DRAM_M00_AXI1 [get_bd_intf_pins cpu_3/DATA_DRAM_M00_AXI1] [get_bd_intf_pins smartconnect_4/S03_AXI]
  connect_bd_intf_net -intf_net cpu_3_INSTR_DRAM_M00_AXI [get_bd_intf_pins cpu_3/INSTR_DRAM_M00_AXI] [get_bd_intf_pins smartconnect_1/S03_AXI]
  connect_bd_intf_net -intf_net cpu_3_SHARED_URAM_M02_AXI [get_bd_intf_pins cpu_3/SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_2/S03_AXI]
  connect_bd_intf_net -intf_net cpu_4_CONFIG_ROM_M03_AXI [get_bd_intf_pins cpu_4/CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_3/S04_AXI]
  connect_bd_intf_net -intf_net cpu_4_DATA_DRAM_M00_AXI1 [get_bd_intf_pins cpu_4/DATA_DRAM_M00_AXI1] [get_bd_intf_pins smartconnect_4/S04_AXI]
  connect_bd_intf_net -intf_net cpu_4_INSTR_DRAM_M00_AXI [get_bd_intf_pins cpu_4/INSTR_DRAM_M00_AXI] [get_bd_intf_pins smartconnect_1/S04_AXI]
  connect_bd_intf_net -intf_net cpu_4_SHARED_URAM_M02_AXI [get_bd_intf_pins cpu_4/SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_2/S04_AXI]
  connect_bd_intf_net -intf_net cpu_5_CONFIG_ROM_M03_AXI [get_bd_intf_pins cpu_5/CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_3/S05_AXI]
  connect_bd_intf_net -intf_net cpu_5_DATA_DRAM_M00_AXI1 [get_bd_intf_pins cpu_5/DATA_DRAM_M00_AXI1] [get_bd_intf_pins smartconnect_4/S05_AXI]
  connect_bd_intf_net -intf_net cpu_5_INSTR_DRAM_M00_AXI [get_bd_intf_pins cpu_5/INSTR_DRAM_M00_AXI] [get_bd_intf_pins smartconnect_1/S05_AXI]
  connect_bd_intf_net -intf_net cpu_5_SHARED_URAM_M02_AXI [get_bd_intf_pins cpu_5/SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_2/S05_AXI]
  connect_bd_intf_net -intf_net cpu_6_CONFIG_ROM_M03_AXI [get_bd_intf_pins cpu_6/CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_3/S06_AXI]
  connect_bd_intf_net -intf_net cpu_6_DATA_DRAM_M00_AXI1 [get_bd_intf_pins cpu_6/DATA_DRAM_M00_AXI1] [get_bd_intf_pins smartconnect_4/S06_AXI]
  connect_bd_intf_net -intf_net cpu_6_INSTR_DRAM_M00_AXI [get_bd_intf_pins cpu_6/INSTR_DRAM_M00_AXI] [get_bd_intf_pins smartconnect_1/S06_AXI]
  connect_bd_intf_net -intf_net cpu_6_SHARED_URAM_M02_AXI [get_bd_intf_pins cpu_6/SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_2/S06_AXI]
  connect_bd_intf_net -intf_net cpu_7_CONFIG_ROM_M03_AXI [get_bd_intf_pins cpu_7/CONFIG_ROM_M03_AXI] [get_bd_intf_pins smartconnect_3/S07_AXI]
  connect_bd_intf_net -intf_net cpu_7_DATA_DRAM_M00_AXI1 [get_bd_intf_pins cpu_7/DATA_DRAM_M00_AXI1] [get_bd_intf_pins smartconnect_4/S07_AXI]
  connect_bd_intf_net -intf_net cpu_7_INSTR_DRAM_M00_AXI [get_bd_intf_pins cpu_7/INSTR_DRAM_M00_AXI] [get_bd_intf_pins smartconnect_1/S07_AXI]
  connect_bd_intf_net -intf_net cpu_7_SHARED_URAM_M02_AXI [get_bd_intf_pins cpu_7/SHARED_URAM_M02_AXI] [get_bd_intf_pins smartconnect_2/S07_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins reset_gpio/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins shared_mem_ctrl/S_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins configuration_ctrl/S_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins cpu_1/CTRL_S_AXI] [get_bd_intf_pins smartconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_pins cpu_2/CTRL_S_AXI] [get_bd_intf_pins smartconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M06_AXI [get_bd_intf_pins cpu_3/CTRL_S_AXI] [get_bd_intf_pins smartconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M07_AXI [get_bd_intf_pins cpu_4/CTRL_S_AXI] [get_bd_intf_pins smartconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M08_AXI [get_bd_intf_pins cpu_5/CTRL_S_AXI] [get_bd_intf_pins smartconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M09_AXI [get_bd_intf_pins cpu_6/CTRL_S_AXI] [get_bd_intf_pins smartconnect_0/M09_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M10_AXI [get_bd_intf_pins cpu_7/CTRL_S_AXI] [get_bd_intf_pins smartconnect_0/M10_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins INSTR_M00_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_2_M00_AXI [get_bd_intf_pins shared_mem_cpu_ctrl/S_AXI] [get_bd_intf_pins smartconnect_2/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_3_M00_AXI [get_bd_intf_pins configuration_cpu_ctrl/S_AXI] [get_bd_intf_pins smartconnect_3/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M00_AXI [get_bd_intf_pins DATA_DRAM_M00_AXI1] [get_bd_intf_pins smartconnect_4/M00_AXI]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins configuration_cpu_ctrl/s_axi_aclk] [get_bd_pins configuration_ctrl/s_axi_aclk] [get_bd_pins cpu_0/aclk] [get_bd_pins cpu_1/aclk] [get_bd_pins cpu_2/aclk] [get_bd_pins cpu_3/aclk] [get_bd_pins cpu_4/aclk] [get_bd_pins cpu_5/aclk] [get_bd_pins cpu_6/aclk] [get_bd_pins cpu_7/aclk] [get_bd_pins reset_gpio/s_axi_aclk] [get_bd_pins shared_mem_cpu_ctrl/s_axi_aclk] [get_bd_pins shared_mem_ctrl/s_axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk] [get_bd_pins smartconnect_2/aclk] [get_bd_pins smartconnect_3/aclk] [get_bd_pins smartconnect_4/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins interconnect_aresetn] [get_bd_pins cpu_0/interconnect_aresetn] [get_bd_pins cpu_1/interconnect_aresetn] [get_bd_pins cpu_2/interconnect_aresetn] [get_bd_pins cpu_3/interconnect_aresetn] [get_bd_pins cpu_4/aresetn] [get_bd_pins cpu_4/interconnect_aresetn] [get_bd_pins cpu_5/aresetn] [get_bd_pins cpu_5/interconnect_aresetn] [get_bd_pins cpu_6/aresetn] [get_bd_pins cpu_6/interconnect_aresetn] [get_bd_pins cpu_7/aresetn] [get_bd_pins cpu_7/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins configuration_cpu_ctrl/s_axi_aresetn] [get_bd_pins configuration_ctrl/s_axi_aresetn] [get_bd_pins cpu_0/aresetn] [get_bd_pins cpu_1/aresetn] [get_bd_pins cpu_2/aresetn] [get_bd_pins cpu_3/aresetn] [get_bd_pins reset_gpio/s_axi_aresetn] [get_bd_pins shared_mem_cpu_ctrl/s_axi_aresetn] [get_bd_pins shared_mem_ctrl/s_axi_aresetn] [get_bd_pins smartconnect_1/aresetn] [get_bd_pins smartconnect_2/aresetn] [get_bd_pins smartconnect_3/aresetn] [get_bd_pins smartconnect_4/aresetn]
  connect_bd_net -net reset_gpio_gpio_io_o [get_bd_pins reset_gpio/gpio_io_o] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins cpu_0/CPU_reset] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins cpu_1/CPU_reset] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins cpu_2/CPU_reset] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins cpu_3/CPU_reset] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins cpu_4/CPU_reset] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins cpu_6/CPU_reset] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins cpu_5/CPU_reset] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins cpu_7/CPU_reset] [get_bd_pins xlslice_7/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set avr [ create_bd_intf_port -mode Slave -vlnv alpha-data.com:user:avr_rtl:1.0 avr ]

  set c0_ddr4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 c0_ddr4 ]

  set c0_sys_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 c0_sys_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $c0_sys_clk

  set c1_ddr4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 c1_ddr4 ]

  set c1_sys_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 c1_sys_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $c1_sys_clk

  set pcie0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 pcie0 ]

  set sys_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $sys_clk


  # Create ports

  # Create instance: CPUs
  create_hier_cell_CPUs [current_bd_instance .] CPUs

  # Create instance: axi_noc_bank0, and set properties
  set axi_noc_bank0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_bank0 ]
  set_property -dict [ list \
   CONFIG.LOGO_FILE {data/noc_mc.png} \
   CONFIG.MC0_FLIPPED_PINOUT {false} \
   CONFIG.MC_ADDR_BIT9 {CA5} \
   CONFIG.MC_BA_WIDTH {2} \
   CONFIG.MC_BG_WIDTH {1} \
   CONFIG.MC_CASLATENCY {26} \
   CONFIG.MC_CASWRITELATENCY {16} \
   CONFIG.MC_CHAN_REGION0 {DDR_CH1} \
   CONFIG.MC_COMPONENT_DENSITY {16Gb} \
   CONFIG.MC_COMPONENT_WIDTH {x16} \
   CONFIG.MC_DATAWIDTH {72} \
   CONFIG.MC_DM_WIDTH {9} \
   CONFIG.MC_DQS_WIDTH {9} \
   CONFIG.MC_DQ_WIDTH {72} \
   CONFIG.MC_ECC {true} \
   CONFIG.MC_EN_ECC_SCRUBBING {true} \
   CONFIG.MC_EN_INTR_RESP {FALSE} \
   CONFIG.MC_F1_CASLATENCY {26} \
   CONFIG.MC_F1_CASWRITELATENCY {16} \
   CONFIG.MC_F1_TCCD_L {8} \
   CONFIG.MC_F1_TFAW {30000} \
   CONFIG.MC_F1_TRRD_L {11} \
   CONFIG.MC_F1_TRRD_S {9} \
   CONFIG.MC_INPUTCLK0_PERIOD {3333} \
   CONFIG.MC_INPUT_FREQUENCY0 {300.000} \
   CONFIG.MC_MEMORY_DENSITY {8GB} \
   CONFIG.MC_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} \
   CONFIG.MC_MEMORY_TIMEPERIOD0 {625} \
   CONFIG.MC_MEMORY_TIMEPERIOD1 {625} \
   CONFIG.MC_PARITY {false} \
   CONFIG.MC_PARITYLATENCY {0} \
   CONFIG.MC_READ_DBI {true} \
   CONFIG.MC_REF_AND_PER_CAL_INTF {TRUE} \
   CONFIG.MC_ROWADDRESSWIDTH {17} \
   CONFIG.MC_TCCD_L {8} \
   CONFIG.MC_TFAW {30000} \
   CONFIG.MC_TMOD {24} \
   CONFIG.MC_TPAR_ALERT_ON {10} \
   CONFIG.MC_TPAR_ALERT_PW_MAX {192} \
   CONFIG.MC_TRAS {32000} \
   CONFIG.MC_TRC {45750} \
   CONFIG.MC_TRCD {13750} \
   CONFIG.MC_TREFI {7800000} \
   CONFIG.MC_TRFC {550000} \
   CONFIG.MC_TRP {13750} \
   CONFIG.MC_TRRD_L {11} \
   CONFIG.MC_TRRD_S {9} \
   CONFIG.MC_TRTP {7500} \
   CONFIG.MC_TWR {15000} \
   CONFIG.MC_TWTR_L {7500} \
   CONFIG.MC_TWTR_S {2500} \
   CONFIG.MC_TXPR {896} \
   CONFIG.MC_WRITE_DM_DBI {NO_DM_DC_DBI} \
   CONFIG.MC_XPLL_CLKOUT1_PERIOD {1250} \
   CONFIG.MC_XPLL_CLKOUT1_PHASE {238.176} \
   CONFIG.NUM_CLKS {4} \
   CONFIG.NUM_MC {1} \
   CONFIG.NUM_MCP {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_NMI {1} \
   CONFIG.NUM_NSI {0} \
   CONFIG.NUM_SI {4} \
 ] $axi_noc_bank0

  set_property -dict [ list \
   CONFIG.APERTURES {{0x201_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_bank0/M00_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} M00_AXI {read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} M00_INI {read_bw {1720} write_bw {1720}}} \
   CONFIG.DEST_IDS {M00_AXI:0x80} \
   CONFIG.CATEGORY {ps_pcie} \
 ] [get_bd_intf_pins /axi_noc_bank0/S00_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} M00_AXI {read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} M00_INI {read_bw {1720} write_bw {1720}}} \
   CONFIG.DEST_IDS {M00_AXI:0x80} \
   CONFIG.CATEGORY {ps_pcie} \
 ] [get_bd_intf_pins /axi_noc_bank0/S01_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_bank0/S02_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_bank0/S03_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /axi_noc_bank0/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /axi_noc_bank0/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI:S02_AXI:S03_AXI} \
 ] [get_bd_pins /axi_noc_bank0/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {} \
 ] [get_bd_pins /axi_noc_bank0/aclk3]

  # Create instance: axi_noc_bank1, and set properties
  set axi_noc_bank1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_bank1 ]
  set_property -dict [ list \
   CONFIG.LOGO_FILE {data/noc_mc.png} \
   CONFIG.MC0_FLIPPED_PINOUT {true} \
   CONFIG.MC_ADDR_BIT9 {CA5} \
   CONFIG.MC_BA_WIDTH {2} \
   CONFIG.MC_BG_WIDTH {1} \
   CONFIG.MC_CASLATENCY {26} \
   CONFIG.MC_CASWRITELATENCY {16} \
   CONFIG.MC_CHAN_REGION0 {DDR_CH2} \
   CONFIG.MC_COMPONENT_DENSITY {16Gb} \
   CONFIG.MC_COMPONENT_WIDTH {x16} \
   CONFIG.MC_DATAWIDTH {72} \
   CONFIG.MC_DM_WIDTH {9} \
   CONFIG.MC_DQS_WIDTH {9} \
   CONFIG.MC_DQ_WIDTH {72} \
   CONFIG.MC_ECC {true} \
   CONFIG.MC_EN_ECC_SCRUBBING {true} \
   CONFIG.MC_EN_INTR_RESP {FALSE} \
   CONFIG.MC_F1_CASLATENCY {26} \
   CONFIG.MC_F1_CASWRITELATENCY {16} \
   CONFIG.MC_F1_TCCD_L {8} \
   CONFIG.MC_F1_TFAW {30000} \
   CONFIG.MC_F1_TRRD_L {11} \
   CONFIG.MC_F1_TRRD_S {9} \
   CONFIG.MC_INPUTCLK0_PERIOD {3333} \
   CONFIG.MC_INPUT_FREQUENCY0 {300.000} \
   CONFIG.MC_MEMORY_DENSITY {8GB} \
   CONFIG.MC_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} \
   CONFIG.MC_MEMORY_TIMEPERIOD0 {625} \
   CONFIG.MC_MEMORY_TIMEPERIOD1 {625} \
   CONFIG.MC_PARITY {false} \
   CONFIG.MC_PARITYLATENCY {0} \
   CONFIG.MC_READ_DBI {true} \
   CONFIG.MC_REF_AND_PER_CAL_INTF {TRUE} \
   CONFIG.MC_ROWADDRESSWIDTH {17} \
   CONFIG.MC_TCCD_L {8} \
   CONFIG.MC_TFAW {30000} \
   CONFIG.MC_TMOD {24} \
   CONFIG.MC_TPAR_ALERT_ON {10} \
   CONFIG.MC_TPAR_ALERT_PW_MAX {192} \
   CONFIG.MC_TRAS {32000} \
   CONFIG.MC_TRC {45750} \
   CONFIG.MC_TRCD {13750} \
   CONFIG.MC_TREFI {7800000} \
   CONFIG.MC_TRFC {550000} \
   CONFIG.MC_TRP {13750} \
   CONFIG.MC_TRRD_L {11} \
   CONFIG.MC_TRRD_S {9} \
   CONFIG.MC_TRTP {7500} \
   CONFIG.MC_TWR {15000} \
   CONFIG.MC_TWTR_L {7500} \
   CONFIG.MC_TWTR_S {2500} \
   CONFIG.MC_TXPR {896} \
   CONFIG.MC_WRITE_DM_DBI {NO_DM_DC_DBI} \
   CONFIG.MC_XPLL_CLKOUT1_PERIOD {1250} \
   CONFIG.MC_XPLL_CLKOUT1_PHASE {238.176} \
   CONFIG.NUM_CLKS {0} \
   CONFIG.NUM_MC {1} \
   CONFIG.NUM_MCP {1} \
   CONFIG.NUM_MI {0} \
   CONFIG.NUM_NMI {0} \
   CONFIG.NUM_NSI {1} \
   CONFIG.NUM_SI {0} \
 ] $axi_noc_bank1

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
 ] [get_bd_intf_pins /axi_noc_bank1/S00_INI]

  # Create instance: cips, and set properties
  set cips [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.2 cips ]
  set_property -dict [ list \
   CONFIG.BOOT_MODE {Custom} \
   CONFIG.CLOCK_MODE {Custom} \
   CONFIG.CPM_CONFIG {\
     CPM_PCIE0_CFG_VEND_ID {4144}\
     CPM_PCIE0_MAX_LINK_SPEED {8.0_GT/s}\
     CPM_PCIE0_MODES {DMA}\
     CPM_PCIE0_MODE_SELECTION {Advanced}\
     CPM_PCIE0_MSI_X_OPTIONS {MSI-X_Internal}\
     CPM_PCIE0_PF0_BAR0_XDMA_SCALE {Megabytes}\
     CPM_PCIE0_PF0_BAR0_XDMA_SIZE {2}\
     CPM_PCIE0_PF0_BAR0_XDMA_TYPE {AXI_Bridge_Master}\
     CPM_PCIE0_PF0_BAR1_XDMA_ENABLED {1}\
     CPM_PCIE0_PF0_BAR1_XDMA_TYPE {DMA}\
     CPM_PCIE0_PF0_BAR2_XDMA_64BIT {1}\
     CPM_PCIE0_PF0_BAR2_XDMA_AXCACHE {0}\
     CPM_PCIE0_PF0_BAR2_XDMA_ENABLED {1}\
     CPM_PCIE0_PF0_BAR2_XDMA_PREFETCHABLE {1}\
     CPM_PCIE0_PF0_BAR2_XDMA_SCALE {Megabytes}\
     CPM_PCIE0_PF0_BAR2_XDMA_SIZE {8}\
     CPM_PCIE0_PF0_BAR4_XDMA_64BIT {1}\
     CPM_PCIE0_PF0_BAR4_XDMA_ENABLED {1}\
     CPM_PCIE0_PF0_BAR4_XDMA_PREFETCHABLE {1}\
     CPM_PCIE0_PF0_BAR4_XDMA_SCALE {Megabytes}\
     CPM_PCIE0_PF0_BAR4_XDMA_SIZE {8}\
     CPM_PCIE0_PF0_BASE_CLASS_MENU {Memory_controller}\
     CPM_PCIE0_PF0_BASE_CLASS_VALUE {12}\
     CPM_PCIE0_PF0_CFG_DEV_ID {0980}\
     CPM_PCIE0_PF0_CFG_SUBSYS_ID {1000}\
     CPM_PCIE0_PF0_CFG_SUBSYS_VEND_ID {4144}\
     CPM_PCIE0_PF0_INTERFACE_VALUE {FF}\
     CPM_PCIE0_PF0_PCIEBAR2AXIBAR_XDMA_0 {0x20100000000}\
     CPM_PCIE0_PF0_PCIEBAR2AXIBAR_XDMA_2 {0x00000000000}\
     CPM_PCIE0_PF0_PCIEBAR2AXIBAR_XDMA_4 {0x60000000000}\
     CPM_PCIE0_PF0_SUB_CLASS_INTF_MENU {Other_memory_controller}\
     CPM_PCIE0_PF0_USE_CLASS_CODE_LOOKUP_ASSISTANT {0}\
     CPM_PCIE0_PL_LINK_CAP_MAX_LINK_WIDTH {X16}\
     CPM_PCIE0_TANDEM {Tandem_PROM}\
     CPM_PCIE0_XDMA_STS_PORTS {0}\
   } \
   CONFIG.DDR_MEMORY_MODE {Custom} \
   CONFIG.PS_PMC_CONFIG {\
     BOOT_MODE {Custom}\
     CLOCK_MODE {Custom}\
     DDR_MEMORY_MODE {Custom}\
     DESIGN_MODE {1}\
     PCIE_APERTURES_DUAL_ENABLE {0}\
     PCIE_APERTURES_SINGLE_ENABLE {1}\
     PMC_CRP_PL0_REF_CTRL_FREQMHZ {100}\
     PMC_CRP_QSPI_REF_CTRL_FREQMHZ {300}\
     PMC_MIO40 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA low}\
{PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}}\
     PMC_MIO_EN_FOR_PL_PCIE {1}\
     PMC_QSPI_FBCLK {{ENABLE 1} {IO {PMC_MIO 6}}}\
     PMC_QSPI_PERIPHERAL_ENABLE {1}\
     PMC_QSPI_PERIPHERAL_MODE {Dual Parallel}\
     PMC_REF_CLK_FREQMHZ {50.0}\
     PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 0} {POW_IO {PMC_MIO 12}}\
{RESET_ENABLE 0} {RESET_IO {PMC_MIO 12}} {WP_ENABLE 0} {WP_IO {PMC_MIO\
1}}}\
     PMC_SD1_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x00} {CLK_200_SDR_OTAP_DLY 0x00}\
{CLK_50_DDR_ITAP_DLY 0x00} {CLK_50_DDR_OTAP_DLY 0x00}\
{CLK_50_SDR_ITAP_DLY 0x2C} {CLK_50_SDR_OTAP_DLY 0x4} {ENABLE\
1} {IO {PMC_MIO 26 .. 36}}}\
     PMC_SD1_SLOT_TYPE {SD 2.0}\
     PMC_SHOW_CCI_SMMU_SETTINGS {1}\
     PS_BANK_2_IO_STANDARD {LVCMOS3.3}\
     PS_BANK_3_IO_STANDARD {LVCMOS3.3}\
     PS_BOARD_INTERFACE {Custom}\
     PS_GEN_IPI0_ENABLE {1}\
     PS_GEN_IPI1_ENABLE {1}\
     PS_GEN_IPI1_MASTER {R5_0}\
     PS_GEN_IPI2_ENABLE {1}\
     PS_GEN_IPI2_MASTER {R5_1}\
     PS_GEN_IPI3_ENABLE {1}\
     PS_GEN_IPI4_ENABLE {1}\
     PS_GEN_IPI5_ENABLE {1}\
     PS_GEN_IPI6_ENABLE {1}\
     PS_NUM_FABRIC_RESETS {0}\
     PS_PCIE1_PERIPHERAL_ENABLE {1}\
     PS_PCIE2_PERIPHERAL_ENABLE {0}\
     PS_PCIE_EP_RESET1_IO {PMC_MIO 38}\
     PS_PCIE_RESET {{ENABLE 1}}\
     PS_TTC0_PERIPHERAL_ENABLE {1}\
     PS_TTC1_PERIPHERAL_ENABLE {1}\
     PS_TTC2_PERIPHERAL_ENABLE {1}\
     PS_TTC3_PERIPHERAL_ENABLE {1}\
     PS_UART1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}}\
     PS_USE_PMCPL_CLK0 {1}\
     SMON_ALARMS {Set_Alarms_On}\
     SMON_ENABLE_TEMP_AVERAGING {0}\
     SMON_TEMP_AVERAGING_SAMPLES {0}\
   } \
   CONFIG.PS_PMC_CONFIG_APPLIED {1} \
 ] $cips

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: smartconnect, and set properties
  set smartconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect

  # Create instance: versal_bci
  create_hier_cell_versal_bci [current_bd_instance .] versal_bci

  # Create interface connections
  connect_bd_intf_net -intf_net CPUs_DATA_DRAM_M00_AXI1 [get_bd_intf_pins CPUs/DATA_DRAM_M00_AXI1] [get_bd_intf_pins axi_noc_bank0/S03_AXI]
  connect_bd_intf_net -intf_net avr_1 [get_bd_intf_ports avr] [get_bd_intf_pins versal_bci/avr]
  connect_bd_intf_net -intf_net axi_noc_bank0_CH0_DDR4_0 [get_bd_intf_ports c0_ddr4] [get_bd_intf_pins axi_noc_bank0/CH0_DDR4_0]
  connect_bd_intf_net -intf_net axi_noc_bank0_M00_AXI [get_bd_intf_pins axi_noc_bank0/M00_AXI] [get_bd_intf_pins smartconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_bank0_M00_INI [get_bd_intf_pins axi_noc_bank0/M00_INI] [get_bd_intf_pins axi_noc_bank1/S00_INI]
  connect_bd_intf_net -intf_net axi_noc_bank1_CH0_DDR4_0 [get_bd_intf_ports c1_ddr4] [get_bd_intf_pins axi_noc_bank1/CH0_DDR4_0]
  connect_bd_intf_net -intf_net c0_sys_clk_1 [get_bd_intf_ports c0_sys_clk] [get_bd_intf_pins axi_noc_bank0/sys_clk0]
  connect_bd_intf_net -intf_net c1_sys_clk_1 [get_bd_intf_ports c1_sys_clk] [get_bd_intf_pins axi_noc_bank1/sys_clk0]
  connect_bd_intf_net -intf_net cips_CPM_PCIE_NOC_0 [get_bd_intf_pins axi_noc_bank0/S00_AXI] [get_bd_intf_pins cips/CPM_PCIE_NOC_0]
  connect_bd_intf_net -intf_net cips_CPM_PCIE_NOC_1 [get_bd_intf_pins axi_noc_bank0/S01_AXI] [get_bd_intf_pins cips/CPM_PCIE_NOC_1]
  connect_bd_intf_net -intf_net cips_PCIE0_GT [get_bd_intf_ports pcie0] [get_bd_intf_pins cips/PCIE0_GT]
  connect_bd_intf_net -intf_net smartconnect_M00_AXI [get_bd_intf_pins smartconnect/M00_AXI] [get_bd_intf_pins versal_bci/axil]
  connect_bd_intf_net -intf_net smartconnect_M01_AXI [get_bd_intf_pins CPUs/S00_AXI] [get_bd_intf_pins smartconnect/M01_AXI]
  connect_bd_intf_net -intf_net sys_clk_1 [get_bd_intf_ports sys_clk] [get_bd_intf_pins cips/gt_refclk0]
  connect_bd_intf_net -intf_net user_defined_logic_M00_AXI [get_bd_intf_pins CPUs/INSTR_M00_AXI] [get_bd_intf_pins axi_noc_bank0/S02_AXI]

  # Create port connections
  connect_bd_net -net cips_cpm_pcie_noc_axi0_clk [get_bd_pins axi_noc_bank0/aclk0] [get_bd_pins cips/cpm_pcie_noc_axi0_clk]
  connect_bd_net -net cips_cpm_pcie_noc_axi1_clk [get_bd_pins axi_noc_bank0/aclk1] [get_bd_pins cips/cpm_pcie_noc_axi1_clk]
  connect_bd_net -net cips_dma0_axi_aresetn [get_bd_pins CPUs/aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins versal_bci/aresetn]
  connect_bd_net -net cips_dma0_axi_aresetn1 [get_bd_pins cips/dma0_axi_aresetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net cips_pcie0_user_clk [get_bd_pins cips/pcie0_user_clk] [get_bd_pins versal_bci/dest_clk]
  connect_bd_net -net cips_pl0_ref_clk [get_bd_pins CPUs/aclk] [get_bd_pins axi_noc_bank0/aclk2] [get_bd_pins axi_noc_bank0/aclk3] [get_bd_pins cips/pl0_ref_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect/aclk] [get_bd_pins versal_bci/aclk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins CPUs/interconnect_aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins smartconnect/aresetn]
  connect_bd_net -net versal_bci_dest_out [get_bd_pins cips/xdma0_usr_irq_in] [get_bd_pins versal_bci/dest_out]

  # Create address segments
  assign_bd_address -offset 0x020100400000 -range 0x00400000 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/shared_mem_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/configuration_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100001000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/reset_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100003000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_0/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100003400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_0/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs axi_noc_bank0/S00_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x060000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs axi_noc_bank1/S00_INI/C0_DDR_CH2] -force
  assign_bd_address -offset 0x020100003200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_0/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100004200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_1/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100005200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_2/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100006200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_3/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100007200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_4/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100008200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_5/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100009200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_6/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x02010000A200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_7/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs versal_bci/bci/axil/reg0] -force
  assign_bd_address -offset 0x020100004000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_1/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100005000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_2/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100006000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_3/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100007000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_4/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100008000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_5/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100009000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_6/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x02010000A000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_7/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100004400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_1/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100005400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_2/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100006400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_3/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x02010000A400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_7/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100007400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_4/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100008400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_5/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100009400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_0] [get_bd_addr_segs CPUs/cpu_6/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100400000 -range 0x00400000 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/shared_mem_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/configuration_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100001000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/reset_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100003000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_0/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100003400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_0/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs axi_noc_bank0/S01_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x060000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs axi_noc_bank1/S00_INI/C0_DDR_CH2] -force
  assign_bd_address -offset 0x020100023200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_0/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100004200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_1/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100005200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_2/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100006200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_3/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100007200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_4/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100008200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_5/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100009200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_6/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x02010000A200 -range 0x00000080 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_7/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs versal_bci/bci/axil/reg0] -force
  assign_bd_address -offset 0x020100004000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_1/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100005000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_2/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100006000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_3/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100007000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_4/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100008000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_5/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100009000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_6/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x02010000A000 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_7/gpio_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100004400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_1/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100005400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_2/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100006400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_3/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100007400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_4/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100008400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_5/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x020100009400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_6/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x02010000A400 -range 0x00000200 -target_address_space [get_bd_addr_spaces cips/CPM_PCIE_NOC_1] [get_bd_addr_segs CPUs/cpu_7/interrupt_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_0/data_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S03_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_0/instr_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S02_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_0/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_0/instr_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_0/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_0/data_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces CPUs/cpu_0/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/shared_mem_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC1000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces CPUs/cpu_0/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/configuration_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_1/data_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S03_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_1/instr_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S02_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0xC1000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces CPUs/cpu_1/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/configuration_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_1/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_1/data_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_1/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_1/instr_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces CPUs/cpu_1/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/shared_mem_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_2/data_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S03_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_2/instr_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S02_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0xC1000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces CPUs/cpu_2/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/configuration_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_2/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_2/data_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_2/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_2/instr_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces CPUs/cpu_2/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/shared_mem_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_3/data_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S03_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_3/instr_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S02_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0xC1000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces CPUs/cpu_3/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/configuration_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_3/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_3/data_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_3/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_3/instr_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces CPUs/cpu_3/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/shared_mem_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_4/data_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S03_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_4/instr_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S02_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0xC1000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces CPUs/cpu_4/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/configuration_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_4/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_4/data_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_4/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_4/instr_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces CPUs/cpu_4/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/shared_mem_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_5/data_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S03_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_5/instr_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S02_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0xC1000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces CPUs/cpu_5/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/configuration_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_5/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_5/data_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_5/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_5/instr_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces CPUs/cpu_5/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/shared_mem_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_6/data_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S03_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_6/instr_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S02_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0xC1000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces CPUs/cpu_6/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/configuration_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_6/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_6/data_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_6/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_6/instr_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces CPUs/cpu_6/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/shared_mem_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_7/data_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S03_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_7/instr_address_mangler/M_AXI] [get_bd_addr_segs axi_noc_bank0/S02_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0xC1000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces CPUs/cpu_7/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/configuration_cpu_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_7/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_7/data_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces CPUs/cpu_7/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/cpu_7/instr_address_mangler/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces CPUs/cpu_7/neorv32_SystemTop_ax_0/m_axi] [get_bd_addr_segs CPUs/shared_mem_cpu_ctrl/S_AXI/Mem0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

