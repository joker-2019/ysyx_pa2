/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <memory/host.h>
#include <memory/paddr.h>
#include <device/mmio.h>
#include <isa.h>
#include <cpu/iringbuf.h>
#include <generated/autoconf.h>
 
#if   defined(CONFIG_PMEM_MALLOC)
static uint8_t *pmem = NULL;
#else // CONFIG_PMEM_GARRAY
static uint8_t pmem[CONFIG_MSIZE] PG_ALIGN = {};
#endif

// uint8_t* guest_to_host(paddr_t paddr) { return pmem + paddr - CONFIG_MBASE; }
// paddr_t host_to_guest(uint8_t *haddr) { return haddr - pmem + CONFIG_MBASE; }
// ysyxSoC：MROM 和 SRAM 独立内存区域
uint8_t *mrom = NULL;
uint8_t *sram = NULL;
// ysyxSoC：FLASH 和 SRAM 独立内存区域
uint8_t *flash = NULL;

uint8_t* guest_to_host(paddr_t paddr) {
  // if (in_mrom(paddr))  return mrom + (paddr - MROM_BASE);
  if (in_sram(paddr))  return sram + (paddr - SRAM_BASE);
  if (in_flash(paddr))  return flash + (paddr - FLASH_BASE);
  return pmem + (paddr - CONFIG_MBASE);
}

paddr_t host_to_guest(uint8_t *haddr) {
  // if (haddr >= mrom && haddr < mrom + MROM_SIZE) return (paddr_t)(haddr - mrom) + MROM_BASE;
  if (haddr >= sram && haddr < sram + SRAM_SIZE) return (paddr_t)(haddr - sram) + SRAM_BASE;
  if (haddr >= flash && haddr < flash + FLASH_SIZE) return (paddr_t)(haddr - flash) + FLASH_BASE;
  return (paddr_t)(haddr - pmem) + CONFIG_MBASE;
}

static word_t pmem_read(paddr_t addr, int len) {
  word_t ret = host_read(guest_to_host(addr), len);
  return ret;
}

static void pmem_write(paddr_t addr, int len, word_t data) {
  host_write(guest_to_host(addr), len, data);
}

static void out_of_bound(paddr_t addr) {
  // panic("address = " FMT_PADDR " is out of bound of pmem [" FMT_PADDR ", " FMT_PADDR "] at pc = " FMT_WORD, addr, PMEM_LEFT, PMEM_RIGHT, cpu.pc);
  panic("address = " FMT_PADDR " is out of bound at pc = " FMT_WORD, addr, cpu.pc);
}

void init_mem() {
#if   defined(CONFIG_PMEM_MALLOC)
  pmem = malloc(CONFIG_MSIZE);
  assert(pmem);
#endif
  IFDEF(CONFIG_MEM_RANDOM, memset(pmem, rand(), CONFIG_MSIZE));
  // Log("physical memory area [" FMT_PADDR ", " FMT_PADDR "]"PMEM_LEFT,PMEM_RIGHT);
  Log("PSRAM area [" FMT_PADDR ", " FMT_PADDR "]", PMEM_LEFT, PMEM_RIGHT);

  // 分配 MROM 内存
  /* mrom = malloc(MROM_SIZE);
  assert(mrom);
  memset(mrom, 0, MROM_SIZE);
  Log("MROM area [" FMT_PADDR ", " FMT_PADDR "]", MROM_LEFT, MROM_RIGHT); */

  // 分配 FLASH 内存
  flash = (uint8_t *)malloc(FLASH_SIZE);
  assert(flash);
  memset(flash, 0, FLASH_SIZE);
  Log("FLASH area [" FMT_PADDR ", " FMT_PADDR "]", FLASH_LEFT, FLASH_RIGHT);

  // 分配 SRAM 内存
  sram = malloc(SRAM_SIZE);
  assert(sram);
  memset(sram, 0, SRAM_SIZE);
  Log("SRAM area [" FMT_PADDR ", " FMT_PADDR "]", SRAM_LEFT, SRAM_RIGHT);
}

word_t paddr_read(paddr_t addr, int len) {
  /* IFDEF(CONFIG_MTRACE, display_mread(addr, len)); //MTRACE_READ
  IFDEF(CONFIG_DTRACE, 
    if (!in_pmem(addr))
      printf("[DTrace] R @0x%08x (%dB) "
             ", name = %s\n",
             addr, len, map->name);
  );
  if (likely(in_pmem(addr))) {return pmem_read(addr, len);} */
  IFDEF(CONFIG_MTRACE, display_mread(addr, len));
  if (likely(in_pmem(addr))) { return pmem_read(addr, len);  }
  IFDEF(CONFIG_DEVICE, return mmio_read(addr, len));
  out_of_bound(addr);
  return 0;
}

void paddr_write(paddr_t addr, int len, word_t data) {
  /* IFDEF(CONFIG_MTRACE, display_mwrite(addr, len, data)); //MTRACE_WRITE
  IFDEF(CONFIG_DTRACE, 
    if (!in_pmem(addr))
      printf("[DTrace] W @0x%08x (%dB) "
             ", name = %s\n",
             addr, len, map->name);
  );  
  if (likely(in_pmem(addr))) { pmem_write(addr, len, data); return; } */
  IFDEF(CONFIG_MTRACE, display_mwrite(addr, len, data));
  if (likely(in_pmem(addr))) {
    // MROM 为只读，拒绝写入
   /*  if (in_mrom(addr)) {
      Log("Warning: attempt to write to MROM at " FMT_PADDR ", ignored", addr);
      return;
    } */
    // FLASH 为只读，拒绝写入
    if (in_flash(addr)) {
      Log("Warning: attempt to write to FLASH at " FMT_PADDR ", ignored", addr);
      return;
    }
    pmem_write(addr, len, data);
    return;
  }
  IFDEF(CONFIG_DEVICE, mmio_write(addr, len, data); return);
  out_of_bound(addr);
}
