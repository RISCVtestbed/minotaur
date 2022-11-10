#include <stdio.h>
#include <neorv32.h>

int main() {
	neorv32_rte_setup();
	neorv32_uart0_setup(9600, 0, 0);
	neorv32_uart0_printf("Hello world\n");	
	return 0;
}
