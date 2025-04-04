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
#include <memory/paddr.h>

#define INITIAL_TOKENS_SIZE 256
#define TOKENS_SIZE_INCREMENT 256

enum {
  TK_NOTYPE = 256, //spaces
  TK_LT, TK_GT, // <  >
  TK_LE, TK_GE,  // <=  >= 
  TK_EQ, TK_NEQ, // ==  !=
  TK_AND, TK_OR, // && || 
  TK_NUM, TK_HEX, TK_REG, // 十进制  16进制 register

  /* TODO: Add more token types */
  //TK_POS,TK_NEG,TK_MULT, TK_DIV,      // + -  *  /
  //TK_LP, TK_RP,    //(    )
  TK_MINUS,TK_DEREF
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
  {"\\|\\|", TK_OR},      // 匹配逻辑或运算符 ||（正则中需转义为 \|\|，C字符串需双写反斜杠）
  {"[0-9]+", TK_NUM},  //匹配十进制
  {"0x[a-f,A-F,0-9]+",TK_HEX}, //匹配16进制
  {"\\$[a-z,0-9]+", TK_REG}   // 匹配寄存器
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
  unsigned int data;
  bool is_valid;

} Result;


//static Token tokens[32] __attribute__((used)) = {};
static int nr_token __attribute__((used))  = 0;
static int tokens_capacity = 0;
static Token *tokens;  // Declare as pointer, not array
Result eval(int p, int q);
word_t vaddr_read(vaddr_t addr, int len);

void resize_tokens_array() {
  if (tokens == NULL) {
    tokens = (Token *)malloc(INITIAL_TOKENS_SIZE * sizeof(Token));
    tokens_capacity = INITIAL_TOKENS_SIZE;
  } else if (nr_token >= tokens_capacity) {
    tokens_capacity += TOKENS_SIZE_INCREMENT;
    tokens = (Token *)realloc(tokens, tokens_capacity * sizeof(Token));
  }
}

static bool make_token(char *e) {
  //printf("expresion:%s\n", e);
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;

  while (e[position] != '\0') {

    resize_tokens_array(); // Ensure the tokens array has enough space
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

          case TK_NUM: case TK_HEX: case TK_REG:     
          Assert((substr_len < 32),"%s","An out of buffer error occurred\r\n");
          strncpy(tokens[nr_token].str, substr_start, substr_len);
          tokens[nr_token].str[substr_len] = '\0';
          break;

          default:
          tokens[nr_token].type = rules[i].token_type; 
          nr_token++;
              /*
              //TODO();
              //printf("token_type: %c\n",rules[i].token_type);
              tokens[nr_token].type = rules[i].token_type;
              strncpy(tokens[nr_token].str, substr_start, substr_len);
              tokens[nr_token].str[substr_len] = '\0';  // Ensure null termination
              nr_token++;
              */
        }
        break;

      }
    }

    if (i == NR_REGEX) {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }   
  }
  Log("Final position: %d, string length: %d, nr_token: %d", position, (int)strlen(e), nr_token);
  return true;
}


word_t expr(char *e, bool *success) {
  if (!make_token(e)) {
    *success = false;
    return 0;
  }

  /* TODO: Insert codes to evaluate the expression. */
  //TODO();

// 若 * 为第一个 token 或者 * 前一个 token 的类型为二元运算符（或者就是解引用，或者是左括号），那么这个 * 就是指针解引用。
  for(int i=0;i<nr_token;i++){
    if(  i==0 || (tokens[i-1].type!=TK_NUM && tokens[i-1].type != ')' && tokens[i-1].type != TK_REG && tokens[i-1].type != TK_HEX) )
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

  Result res = eval(0, nr_token-1);
  *success = res.is_valid;
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
    if (balance != 0)
    {
     return false;  
    }
    if (balance == 0 && i != q) {
      // 在q之前括号已经闭合，说明外层括号不完整
      return false;
    }
  }
  
  return true; // 如果balance为0，则括号完整包裹
}

