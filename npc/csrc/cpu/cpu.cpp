  #include <stdio.h>
  #include "cpu.h"
  #include "verilated.h"
  #include "verilated_vcd_c.h"
  #include "Vysyx_22040080_cpu.h"
  #include "Vysyx_22040080_cpu___024root.h"
  #include "../utils/ftrace.h"
  #include "../utils/utils.h"
  #include "../utils/iringbuf.h"
  #include "../config/config.h"

  // 外部函数
  extern "C" void init_disasm(const char *triple);
  extern "C" void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);

#define OPCODE_JAL   0x6F
#define OPCODE_JALR  0x67

  // 全局状态
  bool sim_finished = false;
  static VerilatedContext *contextp = NULL;
  static VerilatedVcdC* tfp = NULL;
  static Vysyx_22040080_cpu* top = NULL;
  static Vysyx_22040080_cpu___024root* rootp = NULL;

  const char* reg_names[] = {
    "$0","ra","sp","gp","tp","t0","t1","t2",
    "s0","s1","a0","a1","a2","a3","a4","a5",
    "a6","a7","s2","s3","s4","s5","s6","s7",
    "s8","s9","s10","s11","t3","t4","t5","t6"
  };

  void step_and_dump_wave() {
    top->eval();
    tfp->dump(contextp->time());
    contextp->timeInc(1);
  }

  void sim_init() {
    contextp = new VerilatedContext;
    tfp = new VerilatedVcdC;
    top = new Vysyx_22040080_cpu;
    rootp = top->rootp;

    init_disasm("riscv32-pc-linux-gnu"); // 初始化反汇编器
    contextp->traceEverOn(true);
    top->trace(tfp, 0);
    tfp->open("dump.vcd");
  }

  void sim_exit() {
    step_and_dump_wave();
    if(tfp) tfp->close();
  }

  void reset(int n) {
    top->rst = 1;
    while (n-- > 0) exec_once();
    top->rst = 0;
  }

  
  bool is_jal(uint32_t inst) {
    uint32_t opcode = inst & 0x7F;
    return opcode == OPCODE_JAL;
  }

  bool is_jalr(uint32_t inst) {
    uint32_t opcode = inst & 0x7F;
    return opcode == OPCODE_JALR;
  }

  void exec_once() {
    // 一个周期 = clk 拉低 -> clk 拉高 -> eval 两次
    top->clk = 0; top->eval(); step_and_dump_wave();
    top->clk = 1; top->eval(); step_and_dump_wave();
    
    // if (sim_finished) return; //检查是否已经更新，若更新则执行结束

    // 跟踪 PC/指令（可选）itrace
    uint32_t pc = rootp->trace_pc;
    uint32_t inst = rootp->trace_instr;

    // 多个 trace 可以 hook 在这里
  #if ENABLE_ITRACE
    itrace_exec(pc, inst);     // 反汇编 + iringbuf + 打印
  #endif

  #if ENABLE_FTRACE
    if(is_jal(inst) || is_jalr(inst)){
      check_call_or_ret(pc);    // 函数调用跟踪
    }
    
  #endif

 /* char asm_buf[128] = {};
    disassemble(asm_buf, sizeof(asm_buf), pc, (uint8_t *)&inst, 4);
    iringbuf_add(pc, inst, asm_buf);

    printf("itrace: pc:0x%08x:   inst:0x%08x   %s\n", pc, inst, asm_buf); */
  }

  void print_registers() {
    for (int i = 0; i < 32; i++) {
      printf("x%-2d (%3s): 0x%08x\n", i, reg_names[i], rootp->ysyx_22040080_cpu__DOT__regfile__DOT__rf[i]);
    }
  }

  // DPI-C 函数
  extern "C" void ebreak_trigger() {
    sim_finished = true;
    uint32_t exit_code = rootp->ysyx_22040080_cpu__DOT__regfile__DOT__rf[10];
    if ((exit_code & 0xff) == 0) {
      printf("\33[1;32mHIT GOOD TRAP\33[0m\n");
    } else {
      printf("\33[1;31mHIT BAD TRAP (code = %u)\33[0m\n", exit_code);
    }
  }

  extern "C" uint32_t get_reg_val(const char *regname) {
    printf("get_reg_val: %s\n", regname);
    int idx = atoi(regname + 1); // skip 'x'
    return rootp->ysyx_22040080_cpu__DOT__regfile__DOT__rf[idx];
  }