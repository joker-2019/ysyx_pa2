#include "verilated.h"
#include "verilated_vcd_c.h"
#include <stdio.h>
#include "nvboard.h"
#include <stdlib.h>

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static Vmux41* top;
void nvboard_bind_all_pins(Vmux41* top);

void step_and_dump_wave(){
  top->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}
void sim_init(){
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vmux41;
  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("dump.vcd");
}

void sim_exit(){
  step_and_dump_wave();
  tfp->close();
}
int main(){
  top = new Vmux41;
  sim_init();
  nvboard_bind_all_pins(top);
  nvboard_init();
  top->Y=0b00;  top->X0=0b11;  top->eval(); step_and_dump_wave();  // 运行一个时间步长并记录波形
  	        top->X0=0b00;  top->eval(); step_and_dump_wave();  //00
		
  top->Y=0b01;  top->X1=0b10;  top->eval(); step_and_dump_wave();
                top->X1=0b01;  top->eval(); step_and_dump_wave();  //01

  top->Y=0b10;  top->X2=0b11;  top->eval(); step_and_dump_wave();
                top->X2=0b10;  top->eval(); step_and_dump_wave();  //10

  top->Y=0b11;  top->X3=0b00;  top->eval(); step_and_dump_wave();  
                top->X3=0b11;  top->eval(); step_and_dump_wave();  //11
  sim_exit(); 
  nvboard_quit();
}
