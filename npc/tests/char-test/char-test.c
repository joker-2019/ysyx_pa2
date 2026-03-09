#define UART_BASE 0x10000000L  // 串口基地址
#define UART_TX   0x00         // 发送数据寄存器偏移量

void _start() {
  *(volatile char *)(UART_BASE + UART_TX) = 'A';
  // *(volatile char *)(UART_BASE + UART_TX) = '\n';
  while (1);
}
