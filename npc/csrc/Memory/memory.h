
#include <stdint.h>
#include "../utils/autoconf.h"

#ifndef __MEMORY_H__
#define __MEMORY_H__

#define PMEM_LEFT  ((uint32_t)CONFIG_MBASE)
#define PMEM_RIGHT ((uint32_t)CONFIG_MBASE + CONFIG_MSIZE - 1)
#define RESET_VECTOR (PMEM_LEFT + CONFIG_PC_RESET_OFFSET)

void init_mem();

uint32_t *guest_to_host(uint32_t paddr);

uint32_t mem_read(int pc);

uint32_t phys_mem_read(uint32_t addr);

// uint32_t dmem_read(uint32_t addr);

// void dmem_write(int addr, int data);

//void load_instructions(const char* file);

#endif
