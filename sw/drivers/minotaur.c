#include "minotaur.h"
#include <adxdma.h>
#include <stdio.h>
#include <stdlib.h>

#define ADXCALL(x) check_status(x, __LINE__)

#define PCI_VENDOR_ID_ALPHADATA                 0x4144
#define PCI_DEVICE_ID_ALPHADATA_GENERIC_XDMA    0x0980
#define PCI_SUBVENDOR_ID_ALPHADATA              0x4144
#define PCI_SUBDEVICE_ID_MINOTAUR               0x1000

#define CONTROL_BASE_ADDR ((uint64_t)0x20100000000ULL)
#define CORE_RESET_GPIO_OFFSET 0x1000
#define CONFIG_ROM_OFFSET 0x2000
#define CORE_START_OFFSET 0x3000
#define CORE_CTRL_ADDR_SIZE 0x1000
#define CORE_GPIO_OFFSET 0x0
#define CORE_UART_OFFSET 0x200
#define CORE_INTERRUPT_OFFSET 0x400

#define INSTRUCTION_MEM_ADDR 0x50000000000
#define INSTR_SIZE_MB 512
#define DATA_SIZE_PER_CORE_MB 512
#define BANK_SIZE_MB 8192 

#define CONFIG_ROM_SIZE 1

#define DDR_BANK_ONE 0x50000000000
#define DDR_BANK_TWO 0x60000000000

#ifndef FALSE
# define FALSE 0
#endif
#ifndef TRUE
# define TRUE 1
#endif

static LP_STATUS_CODE populate_configuration();
static int is_initialised();
static LP_STATUS_CODE get_configuration_data(char*);
static uint64_t get_core_data_start_address(int);
static uint64_t get_bank_starting_offset(int, int);
static int get_dram_bank(int);
static int check_status(ADXDMA_STATUS, int);

ADXDMA_HDMA readDMAEngine = ADXDMA_NULL_HDMA, writeDMAEngine=ADXDMA_NULL_HDMA;
ADXDMA_HWINDOW hWindow = ADXDMA_NULL_HWINDOW;
ADXDMA_HDEVICE hDevice = ADXDMA_NULL_HDEVICE;

unsigned int number_cores;
unsigned int core_active_bits;
unsigned int gpio_write_bits;
char initialised=0;

