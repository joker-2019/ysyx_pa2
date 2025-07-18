#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <regex.h>
#include <assert.h>
#include "Vysyx_22040080_cpu.h"
#include "Vysyx_22040080_cpu___024root.h"
#include "expr.h"

#define MAX_TOKENS 256

extern Vysyx_22040080_cpu___024root* rootp;  // 指向 top->rootp

enum {
  TK_NOTYPE = 256, //spaces
  TK_LT, TK_GT, // <  >
  TK_LE, TK_GE,  // <=  >= 
  TK_EQ, TK_NEQ, // ==  !=
  TK_AND, TK_OR, // && || 
  TK_NUM, TK_HEX, TK_REG, // 十进制  16进制 register
  TK_MINUS,TK_DEREF
};

typedef struct token {
  int type;
  char str[32];
} Token;

static struct rule {
  const char *regex;
  int token_type;
} rules[] = {
  {" +", TK_NOTYPE},    // spaces
  {"\\(", '('}, 
  {"\\)", ')'},
  {"\\*", '*'}, 
  {"/", '/'},
  {"\\+", '+'}, 
  {"-", '-'},
  {"<", TK_LT}, 
  {">", TK_GT}, 
  {"<=", TK_LE}, 
  {">=", TK_GE},
  {"==", TK_EQ}, 
  {"!=", TK_NEQ},
  {"&&", TK_AND},
  {"\\|\\|", TK_OR},      // 匹配逻辑或运算符 ||（正则中需转义为 \|\|，C字符串需双写反斜杠）
  {"0x[0-9a-fA-F]+",TK_HEX}, //匹配16进制
  {"[0-9]+", TK_NUM},  //匹配十进制
  {"\\$(\\$0|ra|sp|gp|pc|tp|t[0-6]|s(0|[1-9]|1[0-1])|a[0-7])", TK_REG}  // 匹配寄存器
};

#define NR_REGEX (sizeof(rules) / sizeof(rules[0]))
static regex_t re[NR_REGEX] = {};


void init_regex() {
  int i;
  char error_msg[128];
  int ret;

  for (i = 0; i < NR_REGEX; i ++) {
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
    if (ret != 0) {
      regerror(ret, &re[i], error_msg, 128);
      fprintf(stderr, "regex compilation failed: %s\n%s\n", error_msg, rules[i].regex);
      exit(1);
    }
  }

}

static int nr_token __attribute__((used))  = 0;
static Token *tokens;  // Declare as pointer, not array
uint32_t eval(int p, int q);

static bool make_token(char *e) {
  printf("expresion:%s\n", e);
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;

  while (e[position] != '\0') {
    // 初始化tokens数组
    if (tokens == NULL) {
    tokens = (Token *)malloc(MAX_TOKENS * sizeof(Token));
    }
    printf("position: %d, char: '%c'\n", position, e[position]);
    for (i = 0; i < NR_REGEX; i ++) {
      //printf("Trying rule[%d]: %s\n", i, rules[i].regex); // add debug output
      if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        position += substr_len;

        switch (rules[i].token_type) {
          case TK_NOTYPE : break;  //space

          case TK_NUM: 
          case TK_HEX: 
          case TK_REG:     
          assert(substr_len < 32 && "An out of buffer error occurred\n");
          strncpy(tokens[nr_token].str, substr_start, substr_len);
          tokens[nr_token].str[substr_len] = '\0';

          default:
          tokens[nr_token].type = rules[i].token_type;
          nr_token++;  
        }
        break;
      }
    }

    if (i == NR_REGEX) {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }   
  }
  // printf("Final position: %d, string length: %ld, nr_token: %d\n", position, strlen(e), nr_token);
  return true;
}


uint32_t expr(char *e) {
  // 处理末尾的换行符
  size_t len = strlen(e);
  if (len > 0 && e[len-1] == '\n') {
      e[len-1] = '\0';
      printf("Removed trailing newline\n");
  }

  if (!make_token(e)) {
    printf("make_token failed\n");
    free(tokens);   // 释放分配的内存
    exit(1);
  }

// 若 * 为第一个 token 或者 * 前一个 token 的类型为二元运算符（或者就是解引用，或者是左括号），那么这个 * 就是指针解引用。
  for(int i=0; i<nr_token; i++){
    if(i==0 || !(tokens[i-1].type==TK_NUM || tokens[i-1].type == ')' || tokens[i-1].type == TK_REG || tokens[i-1].type == TK_HEX) )
    {
      switch (tokens[i].type)
      {
        case '-':
        tokens[i].type = TK_MINUS; break;
        case '*':
        tokens[i].type = TK_DEREF; break;
        default:break;
      }
    }
  }
  return eval(0, nr_token-1);
}

