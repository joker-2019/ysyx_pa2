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

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include <string.h>

// this should be enough
static char buf[65536] = {};
static char code_buf[65536 + 128] = {}; // a little larger than `buf`
static char *code_format =
"#include <stdio.h>\n"
"int main() { "
"  unsigned result = %s; "
"  printf(\"%%u\", result); "
"  return 0; "
"}";
static int buf_index = 0;

// 生成一个小于 n 的随机数
unsigned int choose(unsigned int n) {
  return rand() % n;
}

static void gen_space() {
  int num_spaces = choose(2);  // 随机生成 0 到 1 个空格
  for (int i = 0; i < num_spaces; i++) {
    buf[buf_index++] = ' ';
  }
}

 void gen_num(){
  unsigned int num = choose(UINT8_MAX);  // 生成 0 到 999 的随机数
  
  // 检查当前缓冲区中的上一个字符是否是除法运算符，如果是，避免生成0
  /*if (buf_index > 0 && buf[buf_index - 1] == '/') {
    num = choose(UINT8_MAX) + 1;  // 确保最小值为1，避免0作为除数
  }
  */
  buf_index += sprintf(buf + buf_index, "%uU", num);
  gen_space();
 }

 // 生成一个随机操作符
void gen_rand_op() {
  char ops[] = "+-*/";
  buf[buf_index++] = ops[choose(4)];  // 选择随机运算符
}

 // 生成单个字符（用于括号）
void gen(char c) {
  buf[buf_index++] = c;
}

static void gen_rand_expr() {
 //if (strlen(buf) > 65536 - 10000 || depth > 15){
 if (strlen(buf) > 65536 - 10000){
      gen('(');
      gen_num();
      gen(')');  
      return;  // 防止继续递归
 }

  switch (choose(3)) {
    case 0: 
    gen_num();
    break;
    
    case 1: 
    gen('('); 
    gen_rand_expr(); 
    gen(')'); 
    break;

    default: 
    gen_rand_expr(); 
    gen_rand_op(); 
    gen_rand_expr();
    break;
  }
}

int main(int argc, char *argv[]) {
  int seed = time(0);
  srand(seed);
  int loop = 1;
  if (argc > 1) {
    sscanf(argv[1], "%d", &loop);
  }
  int i;
  for (i = 0; i < loop; i ++) {
    buf_index = 0;  // 清空索引
    memset(buf, 0, sizeof(buf));  // 清空字符串
    gen_rand_expr();

    sprintf(code_buf, code_format, buf);

    FILE *fp = fopen("/tmp/.code.c", "w");
    assert(fp != NULL);
    fputs(code_buf, fp);
    fclose(fp);

    //int ret = system("gcc /tmp/.code.c -o /tmp/.expr");
    int ret = system("gcc -O0 /tmp/.code.c -o /tmp/.expr");
    if (ret != 0) continue;

    fp = popen("/tmp/.expr", "r");
    /* if (!fp) {
      // popen 失败也跳过
      continue;
    }*/
    assert(fp != NULL);
    unsigned int result;
    //ret = fscanf(fp, "%d", &result);
    //pclose(fp);
    int scan_ret = fscanf(fp, "%u", &result);
    int code_ret = pclose(fp); // 获取子进程退出状态

    // 如果能成功读到整数，并且子进程返回值为0，说明正常运行
    if (scan_ret == 1 && code_ret == 0) {
      // 只有在没有产生运行时错误的情况下，才输出表达式和结果
      printf("%u %s\n", result, buf);
    }

    //printf("%u %s\n", result, buf);
  }
  return 0;
}