LP_STATUS_CODE minotaur_initialise() {  
  ADXDMA_DEVICE_INFO deviceInfo;
  
  // Open the device, get information and check the configuration
  if (!ADXCALL(ADXDMA_Open(0, FALSE, &hDevice))) return LP_ERROR;
  if (!ADXCALL(ADXDMA_GetDeviceInfo(hDevice, &deviceInfo))) return LP_ERROR;
  
  if (deviceInfo.HardwareID.Vendor != PCI_VENDOR_ID_ALPHADATA ||
      deviceInfo.HardwareID.Device != PCI_DEVICE_ID_ALPHADATA_GENERIC_XDMA ||
      deviceInfo.HardwareID.SubsystemVendor != PCI_SUBVENDOR_ID_ALPHADATA ||
      deviceInfo.HardwareID.SubsystemDevice != PCI_SUBDEVICE_ID_MINOTAUR) {
    fprintf(stderr, "FPGA PDI is not a minotaur based CPU\n");
    return LP_ERROR;
  }
  
  if (deviceInfo.NumH2C == 0 || deviceInfo.NumC2H == 0) {
    fprintf(stderr, "There must be at-least one DMA engine in each direction (H2C and C2H)\n");
    return LP_ERROR;
  }
  
  // Open DMA engines for reading and writing
  if (!ADXCALL(ADXDMA_OpenDMAEngine(hDevice, 0, FALSE, FALSE, 0, &readDMAEngine))) return LP_ERROR;
  if (!ADXCALL(ADXDMA_OpenDMAEngine(hDevice, 0, FALSE, TRUE, 0, &writeDMAEngine))) return LP_ERROR;
  
  if (!ADXCALL(ADXDMA_OpenWindow(hDevice, 0, FALSE, 0, &hWindow))) return LP_ERROR;
  
  core_active_bits=0x0;
  gpio_write_bits=0x0;
  
  // Need to set initialised here as stopping of all cores checks the flag
  initialised=1;
  
  if (minotaur_stop_allcores() != LP_SUCCESS) {
    minotaur_finalise();
    return LP_ERROR;
  }
  if (populate_configuration() != LP_SUCCESS) {
    minotaur_finalise();
    return LP_ERROR;
  }
  
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_get_configuration(struct device_configuration * device_config) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  
  device_config->name=(char*) malloc(10);
  sprintf(device_config->name, "Minotaur");
  device_config->number_cores=number_cores;
  device_config->architecture_type=LP_ARCH_TYPE_SHARED_INSTR_ONLY;
  
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_finalise() {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  initialised=0;
  if (!ADXCALL(ADXDMA_CloseDMAEngine(readDMAEngine))) return LP_ERROR;
  readDMAEngine=ADXDMA_NULL_HDMA;
  if (!ADXCALL(ADXDMA_CloseDMAEngine(writeDMAEngine))) return LP_ERROR;
  writeDMAEngine=ADXDMA_NULL_HDMA;
  if (!ADXCALL(ADXDMA_CloseWindow(hWindow))) return LP_ERROR;
  hWindow=ADXDMA_NULL_HWINDOW;
  if (!ADXCALL(ADXDMA_Close(hDevice))) return LP_ERROR;  
  hDevice=ADXDMA_NULL_HDEVICE;
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_reset() {
  if (is_initialised()) return LP_ERROR;
  
  ADXDMA_HDEVICE reset_device;
  if (!ADXCALL(ADXDMA_Open(0, FALSE, &reset_device))) return LP_ERROR;
  if (!ADXCALL(ADXDMA_Reset(reset_device))) return LP_ERROR;
  if (!ADXCALL(ADXDMA_Close(reset_device))) return LP_ERROR; 
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_write_core_instructions(int core_id, uint64_t address, const char* byte_data, uint64_t code_size) {
  // Not implemented as architecture is single instructions space shared between the cores
  return LP_NOT_IMPLEMENTED;
}

LP_STATUS_CODE minotaur_write_data(uint64_t address, const char* data, uint64_t code_size) {
  // Not implemented as architecture is separate data areas per core
  return LP_NOT_IMPLEMENTED;
}

LP_STATUS_CODE minotaur_read_data(uint64_t address, char* data, uint64_t code_size) {
  // Not implemented as architecture is separate data areas per core
  return LP_NOT_IMPLEMENTED;
}

LP_STATUS_CODE minotaur_start_core(int core_id) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  int core_bit=1 << core_id;
  if ((core_bit & core_active_bits) == 0) {
    // Core is not active, therefore need to start it
    core_active_bits=core_active_bits | core_bit;    
    if (!ADXCALL(ADXDMA_WriteWindow(hWindow, 0, 4, CORE_RESET_GPIO_OFFSET, sizeof(int), &core_active_bits, NULL))) return LP_ERROR;
    return LP_SUCCESS;
  } else {
    return LP_ALREADY_RUNNING;
  }
}

LP_STATUS_CODE minotaur_stop_core(int core_id) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  int core_bit=1 << core_id;
  if (core_bit & core_active_bits != 0) {
    // Core is active, therefore need to stop it
    core_active_bits = core_active_bits ^ core_bit;    
    if (!ADXCALL(ADXDMA_WriteWindow(hWindow, 0, 4, CORE_RESET_GPIO_OFFSET, sizeof(int), &core_active_bits, NULL))) return LP_ERROR;
    return LP_SUCCESS;
  } else {
    return LP_ALREADY_STOPPED;
  }
}

LP_STATUS_CODE minotaur_start_allcores() {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  // Set all cores to be active by driving areset high
  core_active_bits=(1 << number_cores) - (1 << 0);
  printf("0x%x\n", core_active_bits);
  if (!ADXCALL(ADXDMA_WriteWindow(hWindow, 0, 4, CORE_RESET_GPIO_OFFSET, sizeof(int), &core_active_bits, NULL))) return LP_ERROR;
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_stop_allcores() {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  // Set all cores to be inactive by driving areset low
  core_active_bits=0x0;  
  if (!ADXCALL(ADXDMA_WriteWindow(hWindow, 0, 4, CORE_RESET_GPIO_OFFSET, sizeof(int), &core_active_bits, NULL))) return LP_ERROR;
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_write_instructions(uint64_t address, const char * byte_data, uint64_t code_size) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  if (!ADXCALL(ADXDMA_WriteDMA(writeDMAEngine, 0, INSTRUCTION_MEM_ADDR + address, byte_data, code_size, NULL))) return LP_ERROR;
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_write_core_data(int core_id, uint64_t address, const char * byte_data, uint64_t data_size) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  uint64_t start_address=get_core_data_start_address(core_id);
  if (!ADXCALL(ADXDMA_WriteDMA(writeDMAEngine, 0, start_address + address, byte_data, data_size, NULL))) return LP_ERROR;
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_read_core_data(int core_id, uint64_t address, char * byte_data, uint64_t data_size) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  uint64_t start_address=get_core_data_start_address(core_id);
  if (!ADXCALL(ADXDMA_ReadDMA(readDMAEngine, 0,start_address + address, byte_data, data_size, NULL))) return LP_ERROR;
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_read_gpio(int core_id, int location, char * data) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  int gpio_data;
  uint64_t addr = CORE_START_OFFSET + (CORE_CTRL_ADDR_SIZE * core_id) + CORE_GPIO_OFFSET;
  if (!ADXCALL(ADXDMA_ReadWindow(hWindow, 0, 4, addr, sizeof(int), &gpio_data, NULL))) return LP_ERROR;  
  int bit_mask=1 << location;
  int gpio_bits=gpio_data & bit_mask;
  *data=gpio_bits >> location;
  
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_write_gpio(int core_id, int location, char setting) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  int bit_mask=1 << location;
  if (setting == 0) {
    gpio_write_bits= gpio_write_bits ^ bit_mask;
  } else if (setting == 1) {    
    gpio_write_bits= gpio_write_bits | bit_mask;
  } else {
    fprintf(stderr, "When writing GPIO provided setting of 0x%x but can only be 0 or 1\n", setting);
    return LP_ERROR;
  }
  uint64_t addr = CORE_START_OFFSET + (CORE_CTRL_ADDR_SIZE * core_id) + CORE_GPIO_OFFSET + 0x8;  
  if (!ADXCALL(ADXDMA_WriteWindow(hWindow, 0, 4, addr, sizeof(int), &gpio_write_bits, NULL))) return LP_ERROR;
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_uart_has_data(int core_id, int * has_data) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  char uart_status=0;
  uint64_t addr = CORE_START_OFFSET + (CORE_CTRL_ADDR_SIZE * core_id) + CORE_UART_OFFSET + 0x8;
  if (!ADXCALL(ADXDMA_ReadWindow(hWindow, 0, 1, addr, sizeof(char), &uart_status, NULL))) return LP_ERROR;  
  char recv_mask=0b1;
  *has_data=(uart_status & recv_mask) == 1;  
  return LP_SUCCESS;
}

LP_STATUS_CODE minotaur_read_uart(int core_id, char * data) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  int has_data=0;  
  if (minotaur_uart_has_data(core_id, &has_data) != LP_SUCCESS) return LP_ERROR;
  if (has_data) {
    char uart_data=0x0;
    uint64_t addr = CORE_START_OFFSET + (CORE_CTRL_ADDR_SIZE * core_id) + CORE_UART_OFFSET;
    if (!ADXCALL(ADXDMA_ReadWindow(hWindow, 0, 1, addr, sizeof(char), &uart_data, NULL))) return LP_ERROR;    
    *data=uart_data;    
    return LP_SUCCESS;
  } else {
    return LP_ERROR;
  }
}

LP_STATUS_CODE minotaur_write_uart(int core_id, char data) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  // TODO
}

