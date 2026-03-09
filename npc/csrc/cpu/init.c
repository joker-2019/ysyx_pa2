#include <stdint.h>
#include "cpu.h"
#include "../Memory/memory.h"
#include <string.h>
#include <stdio.h>

static const uint32_t img[] = {
    // 地址 0x80000000（按小端存储）
    0x00000297,  // auipc t0,0
    0x12300093, // addi x1, x0, 0x123 000100100011 00000 000 000 01 0010011
    0x45600113, // addi x2, x0, 0x456
    0x78900193, // addi x3, x0, 0x789
    0x12345137, // lui x2, 0x12345  // x2 = 0x12345 << 12 = 0x12345000
    0x004001EF, // jal x3, 0x004   // 跳转到PC+4（下条指令）:0x8000000C, 同时x3 = PC+4 = 0x8000000C
    // 0x00018267, // jalr x4, x3, 0  // 跳转到x3 + 0 = 0x8000000C，形成跳转环
    0x00100073  // ebreak
};

static void restart() {
  /* Set the initial program counter. */
  cpu.pc = RESET_VECTOR;

  /* The zero register is always 0. */
  cpu.gpr[0] = 0;
}

void init_isa() {
  
  /* Load built-in image. */
  // memcpy(guest_to_host(RESET_VECTOR), img, sizeof(img));

  /* Initialize this virtual computer system. */
  restart();
  printf("PC initialized to 0x%08x\n", cpu.pc);
}