#include <stdint.h>
#include <stdbool.h>
#include "verilated.h"

#ifndef __CPU_H__
#define __CPU_H__

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
  uint32_t gpr[32];
  uint32_t pc;
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