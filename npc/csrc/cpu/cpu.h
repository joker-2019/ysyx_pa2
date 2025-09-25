#include <stdint.h>
#include <stdbool.h>
#include "verilated.h"

#ifndef __CPU_H__
#define __CPU_H__

#ifdef __cplusplus
extern "C" {
#endif

typedef uint32_t paddr_t;
typedef uint32_t word_t;

//SR系统寄存器结构体
typedef struct{
  paddr_t mepc;    // 保存异常发生时的 PC
  word_t mcause;   // 异常原因码（如中断号、异常类型）
  paddr_t mtvec;   // 异常向量表基地址（异常处理程序入口）
  word_t mtval;    // 异常附加信息（如错误地址、指令码等）
  word_t mstatus;  // 机器态状态寄存器（0x300）
  word_t mvendorid; // 厂商 ID (0xF11)
  word_t marchid;  // 架构 ID (0xF12)
  // 可扩展其他系统寄存器
} riscv_system_regs;

typedef struct {
  uint32_t gpr[32];
  uint32_t pc;
  riscv_system_regs sr; //SR系统寄存器
} CPU_state;

extern CPU_state cpu;  // 声明cpu为外部变量

extern bool sim_finished;  //  让 c 命令使用

extern VerilatedContext *contextp;

void sim_init();

void sim_exit();

void reset(int n);

void step_and_dump_wave();

void exec_once();          //  在 sdb.c 中调用

void print_registers();    //  在 sdb.c 中调用

uint32_t get_reg_val(const char *regname);  // C 函数可以调用

void ebreak_trigger();                      // C 函数可以调用

void single_cycyle();     //初始化单周期执行

void update_register(CPU_state *cpu); // 同步寄存器
// void update_register();

void check_register(CPU_state *cpu); //检查寄存器

// void reg_write_commit(int waddr, int wdata); // DPI-C调用的rtl中的代码方法

bool check_regs(CPU_state *dut, CPU_state *ref);
#ifdef __cplusplus
}
#endif

#endif