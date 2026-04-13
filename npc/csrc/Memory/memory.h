
#include <stdint.h>
#include "../utils/autoconf.h"

#ifndef __MEMORY_H__
#define __MEMORY_H__

#define PMEM_LEFT  ((uint32_t)CONFIG_MBASE)
#define PMEM_RIGHT ((uint32_t)CONFIG_MBASE + CONFIG_MSIZE - 1)
// MROM_BASE 由 autoconf.h 统一定义，此处不重复定义
// #define RESET_VECTOR MROM_BASE
#define RESET_VECTOR FLASH_BASE

extern uint8_t pmem[CONFIG_MSIZE];

void init_mem();

// void init_clock();

// uint32_t *guest_to_host(uint32_t paddr);

uint8_t *guest_to_host(uint32_t paddr);

// uint32_t mem_read(int pc);

uint32_t phys_mem_read(uint32_t addr, int len);

uint32_t pmem_read(int addr, int len);

void pmem_write(int addr, int len, int data);

void device_update();

void flash_read(int32_t addr, int32_t *data);

void mrom_read(int32_t addr, int32_t *data);

long load_mrom(const char *filename);

long load_flash(const char *filename);

void *pmem_addr(uint32_t addr);

int is_valid_address(uint32_t addr);

#endif