LP_STATUS_CODE minotaur_raise_interrupt(int core_id, int irq) {
  if (!is_initialised()) return LP_NOT_INITIALISED;
  // TODO
}

struct device_drivers setup_minotaur_device_drivers() {
  struct device_drivers minotaur_device_drivers;
  minotaur_device_drivers.device_initialise=minotaur_initialise;
  minotaur_device_drivers.device_finalise=minotaur_finalise;
  minotaur_device_drivers.device_reset=minotaur_reset;  
  minotaur_device_drivers.device_get_configuration=minotaur_get_configuration;
  minotaur_device_drivers.device_start_core=minotaur_start_core;
  minotaur_device_drivers.device_start_allcores=minotaur_start_allcores;
  minotaur_device_drivers.device_stop_core=minotaur_stop_core;
  minotaur_device_drivers.device_stop_allcores=minotaur_stop_allcores;
  minotaur_device_drivers.device_write_instructions=minotaur_write_instructions;  
  minotaur_device_drivers.device_write_data=minotaur_write_data;
  minotaur_device_drivers.device_read_data=minotaur_read_data;
  minotaur_device_drivers.device_write_core_instructions=minotaur_write_core_instructions;
  minotaur_device_drivers.device_write_core_data=minotaur_write_core_data;
  minotaur_device_drivers.device_read_core_data=minotaur_read_core_data;
  minotaur_device_drivers.device_read_gpio=minotaur_read_gpio;
  minotaur_device_drivers.device_write_gpio=minotaur_write_gpio;  
  minotaur_device_drivers.device_uart_has_data=minotaur_uart_has_data;
  minotaur_device_drivers.device_read_uart=minotaur_read_uart;
  minotaur_device_drivers.device_write_uart=minotaur_write_uart;
  minotaur_device_drivers.device_raise_interrupt=minotaur_raise_interrupt;
  return minotaur_device_drivers;
}

