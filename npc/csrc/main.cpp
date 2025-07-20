#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vysyx_22040080_cpu.h"
#include "Vysyx_22040080_cpu___024root.h"
#include <stdio.h>
#include <stdlib.h>
#include "Memory/memory.h"
#include "monitor/expr.h"
#include "monitor/watchpoint.h"
#include "utils/ftrace.h"
#include "utils/iringbuf.h"

// ANSI 彩色宏定义（可选）
#define ANSI_NONE          "\33[0m"
#define ANSI_FG_RED        "\33[1;31m" // 红色
#define ANSI_FG_GREEN      "\33[1;32m" // 绿色
#define ANSI_FMT(str, fmt) fmt str ANSI_NONE

extern "C" uint32_t* get_pmem_base(); // 获取物理内存基地址
extern "C" void init_disasm(const char *triple); // 初始化反汇编器
extern "C" void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte); // 反汇编函数
#define PMEM_BASE 0x80000000 // 假设物理内存基地址为 0x80000000

const char* reg_names[] = {
  "$0","ra","sp","gp","tp","t0","t1","t2",
  "s0","s1","a0","a1","a2","a3","a4","a5",
  "a6","a7","s2","s3","s4","s5","s6","s7",
  "s8","s9","s10","s11","t3","t4","t5","t6"
};
const char *file_elf = NULL; // ELF 文件路径

VerilatedContext *contextp = NULL;
VerilatedVcdC* tfp = NULL;

// 全局仿真终止标志
bool sim_finished = false;

static Vysyx_22040080_cpu* top;

// 定义 rootp
Vysyx_22040080_cpu___024root* rootp = nullptr; // 必须加上这句，把 rootp 指向 top->rootp


// itrace 打印当前指令和 PC
void trace_and_step() {
  uint32_t pc = rootp->trace_pc;
  uint32_t inst = rootp->trace_instr;

  char asm_buf[128] = {};
  disassemble(asm_buf, sizeof(asm_buf), pc, (uint8_t *)&inst, 4); // 调用 NEMU 提供的反汇编工具
  // 添加到环形缓冲区
  iringbuf_add(pc, inst, asm_buf); // 添加指令到环形缓冲区
  // 当指令出现错误时，打印环形缓冲区的指令 借助实现different test来实现
  /* difftest(&decode, pc);
     if (程序状态编程意外终止状态) {
      printf_inst_error(error_pc); // 打印错误指令
    } */
  printf("pc:0x%08x:   inst:0x%08x   %s\n", pc, inst, asm_buf);
}

void step_and_dump_wave(){
  top->eval();
  tfp->dump(contextp->time());
  contextp->timeInc(1);
}

void sim_init(){
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vysyx_22040080_cpu;
  rootp = top->rootp; // 在 sim_init() 中初始化 rootp
  init_regex(); // 初始化正则表达式
  init_wp_pool(); // 初始化监视点池
  init_disasm("riscv32-pc-linux-gnu"); // 初始化反汇编器
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
  trace_and_step(); // 打印当前指令和 PC
}

static void reset(int n) {
  top->rst = 1;
  while (n -- > 0) single_cycle();
  top->rst = 0;
}

// DPI-C 函数实现
extern "C" void ebreak_trigger() {
  // <模块名>__DOT__<子模块名>__DOT__<信号名>  __DOT__ 是 Verilator 用来连接模块层次的符号（代表 Verilog 中的 .）
  int exit_code = top->rootp->ysyx_22040080_cpu__DOT__regfile__DOT__rf[10];  // 假设 x10 寄存器存储退出代码 x10 = a0
  if(exit_code == 0) {
    printf(ANSI_FMT("HIT GOOD TRAP\n", ANSI_FG_GREEN));
  } else {
    printf(ANSI_FMT("HIT BAD TRAP (code = %d)\n", ANSI_FG_RED), exit_code);
  }
  sim_finished = true;  // 设置终止标志
}

// 打印寄存器状态
void print_registers() {
  for(int i = 0; i < 32; i++) {
  printf("x%-2d (%3s): 0x%08x\n", i, reg_names[i], top->rootp->ysyx_22040080_cpu__DOT__regfile__DOT__rf[i]);
  }
}

int main(int argc, char **argv) {
  printf("Welcome to NPC\n");
  // 简单命令行参数解析 -e xxx.elf
  for (int i = 1; i < argc; i++) {  // 
    if (strcmp(argv[i], "-e") == 0 && i + 1 < argc) {
      file_elf = argv[++i]; // 提取"-e"后的参数作为文件名
      printf("ELF file set to: %s\n", file_elf);
    }
  }

  sim_init();
  if (file_elf) {
    parse_elf(file_elf);  // 加载 ELF 符号
    printf("ELF symbols loaded from: %s\n", file_elf);
  }
  reset(10);

  uint32_t* pmem = get_pmem_base(); // 获取物理内存基地址
  char cmd[128]; // 用于读取用户输入的命令

  while (!sim_finished){
    printf("(NPC)");
    if(fgets(cmd, sizeof(cmd), stdin) == NULL) break; // 读取用户输入
    if(strcmp(cmd, "si\n") == 0){
      single_cycle(); // 执行单周期

    }else if(strncmp(cmd, "info ", 5) == 0){
      if(strcmp(cmd + 5, "r\n") == 0) {
      // 打印寄存器状态
      print_registers();
      }
      if(strcmp(cmd + 5, "w\n") == 0) {
      // 打印监视点状态
      display_watchpoint();
      }
    }else if(strncmp(cmd, "x ", 2) == 0){
      // 扫描内存
      int addr, len;
      sscanf(cmd + 2, "%i %i", &addr, &len); // 解析地址和长度  %i 可以自动识别 0x 开头的十六进制，也支持十进制
      for(int i = 0; i < len; i += 4) {
      uint32_t data = *(uint32_t*)&pmem[addr + i - PMEM_BASE];
      printf("0x%08x: 0x%08x\n", addr + i, data);
      }

    }else if (strncmp(cmd, "p ", 2) == 0){ // 表达式求值
      // printf("Evaluating expression: %s", cmd + 2);
      uint32_t result = expr(cmd + 2);
      printf("Result: 0x%08x\n", result);
    }else if (strncmp(cmd, "w ", 2) == 0){ // 设置监视点
      uint32_t result = expr(cmd + 2);
      if(!result){
        printf("invalid expression");
      }else{
        // 设置监视点
        wp_watch(cmd + 2, result);
      }
    }else if(strncmp(cmd, "d ", 2) == 0){ // 删除断点
      int wp_id;
      sscanf(cmd + 2, "%d", &wp_id); // 解析监视点 ID
      if(wp_id < 0 || wp_id >= wp_get_count()) {
        printf("Invalid watchpoint ID\n");
        continue;
      }
      wp_remove(wp_id); // 删除监视点

    }else if (strcmp(cmd, "help\n") == 0){
      printf("Commands:\n");
      printf("  si - Step one instruction\n");
      printf("  reg - Print register status\n");
      printf("  x <addr> <len> - Examine memory\n");
      printf("  q - Quit simulation\n");
    }

    else if (strcmp(cmd, "q\n") == 0){
      break; // 退出仿真
    }
    top->clk = !top->clk;
    step_and_dump_wave();
    //single_cycle();
  }
  sim_exit();
  return 0;
}

