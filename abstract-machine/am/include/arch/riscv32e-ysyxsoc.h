#ifndef ARCH_H__
#define ARCH_H__

/* ysyxSoC 平台使用 RV32E，只有 16 个通用寄存器 */
#define NR_REGS 16

struct Context {
  uintptr_t gpr[NR_REGS];
  uintptr_t mcause;
  uintptr_t mstatus;
  uintptr_t mepc;
  void *pdir;
};

/* RV32E 下系统调用号放在 a5（gpr[15]） */
#define GPR1 gpr[15]
#define GPR2 gpr[0]
#define GPR3 gpr[0]
#define GPR4 gpr[0]
#define GPRx gpr[0]

#endif
