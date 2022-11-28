# Minotaur RISC-V soft-core

<img src="https://github.com/RISCVtestbed/minotaur/raw/main/docs/img/minotaur.png" width=100 align=right>

This is the Minotaur RISC-V CPU multi-core soft-core design as run on the ExCALIBUR H&ES testbed. Packaging multiple NEORV32 CPU cores together, this design provides a multi-core CPU with independent cores each with a shared 512MB of DDR4-DRAM instruction space and their own 512MB of DDR4-DRAM memory space.

* Detailed configuration information [here](https://github.com/RISCVtestbed/minotaur/blob/main/docs/configuration.md)
* Software and hardware build instructions [here](https://github.com/RISCVtestbed/minotaur/blob/main/docs/building.md)

## Specifications

The number of CPU cores is configurable in the build script.

### CPU core configuration

| <!-- -->    | <!-- -->    |
|-------------|-------------|
| CPU type    | NEORV32     |
| Clock       | 100MHz      |
| Instruction cache blocks | 8 |
| Instruction cache block size | 64 |
| Instruction cache associativity | 2 |
| Features | GPIO, Mtime, Watchdog, Fast mul, Fast shift |
| Number of UART | 1 |
| Supported RISC-V extensions | B, C, M, Zfinx, Zicntr, Ziscr |

### Memory configuration

| Memory area    | Size | Location    |
|-------------|-------------| -------------|
| Instruction | 512MB (shared) | DDR4 |
| Data | 512MB (per core) | DDR4 |
| Shared between cores | 4MB | URAM |
| Config ROM | 4KB | BRAM |

### Supported boards 

| Board    | Manufacturer    |
|-------------|-------------|
| PA100    | AlphaData     |
| PA101       | AlphaData      |


<a href="https://www.flaticon.com/free-icons/minotaur" title="minotaur icons">Minotaur icons created by Freepik - Flaticon</a>