static LP_STATUS_CODE populate_configuration() {
  char config_info[CONFIG_ROM_SIZE];
  if (get_configuration_data(config_info) != LP_SUCCESS) return LP_ERROR;
  number_cores=(int) config_info[0];
  return LP_SUCCESS;
}

static int is_initialised() {
  return initialised == 1;
}

static LP_STATUS_CODE get_configuration_data(char * data) {
  if (!ADXCALL(ADXDMA_ReadDMA(readDMAEngine, 0, CONTROL_BASE_ADDR + CONFIG_ROM_OFFSET, data, CONFIG_ROM_SIZE, NULL))) return LP_ERROR;
  return LP_SUCCESS;
}

static uint64_t get_core_data_start_address(int core_id) {
  int ddr_bank=get_dram_bank(core_id);
  uint64_t start_address=DDR_BANK_ONE ? ddr_bank == 0 : DDR_BANK_TWO;
  return start_address + get_bank_starting_offset(core_id, ddr_bank);
}

static uint64_t get_bank_starting_offset(int core_id, int bank) {
  if (bank == 0) {
    // If bank 0 then just offset by the instruction memory
    return (((uint64_t)(BANK_SIZE_MB * 1024) * 1024) * core_id) + (INSTR_SIZE_MB * 1024 * 1024);
  } else {
    // If bank 1 then need to figure out what my core ID is relative to the bank
    int mb_remaining_bank1=BANK_SIZE_MB-INSTR_SIZE_MB;
    int relative_bank_coreid=core_id - (mb_remaining_bank1 / DATA_SIZE_PER_CORE_MB);
    return ((uint64_t)(BANK_SIZE_MB * 1024) * 1024) * relative_bank_coreid;
  }
}

static int get_dram_bank(int core_id) {
  int mb_remaining_bank1=BANK_SIZE_MB-INSTR_SIZE_MB;
  int num_core_bank1=mb_remaining_bank1 / DATA_SIZE_PER_CORE_MB;
  return 0 ? core_id < num_core_bank1 : 1;
}

static int check_status(ADXDMA_STATUS status_code, int line_number) {
  if (status_code != ADXDMA_SUCCESS) {
    fprintf(stderr, "Error raised by ADX call at line %d, error code: %d\n", line_number, status_code);
    return 0;
  }
  return 1;
}
