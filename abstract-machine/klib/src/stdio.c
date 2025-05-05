#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)


/*
static int print_int(int num, int base){
    char buffer[32]; //构建存储字符数组
    int i = 0, count = 0;
    int is_uppercase = (base < 0);  // 负数进制表示使用大写
    unsigned int n = (num < 0) ? -num : num;  // 转换为无符号数处理

      // 处理负号（仅对十进制有效）
    if (num < 0 && (base == 10 || base == -10)) {
        putch('-');
        count++;
    }

    // 处理零值
    if (n == 0) {
        putch('0');
        return 1;
    }
    // 计算进制的绝对值
    int abs_base = (base < 0) ? -base : base;

    // 检查进制合法性（可选）
    if (abs_base < 2 || abs_base > 36) {
        return -1;  // 非法进制，返回错误
    }

    //处理非0和非负数的值
    while(n > 0){
      int digital = n % base;
       // 转换为字符：0-9直接转换，10+根据大小写规则转换为A-F或a-f
      if(digital < 10){
        buffer[i] = digital + '0';

      }else{                              //大于10的数用字母表示
        if(is_uppercase > 0){
          //用大写表示10-16(A-F)
          buffer[i] = 'a' + digital - 10; //正数用小写字母表示
        }else{
          buffer[i] = 'A' + digital - 10; //负数用大写字母表示
        }
      }
      i++;
      n /= base; 
    }

    // 逆序输出字符数组（正确顺序）
    for (int j = i - 1; j >= 0; j--) {
        putch(buffer[j]);
        count++;
    }
    return count;
}
*/

// 输出函数类型定义（回调函数）
typedef void (*output_func)(void*, char);

// 核心整数转换函数（复用逻辑）
static int print_number(output_func out, void* ctx, int num, int base) {
    char buffer[32];
    int i = 0, count = 0;
    int is_uppercase = (base < 0);  // 负数进制表示使用大写
    unsigned int n = (num < 0) ? -num : num;
    
    if (num < 0 && base == 10) {
        out(ctx, '-');
        count++;
    }
    
    if (n == 0) {
        out(ctx, '0');
        return 1;
    }
    
    while (n > 0) {
        int digit = n % base;
        buffer[i++] = (digit < 10) ? digit + '0' : (is_uppercase ? 'A' : 'a') + digit - 10;
        n /= base;
    }
    
    for (int j = i - 1; j >= 0; j--) {
        out(ctx, buffer[j]);
        count++;
    }
    
    return count;
}

// 字符串处理函数（复用逻辑）
static int print_string(output_func out, void* ctx, const char* s) {
    int count = 0;
    if (!s) s = "(null)";  // 处理NULL字符串
    
    while (*s) {
        out(ctx, *s++);
        count++;
    }
    return count;
}

// sprintf 的输出回调函数：写入内存缓冲区
static void sprintf_output(void* ctx, char c) {
    char** buf = (char**)ctx;
    **buf = c;
    (*buf)++;
}

// printf 的输出回调函数：输出到标准设备
static void printf_output(void* ctx, char c) {
    // 实际实现中可能调用串口、LCD等输出函数
    // 示例：uart_send_char(c);
    (void)ctx; // 忽略ctx参数
}


int printf(const char *fmt, ...) {
   va_list args; //可变参数
   va_start(args, fmt); //初始化list 让它指向第一个可变参数
   int count = 0;
   while(*fmt){
    if(*fmt == '%'){
      fmt++;

      switch (*fmt){
        case 'd': count += print_number(printf_output, NULL, va_arg(args, int), 10); break;
        case 's': count += print_string(printf_output, NULL, va_arg(args, const char*)); break;
        
    default:
      putch('%');  // 未知转换说明符，保留'%'
      putch(*fmt);
      count += 2;
      break;
    } 
  } else{
      putch(*fmt++);
      count++;
  }

   }
   va_end(args); //关闭可变参数
   return count;
  // panic("Not implemented");
}

int vsprintf(char *out, const char *fmt, va_list ap) {
  panic("Not implemented");
}

int sprintf(char *out, const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);
  int count = 0;
  char *buf = out;

  while (*fmt){
    if(*fmt == '%'){
      fmt++;

      switch(*fmt){
        case('d'): count += print_number(sprintf_output, &buf, va_arg(args, int), 10); break;
        case('s'): count += print_string(sprintf_output, &buf, va_arg(args, const char*)); break;
      }
    }else{
      printf_output(NULL, *fmt++);
      count++;
    }

      
  }
   va_end(args);
  return count;
  // panic("Not implemented");
}

int snprintf(char *out, size_t n, const char *fmt, ...) {
  panic("Not implemented");
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  panic("Not implemented");
}

#endif
