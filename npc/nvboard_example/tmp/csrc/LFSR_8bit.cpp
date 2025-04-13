#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VLFSR_8bit.h"
#include <stdio.h>
#include "nvboard.h"
#include <stdlib.h>

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;

static VLFSR_8bit *top;

void nvboard_bind_all_pins(VLFSR_8bit* top);

void step_and_dump_wave(){
  top->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}

void sim_init(){
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new VLFSR_8bit;
  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("dump.vcd");
}

void sim_exit(){
  step_and_dump_wave();
  tfp->close();
}

int main() {
  sim_init();
  nvboard_bind_all_pins(top);
  nvboard_init();
  top->clk = 0;
  top->reset = 1;

   while(1){
   	nvboard_update();
   	top->eval();
   	contextp->timeInc(1);
   }

  sim_exit();
  nvboard_quit();
}

