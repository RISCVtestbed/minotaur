#ifndef MINOTAUR_H_
#define MINOTAUR_H_

#include <stdint.h>
#include "launchpad_common.h"

LP_STATUS_CODE minotaur_initialise();
LP_STATUS_CODE minotaur_finalise();
LP_STATUS_CODE minotaur_reset();
LP_STATUS_CODE minotaur_get_configuration(struct device_configuration*);

LP_STATUS_CODE minotaur_start_core(int);
LP_STATUS_CODE minotaur_start_allcores();
LP_STATUS_CODE minotaur_stop_core(int);
LP_STATUS_CODE minotaur_stop_allcores();

LP_STATUS_CODE minotaur_write_instructions(uint64_t, const char*, uint64_t);
LP_STATUS_CODE minotaur_write_data(uint64_t, const char*, uint64_t);
LP_STATUS_CODE minotaur_read_data(uint64_t, char*, uint64_t);

LP_STATUS_CODE minotaur_write_core_instructions(int, uint64_t, const char*, uint64_t);
LP_STATUS_CODE minotaur_write_core_data(int, uint64_t, const char*, uint64_t);
LP_STATUS_CODE minotaur_read_core_data(int, uint64_t, char*, uint64_t);

LP_STATUS_CODE minotaur_read_gpio(int, int, char*);
LP_STATUS_CODE minotaur_write_gpio(int, int, char);
LP_STATUS_CODE minotaur_uart_has_data(int, int*);
LP_STATUS_CODE minotaur_read_uart(int, char*);
LP_STATUS_CODE minotaur_write_uart(int, char);
LP_STATUS_CODE minotaur_raise_interrupt(int, int);

struct device_drivers setup_minotaur_device_drivers();

#endif
