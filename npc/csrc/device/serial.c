#include "mmio.h"
#include <stdio.h>

#define SERIAL_ADDR  0x10000000 // 0xa00003f8u 
#define SERIAL_SIZE 8
#define CH_OFFSET   0

static uint8_t serial_space[SERIAL_SIZE];

static void serial_io_handler(uint32_t offset, int len, bool is_write) {
    assert(len == 1);
    if (is_write && offset == CH_OFFSET) {
        char ch = (char)serial_space[0];
        putchar(ch);
        fflush(stdout);
        printf("[UART] write char = '%c' (0x%02x)\n", (ch >= 32 && ch <= 126) ? ch : '.', ch);
    }
}

void init_serial() {
  add_mmio_map("serial", SERIAL_ADDR, SERIAL_SIZE, serial_space, serial_io_handler);
  printf("[UART] Initialized at 0x%08x\n", SERIAL_ADDR);
}