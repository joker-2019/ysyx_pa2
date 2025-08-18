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

#ifndef __ISA_RISCV_H__
#define __ISA_RISCV_H__

#include <common.h>

//SR系统寄存器结构体
typedef struct{
  vaddr_t mepc;    // 保存异常发生时的 PC
  word_t mcause;   // 异常原因码（如中断号、异常类型）
  vaddr_t mtvec;   // 异常向量表基地址（异常处理程序入口）
  word_t mtval;    // 异常附加信息（如错误地址、指令码等）
  // 可扩展其他系统寄存器
} riscv_system_regs;

typedef struct {
  word_t gpr[MUXDEF(CONFIG_RVE, 16, 32)]; // GPR通用寄存器
  vaddr_t pc; // PC
  riscv_system_regs sr; //SR系统寄存器
} MUXDEF(CONFIG_RV64, riscv64_CPU_state, riscv32_CPU_state);

// decode
typedef struct {
  union {
    uint32_t val;
  } inst;
} MUXDEF(CONFIG_RV64, riscv64_ISADecodeInfo, riscv32_ISADecodeInfo);

#define isa_mmu_check(vaddr, len, type) (MMU_DIRECT)

#endif
