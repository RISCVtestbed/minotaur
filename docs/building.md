# Building the provided files

## Software

Drivers for [Launchpad](https://github.com/RISCVtestbed/launchpad) are included in _sw/drivers_ and when building Launchpad these can be provided by setting the _DEVICE_SRC_DIR_ environment variable.

Files in _sw/compiler_ are support files for the compiler and based on those files from the NEORV32 repository but updated for this specific configuration. The _crt0.S_ file is the wrapper to set up the environment for code, and _neorv32.ld_ is the linker file. You should compile user codes against these files rather than the standard NEORV32 versions.

Once built (assuming the hardware design is loaded) you can execute _./launchpad -config_ to view the current configuration of the design, and _./launchpad -exe hello.bin -c all -uart_ to launch the executable _hello.bin_ on all the soft-cores and then poll for UART updates. The NEORV32 runtime library redirects all stdio, stderr, stdin via UART.

## Hardware design

The _hw/mkxpr.tcl_ script will build the Vivado project, after starting Vivado this can be executed via `Tools -> Run TCL Script`. The _ADM_HWREPO_PATH_ and _NERORV32_PATH_ environment variables must be set. The former provides the path to the AlphaData IP (BDI and Axi address mangler) which is required by the designs, and the later is the top level of the NEORV32 repository.

By default the build script will build for the PA101 (_xcvm1802-vsva2197-2MP-e-S_) and eight cores. You can change the number of cores in _hw/mkxpr.tcl_ via the _num_cores_ variable. You can change to another target, such as the PA100 (_xcvc1902-vsva2197-2MP-e-S_) by setting the part in _hw/mkxpr.tcl_ and also the corresponding _mkbd_ file.
