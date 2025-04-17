#include <stdio.h>
#include <stdint.h>
#include <Vysyx_22040080_cpu.h> // Verilator生成的顶层模块
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Memory/memory.h"
#include <iostream>




VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;

static Vysyx_22040080_cpu* top;


void step_and_dump_wave(){
  contextp->timeInc(1);
  top->clk = 0;
  top->eval();
  // contextp->timeInc(1);
  tfp->dump(contextp->time());

  contextp->timeInc(1);
  top->clk = 1;
  top->eval();
  // contextp->timeInc(1);
  tfp->dump(contextp->time());
}

void sim_init(){
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vysyx_22040080_cpu;

  contextp->traceEverOn(true);
  top->trace(tfp, 99);
  tfp->open("wave.vcd");
}

void sim_exit(){
  step_and_dump_wave();
  tfp->close();
  delete contextp;
  delete tfp;
  delete top;
}



int main(int argc, char** argv) {
  printf("Main program starting...\n");
  sim_init();
  // nvboard_bind_all_pins(top);
  // nvboard_init();
  // 设置 rst = 1
  top->rst = 1;
  step_and_dump_wave();

  // 设置 rst = 0
  top->rst = 0;
  step_and_dump_wave();  // 再跑一个周期，保证 rst 下降沿处理完成

  while(!contextp->gotFinish()){
    printf(".............................\n");
    printf("循环 start ....\n");

    // 1. 取指令
    uint32_t pc = top->pc;  // 此时读取到 Verilog 更新后的 pc
    printf("[TRACE] PC = 0x%x\n", top->pc);

    uint32_t instr = pmem_read(pc);
    top->instruction = instr;
    printf("[TRACE] PC = 0x%x\n", instr);

    //2. 读数据存储器
    top->rdata = pmem_read(top->mem_addr); // raddr表示读取地

    // 3. 处理数据存储器访问
    if (top->wen) {  // 假设EXU输出mem_write_en信号
      pmem_write(top->mem_addr, top->wdata);
    }
    //top->rdata = pmem_read(top->waddr);  // 假设data_rdata是顶层输入信号
    //执行一个周期
    step_and_dump_wave();
    printf("end....\n");
  }

  sim_exit();
  // nvboard_quit();
  
  return 0;
}
