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

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <regex.h>

enum {
  TK_NOTYPE = 256, TK_LT, TK_GT, TK_LE, TK_EQ, TK_GE, TK_NEQ, TK_AND, TK_OR, TK_NUM, TK_REG, 

  /* TODO: Add more token types */
  TK_POS,TK_NEG,TK_DEREF
};

static struct rule {
  const char *regex;
  int token_type;
} rules[] = {

  /* TODO: Add more rules.
   * Pay attention to the precedence level of different rules.
   */

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
  {"\\|\\|", TK_OR},
  {"(0x)?[0-9]+", TK_NUM},
  {"\\$\\w+", TK_REG}
};

#define NR_REGEX ARRLEN(rules)

static regex_t re[NR_REGEX] = {};

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
  int i;
  char error_msg[128];
  int ret;

  for (i = 0; i < NR_REGEX; i ++) {
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
    if (ret != 0) {
      regerror(ret, &re[i], error_msg, 128);
      panic("regex compilation failed: %s\n%s", error_msg, rules[i].regex);
    }
  }
}

typedef struct token {
  int type;
  char str[32];
} Token;

typedef struct result{
  int data;
  bool is_valid;

} Result;

static Token tokens[32] __attribute__((used)) = {};
static int nr_token __attribute__((used))  = 0;
Result eval(int p, int q);

static bool make_token(char *e) {
  //printf("expresion:%s\n", e);
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;

  while (e[position] != '\0') {
    /* Try all rules one by one. */
    for (i = 0; i < NR_REGEX; i ++) {
      if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s",
            i, rules[i].regex, position, substr_len, substr_len, substr_start);

        position += substr_len;

        /* TODO: Now a new token is recognized with rules[i]. Add codes
         * to record the token in the array `tokens'. For certain types
         * of tokens, some extra actions should be performed.
         */

        switch (rules[i].token_type) {
          case TK_NOTYPE : break;  //space

          case TK_NUM:
            Assert((substr_len < 32),"%s","An out of buffer error occurred\r\n");
            tokens[nr_token].type = rules[i].token_type;
            nr_token++;
            strncpy(tokens[nr_token].str, substr_start, substr_len);
            tokens[nr_token].str[substr_len] = '\0';
            break;

            default: //TODO();
              printf("token_type: %c\n",rules[i].token_type);
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
    return true;
}


word_t expr(char *e, bool *success) {
  if (!make_token(e)) {
    *success = false;
    return 0;
  }
  *success = true;
  /* TODO: Insert codes to evaluate the expression. */
  //TODO();

  /*for(int i=0;i<nr_token;i++){
    if(  i==0 || !(tokens[i-1].type==TK_NUM 
               || tokens[i-1].type == ')' 
               || tokens[i-1].type == TK_REG)
        )
    {
      switch (tokens[i].type)
      {
        case '*':
        tokens[i].type = TK_DEF;
        break;
        case '-':
        tokens[i].type = TK_MINUS;
        break;
        default:break;
      }
    }
  }
  */
  Result res = eval(0, nr_token-1);
  return res.data;
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

    if (balance == 0 && i < q) {
      // 在q之前括号已经闭合，说明外层括号不完整
      return false;
    }
  }
  if (balance != 0)
  {
     return false;  
  }
  return true; // 如果balance为0，则括号完整包裹
}

int get_priority(int type) {
  switch (type) {
    case TK_OR:     return 1;  // ||
    case TK_AND:    return 2;  // &&
    case TK_EQ:     // == 
    case TK_NEQ:    return 3;  // !=
    case '+':       
    case '-':       return 4;  // + -
    case '*':       
    case '/':       return 5;  // * /
    /*case TK_DEF:    
    case TK_MINUS:  return 6;  // 一元操作符（负号、解引用）
    */
    default:        return -1; // 非运算符
  }
}

int find_major_op(int p, int q) {
  int pos = -1;     // 主运算符的位置
  int min_pri = 100; // 当前最低优先级（越小优先级越高）
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

  return pos;  // 返回主运算符位置
}



Result eval(int p, int q) {

  printf("p:%d,q:%d",p,q);

  Result result;
  Result val1;
  Result val2;
  int op = p;

  if (p > q) {
    /* Bad expression */
    result.is_valid = false;
    printf("Bad expression!!!\r\n");
    return result;
  }

  else if (p == q) {
    /* Single token.
     * For now this token should be a number.
     * Return the value of the number.
     */
    if(tokens[p].type == TK_NUM){
      result.data = strtol(tokens[p].str,NULL,10);
      //printf("result.data:%d",result.data);
      result.is_valid = true;
    }
    
    return result; 
  }
  else if (check_parentheses(p, q)) {
    /* The expression is surrounded by a matched pair of parentheses.
     * If that is the case, just throw away the parentheses.
     */
    return eval(p + 1, q - 1);
  }
  else {
    op = find_major_op(p,q);
    printf("op: %d",op);
    val1 = eval(p,op-1);
    val2 = eval(op+1,q);

    if(val1.is_valid && val2.is_valid) 
        result.is_valid= true;
      else {
        result.is_valid = false;
        return result;
      }
      switch(tokens[op].type){
        case '+':    result.data = val1.data +  val2.data;break;
        case '-':    result.data = val1.data -  val2.data;break;
        case '*':    result.data = val1.data *  val2.data;break;
        case '/':    result.data = val1.data /  val2.data;break;
        case TK_AND: result.data = val1.data && val2.data;break;
        case TK_OR:  result.data = val1.data || val2.data;break;
        case TK_EQ:  result.data = val1.data == val2.data;break;
        case TK_NEQ: result.data = val1.data != val2.data;break;
        default: Log("Invalid Operator\r\n");break;
      } 
    return result;
    }
  }
