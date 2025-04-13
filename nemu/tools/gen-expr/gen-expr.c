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
#include <ctype.h>

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

//生成一个数字
 void gen_num(){
  unsigned int num = choose(100);  // 生成 0 到 100 的随机数
  
  // 检查当前缓冲区中的上一个字符是否是除法运算符，如果是，避免生成0
  /*if (buf_index > 0 && buf[buf_index - 1] == '/') {
    num = choose(UINT8_MAX) + 1;  // 确保最小值为1，避免0作为除数
  }
  */
  buf_index += sprintf(buf + buf_index, "%u", num);

  // 处理数字0的特殊情况
  
/*
  if (num == 0) {
    buf[buf_index++] = '0';
    return;
  }

  // 计算数字位数和初始除数
  unsigned int divisor = 1;
  unsigned int temp = num;
  while (temp >= 10) { // 确定最高位的除数（100、10、1）
    divisor *= 10;
    temp /= 10;
  }

  // 从高位到低位逐位转换
  while (divisor > 0) {
    unsigned char digit = num / divisor; // 取当前位数字
    buf[buf_index++] = digit + '0';      // 转为ASCII字符
    num %= divisor;                      // 移除已处理的高位
    divisor /= 10;                       // 更新除数
  }
  */
 }

 // 生成一个随机操作符
void gen_rand_op() {
  char ops[4] = {'+','-','*','/'};
  buf[buf_index++] = ops[choose(4)];  // 选择随机运算符
}

 // 生成单个字符（用于括号）
void gen(char c) {
  buf[buf_index++] = c;
}

//生成随机表达式
static void gen_rand_expr() {

	if(buf_index > 65536){
    // 清空缓冲区并终止当前表达式生成
    buf_index = 0;
    return;
  }


  switch (choose(3)) {
    case 0: gen_num(); break;
    case 1: gen('('); gen_rand_expr(); gen(')'); break;
    default: 
    if (buf_index == 0) {
        gen_num();
      } else {
        gen_rand_expr();
        gen_rand_op();
        gen_rand_expr();
      }
    
  }
}

void convert_to_unsigned(const char *input, char *output) {
    const char *p = input;
    char *q = output;
    while (*p != '\0') {
        // Skip whitespaces
        while (isspace(*p)) p++;

        // Process digits and add 'U' suffix
        if (isdigit(*p)) {
            while (isdigit(*p)) {
                *q++ = *p++;
            }
            *q++ = 'U';
        } else {
            // Copy other characters directly
            *q++ = *p++;
        }
    }
    *q = '\0';
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
    //char code_1[65536] = {};
    //convert_to_unsigned(buf, code_1);

    sprintf(code_buf, code_format, buf);
    //sprintf(code_buf, code_format, code_1);

    FILE *fp = fopen("/tmp/.code.c", "w");
    //FILE *fp = fopen("./code.c", "w");
    if (fp == NULL) {
    perror("Error opening /tmp/.code.c");
    exit(EXIT_FAILURE);
}
    assert(fp != NULL);
    fputs(code_buf, fp);
    fclose(fp);

    int ret = system("gcc -Werror /tmp/.code.c -o /tmp/.expr"); 
    //int ret = system("gcc -Werror ./code.c -o ./expr");
    //int ret = system("gcc ./code.c -o ./expr -Wall -Werror -wdiv-by-zero 2> ./error.txt");
    //int ret = system("/usr/bin/gcc -Werror -nostdinc -I/usr/include /tmp/.code.c -o /tmp/.expr");
    if (ret != 0) continue; //编译失败就跳过，执行下一条指令

    fp = popen("/tmp/.expr", "r");
    /* if (!fp) {
      // popen 失败也跳过
      continue;
    }*/
    assert(fp != NULL);
    int64_t result;
    ret = fscanf(fp, "%ld", &result);//使用 fscanf 从管道中读取程序的输出，将其解析为一个int类型的整数。
    pclose(fp);
    //scan_ret = fscanf(fp, "%u", &result); 
    //int code_ret = pclose(fp); // 获取子进程退出状态

    // 如果能成功读到整数，并且子进程返回值为0，说明正常运行
    //if (scan_ret == 1 && code_ret == 0) {
      // 只有在没有产生运行时错误的情况下，才输出表达式和结果
      printf("%u %s\n", result, buf);
    //}

    //printf("%u %s\n", result, buf);
  }
  return 0;
}