int get_priority(int type) {
  switch (type) {
    /*
    case TK_OR:     return 1;  // ||
    case TK_AND:    return 2;  // &&
    case TK_EQ:     // == 
    case TK_NEQ:    return 3;  // !=
    case TK_GT: case TK_LT: case TK_GE: case TK_LE: return 4;
    case TK_POS:       
    case TK_NEG:       return 5;  // + -
    case TK_MULT:       
    case TK_DIV:       return 6;  // * /
    case TK_DEREF:    
    case TK_MINUS:  return 7;  // 一元操作符（负号、解引用）
    
    default:        return -1; // 非运算符
    */ 
    case TK_MINUS: case TK_DEREF: return 1; break; 
		case '*': case '/': return 2; break;
		case '+': case '-': return 3; break;
		case TK_GT: case TK_LT: case TK_GE: case TK_LE: return 4; break;
		case TK_EQ: case TK_NEQ: return 5; break;
		case TK_AND: return 6; break;
		case TK_OR: return 7; break;
		default: return -1;// 非运算符

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



//Result eval(int p, int q) {
Result eval(int p, int q){
  
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
    if(tokens[p].type != TK_NUM && tokens[p].type != TK_HEX && tokens[p].type != TK_REG) 
		{
			result.is_valid = false;
			return result;
		}
    if(tokens[p].type == TK_NUM){
      //printf("tokens[p].str:%s\n",tokens[p].str);
      result.data = strtol(tokens[p].str,NULL,10);
      result.is_valid = true;
      //return result;
      //printf("result.data:%d",result.data);
      //result.is_valid = true;
    }
    else if(tokens[p].type == TK_HEX){
      result.data = strtol(tokens[p].str,NULL,16);
      result.is_valid = true;
      //return result;
    }
    else if(tokens[p].type == TK_REG){
      bool success_reg = false;
      result.data = isa_reg_str2val(tokens[p].str, &success_reg);  //reg
      result.is_valid = success_reg;
      if(success_reg == false)
      {
        printf("Invalid register name\r\n");
      }
      //return result;
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
    if (op < 0) { // 未找到有效运算符
      //*success = false;
      result.is_valid = false;
      return result;
    }
    if(tokens[op].type == TK_DEREF)
    {
      Result def_res = eval(op+1,q);
      result.is_valid = def_res.is_valid;
      result.data = vaddr_read(def_res.data,4);
      return result;
    }
    else if(tokens[op].type == TK_MINUS){
      Result minus_res = eval(op+1,q);
      result.is_valid = minus_res.is_valid;
      result.data = -1 * minus_res.data;
      return result;
    }
    //printf("op: %d\n",op);
    //bool success1, success2;
    val1 = eval(p,op-1); //左操作数
    //printf("val1:%d\n",val1.data);
    val2 = eval(op+1,q); //右操作数
    //printf("val2:%d\n",val2.data);

    if(val1.is_valid && val2.is_valid) 
        result.is_valid= true;
      else {
        result.is_valid = false;
        return result;
      }
    switch(tokens[op].type){
        case '+':  result.data = val1.data +  val2.data;break;
        case '-':  result.data = val1.data -  val2.data;break;
        case '*': result.data = val1.data *  val2.data;break;
        case '/':
         if (val2.data == 0) {
          //*success = false;  // 检测到分母 = 0
          result.is_valid = false;
          return result;
        }    
        result.data = val1.data / val2.data; break;//result.data = val1.data /  val2.data; break;

        case TK_AND: result.data = val1.data && val2.data;break;
        case TK_OR:  result.data = val1.data || val2.data;break;
        case TK_EQ:  result.data = val1.data == val2.data;break;
        case TK_NEQ: result.data = val1.data != val2.data;break;
        default: Log("Invalid Operator\r\n");break;
      } 
    return result;
  
    
    /*if (!success2) { // 右操作数求值失败
      *success = false;
      return 0;
    }
     if (!success1) { // 左操作数失败，可能为单目运算符
      switch (tokens[op].type) {
        case TK_MINUS: return -val2;     // 负号（-5）
        case TK_POS: return val2;      // 正号（+5，通常省略）
        case TK_DEREF: return vaddr_read(val2, 4); // 解引用（*ptr）
        default: *success = false; return 0; // 非法单目运算符
      }
    }
    */
      
  }
}
