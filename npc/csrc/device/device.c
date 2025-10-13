#include "mmio.h"

void init_serial();
void init_timer();


void init_device_mmio()
{
 init_serial();
 init_timer();
 printf("[Device] All MMIO devices initialized.\n");
}