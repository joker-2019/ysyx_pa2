#include <am.h>
#include <klib-macros.h>
#include <klib.h>
// 线路状态寄存器中的发送保持寄存器为空标志
// UART 硬件参数（需与实际硬件匹配）
#define UART_BASE 0x10000000  // UART 基地址
#define UART_TX   0x00        // 发送缓冲区寄存器偏移（8位）
#define UART_LSR  0x05        // 线路状态寄存器偏移（8位）
#define UART_LSR_THRE 0x20    // 发送保持寄存器为空标志（可发送新字符）

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
/*   unsigned int vendorid, marchid;
  asm volatile("csrr %0, mvendorid" : "=r"(vendorid));
  asm volatile("csrr %0, marchid"   : "=r"(marchid));

  printf("mvendorid = %u\n", vendorid);
  printf("marchid  = %u\n", marchid);  */
  int ret = main(mainargs);
  halt(ret);
}
