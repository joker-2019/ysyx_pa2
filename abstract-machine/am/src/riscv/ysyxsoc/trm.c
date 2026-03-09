#include <am.h>
#include <klib-macros.h>
#include <klib.h>

/* ysyxSoC 设备地址 */
#define UART16550_BASE  0x10000000u   /* UART16550 基地址 */
#define UART_THR        (*(volatile uint8_t *)(UART16550_BASE + 0))  /* 发送保持寄存器THR  偏移 0 把内存地址转换成“可读写的8位寄存器”并访问它*/  
#define UART_LSR        (*(volatile uint8_t *)(UART16550_BASE + 5))  /* 线路状态寄存器 偏移 5，用来查 UART 状态*/
#define UART_LSR_THRE   (1 << 5)                                     /* 发送保持寄存器空  1 << 5 = 二进制 0010 0000，对应十进制 32  LSR 的第5位（bit5）：THRE 标志（1表示THR空，0表示忙）*/

/* 堆区：位于 SRAM 内，由链接脚本给出起止符号 */
extern char _heap_start;
extern char _heap_end;

int main(const char *args);

Area heap = RANGE(&_heap_start, &_heap_end);

#ifndef MAINARGS
#define MAINARGS ""
#endif
static const char mainargs[] = MAINARGS;

/* putch：等待 UART TX FIFO 空后写入字符 */
void putch(char ch) {
   // 第一步：等待 UART 发送寄存器空（THRE 位为 1） 若按位相与，得到 ！0 一直等下去，直到THRE为1，此时跳出循环
  while (!(UART_LSR & UART_LSR_THRE));
  // 第二步：把字符写入发送寄存器，触发 UART 发送
  UART_THR = (uint8_t)ch;
}

/* halt：通过 ebreak 让仿真环境结束仿真 */
void halt(int code) {
  asm volatile("ebreak");
  while (1);
}

void _trm_init() {
  int ret = main(mainargs);
  halt(ret);
}
