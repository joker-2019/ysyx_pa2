
#include <stdint.h>

#ifndef __ISA_RISCV_H__
#define __ISA_RISCV_H__

typedef struct {
  uint32_t gpr[32];  // 32个通用寄存器
  uint32_t pc;       // 程序计数器
} CPU_state;

extern CPU_state cpu;       //  全局变量声明


/* typedef struct {
  word_t gpr[MUXDEF(CONFIG_RVE, 16, 32)];
  vaddr_t pc;
} MUXDEF(CONFIG_RV64, riscv64_CPU_state, riscv32_CPU_state);

// decode
typedef struct {
  union {
    uint32_t val;
  } inst;
} MUXDEF(CONFIG_RV64, riscv64_ISADecodeInfo, riscv32_ISADecodeInfo);

#define isa_mmu_check(vaddr, len, type) (MMU_DIRECT) */

#endif
