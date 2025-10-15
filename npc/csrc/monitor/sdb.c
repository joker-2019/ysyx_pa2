#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "../Memory/memory.h"
#include "../cpu/cpu.h"
#include "expr.h"
#include "watchpoint.h"
#include "readline/readline.h"
#include <readline/history.h>
#include "verilated.h"

static int is_batch_mode = false;

void init_monitor(int argc, char *argv[]);

// 命令函数
static int cmd_c(char *args) {
 // while (!contextp->gotFinish()) {
  while (!sim_finished) {
    exec_once();
  }
 printf("Simulation finished (via ebreak)\n");
 return 0;
}

// 返回0表示继续执行，-1表示退出
static int cmd_q(char *args) {
 // ebreak_trigger(); //触发ebreak
 return -1; // 返回-1表示退出
}

static int cmd_si(char *args) {
 int step;
 // printf("args: %s\n", args);
 if (args == NULL)
 {
   step = 1; // 默认单步执行一条指令
 }
 else{
   step = atoi(args); // 从命令行参数获取步数
   printf("step: %d", step);
   if (step <= 0){
     printf("Invalid step count: %s\n", args);
     return 0; // 返回0表示继续执行
   }
 }
  while (step-- > 0 && !sim_finished) {
    exec_once();
  }
 // printf("Executed %d steps.\n", step);
 return 0; // 返回0表示继续执行
}

// 打印寄存器状态
static int cmd_info(char *args) {
  // char *arg = strtok(NULL," ");
  // printf("%s\n", arg);
  if(args == NULL){
    printf("Missing parameters, Usage: info r(registers) or info w(watchpoints)\r\n");
  }else{
    if(!strcmp(args, "r")){
      print_registers();
    }
    else if (!strcmp(args, "w")){
      display_watchpoint();
    }else{
      printf("Usage: info r(registers) or info w(watchpoints)\r\n");
    }
  }
  return 0;
}

// 扫描内存
static int cmd_x(char *args) {
  char *saveptr;
  char *n = strtok_r(args, " ", &saveptr);      // 提取参数 N
  char *vaddr = strtok_r(NULL, " ", &saveptr);  // 提取地址表达式

  // 参数校验
  if (n == NULL || vaddr == NULL) {
    printf("Usage: x N EXPR\r\n");
    return -1;
  }
  // 解析 N（正整数）
  char *n_end;
  long num = strtol(n, &n_end, 10); // 十进制解析
  if (num <= 0 || *n_end != '\0') {
    printf("Invalid count: '%s' (must be positive integer)\r\n", n);
    return -1;
  }

  // 解析地址（十六进制）
  char *addr_end;
  uint32_t addr = strtol(vaddr, &addr_end, 16); // 十六进制解析
  if (addr_end == vaddr || *addr_end != '\0') {
    printf("Invalid address: '%s'\r\n", vaddr);
    return -1;
  }
 
  // 内存访问
  for (int i = 0; i < num; i ++) {
    // printf("0x%08x\r\n",vaadr_read(addr+i*4,4));
    uint32_t data = phys_mem_read(addr+i*4, 4); //待完善修改
    printf("0x%08x: 0x%08x\n", addr + i * 4, data);
  }
  return 0;
}

// 表达式求值
static int cmd_p(char *args) {
  printf("Evaluating expression: %s", args);
  uint32_t result = expr(args);
  if(result){
    printf("Result: 0x%08x\n", result);
  }else{
    printf("invalid expression");
  }
  return 0;
}

// 设置监视点
static int cmd_w(char *args) {
  if (!args) {
    printf("Usage: w EXPR\n");
    return 0;
  }
  uint32_t result = expr(args);
  if(!result){
    printf("invalid expression");
  }else{
    wp_watch(args, result);
  }
  return 0;
}

// 删除监视点
static int cmd_d(char *args) {
  char *arg = strtok(NULL, "");
  if (!arg) {
    printf("Usage: d N\n");
    return 0;
  }
  int no = strtol(arg, NULL, 10);
  wp_remove(no);
  return 0;
}

static int cmd_help(){
  printf(
    "help ---Display information about all supported commands\n"
    "c    ---Continue the execution of the program\n"
    "q    ---Exit NPC\n"
    "x    ---scan addr\n"
    "info ---print register\n"
    "si   ---print step\n"
    "p    ---Expression evaluation\n"
    "w    ---Usage: w EXPR. Watch for the variation of the result of EXPR, pause at variation point\n"
    "d    ---Usage: d N. Delete watchpoint of wp.NO=N\n"
  );
  return 0;
}

void sdb_set_batch_mode() {
  is_batch_mode = true;
}

// 命令分发函数
// 解析用户输入的命令并调用相应的处理函数
// 返回值：0表示继续执行，-1表示退出
int cmd_dispatch(char *line) {
  size_t len = strlen(line);
  // printf("line: %s\n", line);
  char *cmd = strtok(line, " ");
  //printf("cmd: %s\n", cmd);
  char *args = cmd + strlen(cmd) + 1;
  //printf("args:%s\n", args);
  if (args >= line + len)
    args = NULL;

  if (strcmp(cmd, "c") == 0) return cmd_c(args);
  if (strcmp(cmd, "q") == 0) return cmd_q(args);
  if (strcmp(cmd, "si") == 0) return cmd_si(args);
  if (strcmp(cmd, "info") == 0) return cmd_info(args);
  if (strcmp(cmd, "x") == 0) return cmd_x(args);
  if (strcmp(cmd, "p") == 0) return cmd_p(args);
  if (strcmp(cmd, "w") == 0) return cmd_w(args);
  if (strcmp(cmd, "d") == 0) return cmd_d(args);
  if (strcmp(cmd, "help") == 0) return cmd_help();

  printf("Unknown command '%s'\n", cmd);
  return 0;
  
}

static char* rl_gets() {
  static char *line_read = NULL;

  if (line_read) {
    free(line_read);
    line_read = NULL;
  }

  line_read = readline("(npc) ");

  if (line_read && *line_read) {
    add_history(line_read);
  }

  return line_read;
}

// 初始化 SDB（Simple Debugger）
// 主要包括初始化监视点池、正则表达式和模拟器
// 该函数通常在程序启动时调用一次
void init_sdb() {

 init_wp_pool();        // 初始化监视点池

 init_regex();          // 初始化正则表达式（用于表达式求值）
}

// 主循环函数
// 该函数会持续读取用户输入的命令并调用相应的处理函数
// 直到用户输入退出命令或发生错误
int sdb_mainloop(int argc, char *argv[]) {

  sim_init();          // 初始化模拟器

  init_monitor(argc, argv);     // 初始化监视器中的内容

  // reset(10);          // 重置模拟器状态

  init_sdb();          // 初始化 SDB

  char *line = NULL;
  // while (!contextp->gotFinish()) {
  while(!sim_finished){
    line = rl_gets();
    if (strlen(line) > 0){
      int success = cmd_dispatch(line);
      if (success < 0)
        break;
    }
  }

  step_and_dump_wave();

  sim_exit();          // 退出模拟器

  free(line);          // 释放输入行内存
 
  return 0;
}