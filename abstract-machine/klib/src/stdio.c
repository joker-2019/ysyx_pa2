#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

//将数字转换为字符串的辅助函数
static void number_to_str(char *buf, int num) {
    if (num == 0) {
        *buf++ = '0';
        *buf = '\0';
        return;
    }

    if (num < 0) {
        *buf++ = '-';
        num = -num;
    }

    char temp[32];
    int i = 0;
    while (num > 0) {
        temp[i++] = '0' + (num % 10);
        num /= 10;
    }

    while (i > 0) {
        *buf++ = temp[--i];
    }
    *buf = '\0';
}


int printf(const char *fmt, ...) {
  char buf[1024]; // 假设输出缓冲区大小为1024
   va_list args; //可变参数
   va_start(args, fmt); //初始化list 让它指向第一个可变参数
   int count = sprintf(buf, fmt, args); //调用sprintf函数
   va_end(args); //结束可变参数的使用

   // 输出到标准输出设备
   char *p = buf;
   while (*p) {
     // 输出单个字符到标准输出
     putch(*p++);
   }

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
      fmt++;//跳过 ‘%’
      switch(*fmt){
      
        case('d'):
          //处理整数
          int num = va_arg(args, int);
          char num_buf[32];
          number_to_str(num_buf, num);
          char *p = num_buf;
          while (*p) {
            *buf++ = *p++;
            count++;
        }
        break;

        case('s'):
          //处理字符串
          const char *str = va_arg(args, const char*);
          while (*str) {
            *buf++ = *str++;
            count++;
          }
          break;
      }
      fmt++; //跳过转换字符(d, s, ...)
      
    }else {
      *buf++ = *fmt++;
      count++;
    }
  }
  *buf = '\0'; // 添加字符串终止符
  va_end(args);
  return count;
}

int snprintf(char *out, size_t n, const char *fmt, ...) {
  panic("Not implemented");
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  panic("Not implemented");
}

#endif
