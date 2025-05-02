#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vysyx_22040080_cpu.h"
#include <stdio.h>
#include <stdlib.h>

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;

// 全局仿真终止标志
bool sim_finished = false;

static Vysyx_22040080_cpu* top;
void step_and_dump_wave(){
  top->eval();
  tfp->dump(contextp->time());
  contextp->timeInc(1);
}

void sim_init(){
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vysyx_22040080_cpu;
  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("dump.vcd");
}

void sim_exit(){
  step_and_dump_wave();
  if(tfp) tfp->close();
}

static void single_cycle() {
  top->clk = 0; top->eval(); step_and_dump_wave();
  top->clk = 1; top->eval(); step_and_dump_wave();
}

static void reset(int n) {
  top->rst = 1;
  while (n -- > 0) single_cycle();
  top->rst = 0;
}

// DPI-C 函数实现
extern "C" void ebreak_trigger() {
    sim_finished = true;  // 设置终止标志
}

int main() {
  sim_init();
  reset(10);
  while(!sim_finished){
    top->clk = !top->clk;
   	step_and_dump_wave();
    //single_cycle();
  }
  sim_exit();
  return 0;
}

