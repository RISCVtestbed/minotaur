# Building the provided files

## Software

Drivers for [Launchpad](https://github.com/RISCVtestbed/launchpad) are included in _sw/drivers_ and when building Launchpad these can be provided by setting the _DEVICE_SRC_DIR_ environment variable.

Files in _sw/compiler_ are support files for the compiler and based on those files from the NEORV32 repository but updated for this specific configuration. The _crt0.S_ file is the wrapper to set up the environment for code, and _neorv32.ld_ is the linker file. You should compile user codes against these files rather than the standard NEORV32 versions.

Once built (assuming the hardware design is loaded) you can execute _./launchpad -config_ to view the current configuration of the design, and _./launchpad -exe hello.bin -c all -uart_ to launch the executable _hello.bin_ on all the soft-cores and then poll for UART updates. The NEORV32 runtime library redirects all stdio, stderr, stdin via UART.

```
user@host:/home/user/launchpad$ sudo ./launchpad -config
Device: 'Minotaur', version 1 revision 2
CPU configuration: 16 cores of NEORV32
Architecture type: Shared instruction memory, split data memory
Clock frequency: 100MHz
PCIe control BAR window: 0
Memory configuration: 512MB instruction, 512MB data per core, 4096KB shared data

DDR bank 0 in use: yes, DDR bank 1 in use: yes
Core 0: DDR bank 0, host-side base data address 0x50020000000
Core 1: DDR bank 0, host-side base data address 0x50040000000
Core 2: DDR bank 0, host-side base data address 0x50060000000
Core 3: DDR bank 0, host-side base data address 0x50080000000
Core 4: DDR bank 0, host-side base data address 0x500a0000000
Core 5: DDR bank 0, host-side base data address 0x500c0000000
Core 6: DDR bank 0, host-side base data address 0x500e0000000
Core 7: DDR bank 0, host-side base data address 0x50100000000
Core 8: DDR bank 1, host-side base data address 0x60020000000
Core 9: DDR bank 1, host-side base data address 0x60040000000
Core 10: DDR bank 1, host-side base data address 0x60060000000
Core 11: DDR bank 1, host-side base data address 0x60080000000
Core 12: DDR bank 1, host-side base data address 0x600a0000000
Core 13: DDR bank 1, host-side base data address 0x600c0000000
Core 14: DDR bank 1, host-side base data address 0x600e0000000
Core 15: DDR bank 1, host-side base data address 0x60100000000

Host FPGA board type is PA101, serial number 126
FPGA temperature 39.81 C, power draw 17.64 Watts
FPGA has had 61 power cycles, with a total alive time of 40 days, 5 hours, 27 min and 38 secs
```

## Hardware design

The _hw/mkxpr.tcl_ script will build the Vivado project, after starting Vivado this can be executed via `Tools -> Run TCL Script`. The _ADM_HWREPO_PATH_ and _NERORV32_PATH_ environment variables must be set. 

| Environment variable    | Description  |
|-------------|-------------|
| ADM_HWREPO_PATH | Path to the AlphaData IP repository (BDI and Axi address mangler) |
| NERORV32_PATH | Top level of the NEORV32 repository |

By default the build script will build for the PA101 (_xcvm1802-vsva2197-2MP-e-S_) and eight cores. You can change the number of cores in _hw/mkxpr.tcl_ via the _num_cores_ variable. You can change to another target, such as the PA100 (_xcvc1902-vsva2197-2MP-e-S_) by setting the part in _hw/mkxpr.tcl_ and also the corresponding _mkbd_ file.