int get_priority(int type) {
  switch (type) {
    case TK_OR:     return 1;  // ||
    case TK_AND:    return 2;  // &&
    case TK_EQ:     // == 
    case TK_NEQ:    return 3;  // !=
    case TK_GT: case TK_LT: case TK_GE: case TK_LE: return 4;
    case '+':       
    case '-':       return 5;  // + -
    case '*':       
    case '/':       return 6;  // * /
    case TK_DEREF:    
    case TK_MINUS:  return 7;  // 一元操作符（负号、解引用）
    
    default:        return -1; // 非运算符
  }
}

int find_major_op(int p, int q) {
  int pos = -1;     // 主运算符的位置
  int min_pri = 100; // 当前最低优先级
  int balance = 0;  // 括号嵌套深度

  for (int i = p; i <= q; i++) {
    if (tokens[i].type == '(') {
      balance++;  // 进入括号内部
    } else if (tokens[i].type == ')') {
      balance--;  // 离开括号
    }

    if (balance > 0) {
      continue;  // 括号内的运算符跳过
    }

    int pri = get_priority(tokens[i].type);  // 获取当前运算符优先级

    if (pri <= min_pri && pri != -1) {
      // 优先选择最右边的低优先级运算符（左结合性）
      min_pri = pri;
      pos = i;
    }
  }
  // printf("pos:%d\n",pos);
  return pos;  // 返回主运算符位置
}

bool check_parentheses(int p, int q) {
  if (tokens[p].type != '(' || tokens[q].type != ')') {
    return false;  // 开头和结尾不是括号，直接返回false
  }

  int balance = 0;
  for (int i = p; i <= q; i++) {
    if (tokens[i].type == '(') {
      balance++;  // 遇到左括号，+1
    } else if (tokens[i].type == ')') {
      balance--;  // 遇到右括号，-1
    }
    if (balance < 0)
    {
     return false;  
    }
    if (balance == 0 && i < q) {
      // 在q之前括号已经闭合，说明外层括号不完整
      return false;
    }
  }
  
  return true; // 如果balance为0，则括号完整包裹
}

uint32_t get_reg_val(const char *regname) {
  printf("get_reg_val: %s\n", regname);
  int idx = atoi(regname + 1); // skip 'x'
  return rootp->ysyx_22040080_cpu__DOT__regfile__DOT__rf[idx];
}

uint32_t eval(int p, int q){

  if (p > q) {
    /* Bad expression */
    fprintf(stderr, "Bad expression\n");
    exit(1);
  }
  else if (p == q) {
    /* Single token.
     * For now this token should be a number.
     * Return the value of the number.
     */
    if(tokens[p].type != TK_NUM && tokens[p].type != TK_HEX && tokens[p].type != TK_REG) 
		{
      fprintf(stderr, "Bad expression\n");
      exit(1);
		}
    if(tokens[p].type == TK_NUM){
      if (strncmp(tokens[p].str, "0x", 2) == 0 || strncmp(tokens[p].str, "0X", 2) == 0)
        return strtoul(tokens[p].str, NULL, 16);
      else
        return strtoul(tokens[p].str, NULL, 10);
    }
    else if(tokens[p].type == TK_HEX){
      return strtol(tokens[p].str,NULL,16);
    }
    else if(tokens[p].type == TK_REG){
      return get_reg_val(tokens[p].str);
    }
  }
  else if (check_parentheses(p, q)) {
    /* The expression is surrounded by a matched pair of parentheses.
     * If that is the case, just throw away the parentheses.
     */
    return eval(p + 1, q - 1);
  }else {
    int op = find_major_op(p,q);

    //printf("op: %d\n",op);
    uint32_t val1 = eval(p, op - 1); //左操作数
    uint32_t val2 = eval(op + 1, q); //右操作数

    switch(tokens[op].type){
        case '+': return val1 + val2;
        case '-': return val1 - val2;
        case '*': return val1 * val2;
        case '/': return val1 / val2;
        case TK_AND: return val1 && val2;
        case TK_OR:  return val1 || val2;
        case TK_EQ:  return val1 == val2;
        case TK_NEQ: return val1 != val2;
        default: 
        fprintf(stderr, "Unknown operator\n");
        exit(1);
      } 
      fprintf(stderr, "Invalid expression\n");
      exit(1);
  }
}

