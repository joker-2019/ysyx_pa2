#include "mmio.h"

void init_serial();
void init_timer();


void init_device()
{
 init_serial();
 init_timer();
 printf("[Device] All MMIO devices initialized.\n");
}