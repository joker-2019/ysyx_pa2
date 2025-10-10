
#include <stdint.h>
#include "../utils/autoconf.h"

#ifndef __MEMORY_H__
#define __MEMORY_H__

#define PMEM_LEFT  ((uint32_t)CONFIG_MBASE)
#define PMEM_RIGHT ((uint32_t)CONFIG_MBASE + CONFIG_MSIZE - 1)
#define RESET_VECTOR (PMEM_LEFT + CONFIG_PC_RESET_OFFSET)

extern uint8_t pmem[CONFIG_MSIZE];

void init_mem();

// void init_clock();

// uint32_t *guest_to_host(uint32_t paddr);

uint8_t *guest_to_host(uint32_t paddr);

uint32_t mem_read(int pc);

uint32_t phys_mem_read(uint32_t addr, int len);

uint32_t lw_mem_read(int addr, int len);

void sw_mem_write(int addr, int len, int data);

#endif
