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
/* // 指向 UART 线路状态寄存器（读）和发送寄存器（写）
  volatile uint8_t *uart_lsr = (volatile uint8_t *)(UART_BASE + UART_LSR);
  volatile uint8_t *uart_tx  = (volatile uint8_t *)(UART_BASE + UART_TX);

  // 等待发送缓冲区为空（THRE 位为 1）
  while ((*uart_lsr & UART_LSR_THRE) == 0);

  // 发送字符到 UART
  *uart_tx = ch; */
  // putch(ch);
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
