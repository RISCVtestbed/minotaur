# Minotaur configuration

## Provided configurations

You can configure your own Minotaur soft-core design or build an existing one provided in this repository. Regardless, we suggest that you start off with one of these.

| Description    | Number of cores | DDR bank 0 cores | DDR bank 1 cores |
|-------------|-------------| -------------|-------------|
| mkbd-8.tcl | 8 | 8 | 0 |
| mkbd-16.tcl | 16 | 8 | 8 |

## Global address layout

DRAM is provided in two banks of 8GB on the board, and therefore is available at global address 0x50000000000 and 0x60000000000 respectively. CPU cores are associated with one of these banks, and the first 512MB of both banks are allocated for instructions. The subsequent 512MB chunks of memory are allocated to individual cores for their data area.

Consequently Minotaur operates in two NUMA style regions, the first NUMA region comprising the first 8GB DDR it's memory controller, and the second region the other 8GB DDR and it's memory controller. The ROM configuration stores, for each core, which bank it is connected to and it's data memory start address. This information is read by the host (in the Launchpad drivers) and used to correctly manage and marshal the cores. If one bank of memory is not connected to any cores then it is _dark_ from the perspective of the host, with its instruction area ignored.

| Description    | Size | Start address    |
|-------------|-------------| -------------|
| Core reset GPIO AXI | 512 bytes | 0x20100001000 |
| Configuration ROM | 4KB | 0x20100002000 |
| Shared core memory | 4MB | 0x20100400000 |

There is a control address space allocated for each core, which the host can use to interact with peripherals. These start at 0x20100003000 and are 0x1000 apart.

| Description    | Size | Relative address    | Absolute address (core 0) |
|-------------|-------------| -------------| -------------|
| GPIO        | 512 bytes | 0x0 | 0x20100003000 | 
| UART        | 128 bytes | 0x200 | 0x20100003200 | 
| Interrupt GPIO | 512 bytes | 0x400 | 0x20100003400 |

GPIO and Interrupt GPIO is handled via the AXI GPIO IP block, with GPIO providing 32 input and 32 output channels. The Interrupt GPIO provides 32 input channels (host to device). UART is handled by the AXI UARTLite IP block.

## Per core address layout

Each core has it's own private address space, and we follow the NEORV32's standard instruction-data layout.

| Description    | Size | Address    |
|-------------|-------------| -------------|
| Instruction DDR      | 512MB | 0x00000000 |
| Data DDR        | 512MB | 0x80000000 |
| Shared core URAM | 4MB | 0xC0000000 |
| Configuration ROM | 4KB | 0xC1000000 |

## Configuration ROM format

The configuration ROM uses the _.mem_ file format where values are grouped in 32-bits (four 8-bit Hex values). 

| <!-- -->    | <!-- -->    |
|-------------|-------------|
| AABBCCDD | _AA_ is the design code, _BB_ the number of cores, _CC_ clock frequency in MHz, _DD_ control BAR window id |
| 00000200 | Size of instruction space in MB |
| 00000200 | Size of per core memory space in MB |
| 00001000 | Size of shared memory in KB |
| AA020000 | _AA_ is the DDR Bank (00=0, 01=1) and the rest is the host-side starting data address for core 0 shifted left by 3 |
