# Minotaur configuration

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

Minotaur provides a split design
