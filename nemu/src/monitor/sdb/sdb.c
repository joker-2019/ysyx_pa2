/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <isa.h>
#include <cpu/cpu.h>
#include <readline/readline.h>
#include <readline/history.h>
#include "sdb.h"
#include "memory/vaddr.h"
#include "watchpoint.h"


static int is_batch_mode = false;

void init_regex();
void init_wp_pool();

/* We use the `readline' library to provide more flexibility to read from stdin. */
static char* rl_gets() {
  static char *line_read = NULL;

  if (line_read) {
    free(line_read);
    line_read = NULL;
  }

  line_read = readline("(nemu) ");

  if (line_read && *line_read) {
    add_history(line_read);
  }

  return line_read;
}

static int cmd_c(char *args) {
  cpu_exec(-1);
  return 1;
}


static int cmd_q(char *args) {
  nemu_state.state = NEMU_QUIT;
  return -1;
}

//单步执行
static int cmd_step(char *args){
  int step;
  if (args == NULL){
    step = 1;
  }else{
    sscanf(args, "%d", &step);
  }
  cpu_exec(step);
  return 0;
}

// 打印寄存器状态

static int cmd_printR(char *args){
  char *arg = strtok(NULL," ");
  //printf("%s\n", arg);
  if(arg == NULL)
  {
    printf("Missing parameters, Usage: info r(registers) or info w(watchpoints)\r\n");
  }else{
  if(!strcmp(arg, "r")){
    isa_reg_display();
  }else if(!strcmp(arg, "w")){
    //TODO
    display_watchpoint();
  }else{
      printf("Usage: info r(registers) or info w(watchpoints)\r\n");
    }

  }
  return 0;
  
}
// 扫描内存
static int cmd_x(char *args) {
  char *n = strtok(NULL," ");
  //printf("%s\n", n);
  char *vaddr = strtok(NULL," ");
  //printf("%s\n", vaddr);
  if(n == NULL || vaddr == NULL){
    printf("Usage: x N EXPR\r\n");
    return 0;
  }
  int num;
  vaddr_t addr;
  //unsigned int addr;
  sscanf(n,"%d",&num);
  sscanf(vaddr,"%x",&addr);
  for(int i=0;i<num;i++)
  {
    printf("0x%08x\r\n",vaddr_read(addr+i*4,4));
  }
  return 0;
  
}

// Expression evaluation
static int cmd_p(char *args) {
  bool success;
  printf("args:%s",args);
  word_t res = expr(args, &success);
  if (!success) {
    puts("invalid expression");
  } else {
    printf("%u\n", res);
  }
  return 0;
}

//设置监视点
static int cmd_w(char* args) {
  if (!args) {
    printf("Usage: w EXPR\n");
    return 0;
  }
  bool success;
  expr(args, &success);
  if (!success) {
    puts("invalid expression");
  } else {
    //wp_watch(args, res);
    new_wp(args);
  }
  return 0;
}

//删除监视点
static int cmd_d(char* args) {
  char *arg = strtok(NULL, "");
  if (!arg) {
    printf("Usage: d N\n");
    return 0;
  }
  int no = strtol(arg, NULL, 10);
  free_wp(no);
  return 0;
}

static int cmd_help(char *args);

static struct {
  const char *name;
  const char *description;
  int (*handler) (char *);
} cmd_table [] = {
  { "help", "Display information about all supported commands", cmd_help },
  { "c", "Continue the execution of the program", cmd_c },
  { "q", "Exit NEMU", cmd_q },
  { "x", "scan addr",cmd_x},
  { "info", "print register", cmd_printR},
  { "si", "print step", cmd_step},
  {"p", "Expression evaluation", cmd_p},
  {"w","Usage: w EXPR. Watch for the variation of the result of EXPR, pause at variation point", cmd_w },
  {"d", "Usage: d N. Delete watchpoint of wp.NO=N", cmd_d},
  /* TODO: Add more commands */

};

#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(char *args) {
  /* extract the first argument */
  char *arg = strtok(NULL, " ");
  int i;

  if (arg == NULL) {
    /* no argument given */
    for (i = 0; i < NR_CMD; i ++) {
      printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
    }
  }
  else {
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(arg, cmd_table[i].name) == 0) {
        printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
        return 0;
      }
    }
    printf("Unknown command '%s'\n", arg);
  }
  return 0;
}

void sdb_set_batch_mode() {
  is_batch_mode = true;
}

void sdb_mainloop() {
  if (is_batch_mode) {
    cmd_c(NULL);
    return;
  }

  for (char *str; (str = rl_gets()) != NULL; ) {
    char *str_end = str + strlen(str);

    /* extract the first token as the command */
    char *cmd = strtok(str, " ");
    if (cmd == NULL) { continue; }

    /* treat the remaining string as the arguments,
     * which may need further parsing
     */
    char *args = cmd + strlen(cmd) + 1;
    if (args >= str_end) {
      args = NULL;
    }

#ifdef CONFIG_DEVICE
    extern void sdl_clear_event_queue();
    sdl_clear_event_queue();
#endif

    int i;
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(cmd, cmd_table[i].name) == 0) {
        if (cmd_table[i].handler(args) < 0) { return; }
        break;
      }
    }

    if (i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
  }
}

void test_expr() {
  FILE *fp = fopen("/home/wp/ysyx-workbench/nemu/tools/gen-expr/input", "r");
  if (fp == NULL) perror("test_expr error");
 
  char *e = NULL;
  word_t correct_res;
  size_t len = 0;
  ssize_t read;
  bool success = false;
 
  while (true) {
    if(fscanf(fp, "%u ", &correct_res) == -1) break;
    read = getline(&e, &len, fp);
    e[read-1] = '\0';
    
    word_t res = expr(e, &success);
    
    assert(success);
    if (res != correct_res) {
      puts(e);
      printf("expected: %u, got: %u\n", correct_res, res);
      assert(0);
    }
  }
 
  fclose(fp);
  if (e) free(e);
 
  Log("expr test pass");
}


void init_sdb() {
  /* Compile the regular expressions. */
  init_regex();
  /* test math expression calculation */
  test_expr();
  /* Initialize the watchpoint pool. */
  init_wp_pool();
}
