#include <am.h>
#include <klib-macros.h>
#include <stdio.h> 

extern char _heap_start;
int main(const char *args);

extern char _pmem_start;
#define PMEM_SIZE (128 * 1024 * 1024)
#define PMEM_END  ((uintptr_t)&_pmem_start + PMEM_SIZE)

Area heap = RANGE(&_heap_start, PMEM_END);
#ifndef MAINARGS
#define MAINARGS ""
#endif
static const char mainargs[] = MAINARGS;

void putch(char ch) {
}

void halt(int code) {
  asm volatile("ebreak");  // 发出 ebreak 指令中止仿真
  while (1);
}

void _trm_init() {
  unsigned int vendorid, marchid;
  asm volatile("csrr %0, mvendorid" : "=r"(vendorid));
  asm volatile("csrr %0, marchid"   : "=r"(marchid));

  printf("mvendorid = %u\n", vendorid);
  printf("marchid  = %u\n", marchid);  
  int ret = main(mainargs);
  halt(ret);
}
