#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

//将数字转换为字符串的辅助函数
/* static void number_to_str(char *buf, int num) {
    if (num == 0) {
        *buf++ = '0';
        *buf = '\0';
        return;
    }

    char temp[32];
    int i = 0;
    int is_negative = 0;

    if (num < 0) {
        is_negative = 1;
        num = -num;
    }

    while (num > 0) {
        temp[i++] = '0' + (num % 10);
        num /= 10;
    }

    char *p = buf;
    if (is_negative) {
        *p++ = '-';
    }

    while (i > 0) {
        *p++ = temp[--i];
    }
    *p = '\0';
} */

// 支持有符号/无符号，10进制/16进制，int/long 的通用数字转字符串
static void number_to_str(char *buf, unsigned long num, int base, int is_signed, int is_negative) {
    char temp[32];
    int i = 0;

    if (num == 0) {
        temp[i++] = '0';
    } else {
        while (num > 0) {
            int digit = num % base;
            temp[i++] = (digit < 10) ? ('0' + digit) : ('a' + digit - 10);
            num /= base;
        }
    }

    char *p = buf;
    if (is_negative) {
        *p++ = '-';
    }
    // 16进制前缀
    if (base == 16) {
        *p++ = '0';
        *p++ = 'x';
    }
    while (i > 0) {
        *p++ = temp[--i];
    }
    *p = '\0';
}

int printf(const char *fmt, ...) {
  char buf[1024]; // 假设输出缓冲区大小为1024
   va_list args; //可变参数
   va_start(args, fmt); //初始化list 让它指向第一个可变参数
   int count = vsprintf(buf, fmt, args); //调用sprintf函数
   va_end(args); //结束可变参数的使用

   // 输出到标准输出设备
   char *p = buf;
   while (*p) {
     // 输出单个字符到标准输出
     putch(*p++);
   }
   return count;
}

int vsprintf(char *out, const char *fmt, va_list ap) {
    char *buf = out;
    int count = 0;
    va_list args_copy;
    va_copy(args_copy, ap);

    while (*fmt) {
        if (*fmt == '%') {
            fmt++;
            int long_flag = 0;
            if (*fmt == 'l') { long_flag = 1; fmt++; }
            switch (*fmt) {
                case 'd': {
                    if (long_flag) {
                        long num = va_arg(ap, long);
                        char num_buf[32];
                        number_to_str(num_buf, (unsigned long)(num < 0 ? -num : num), 10, 1, num < 0);
                        char *p = num_buf; while (*p) { *buf++ = *p++; count++; }
                    } else {
                        int num = va_arg(ap, int);
                        char num_buf[32];
                        number_to_str(num_buf, (unsigned int)(num < 0 ? -num : num), 10, 1, num < 0);
                        char *p = num_buf; while (*p) { *buf++ = *p++; count++; }
                    }
                    break;
                }
                case 'u':{
                    if (long_flag) {
                        unsigned long num = va_arg(ap, unsigned long);
                        char num_buf[32];
                        number_to_str(num_buf, num, 10, 0, 0);
                        char *p = num_buf; while (*p) { *buf++ = *p++; count++; }
                    } else {
                        unsigned int num = va_arg(ap, unsigned int);
                        char num_buf[32];
                        number_to_str(num_buf, num, 10, 0, 0);
                        char *p = num_buf; while (*p) { *buf++ = *p++; count++; }
                    }
                    break;
                }
                case 'x': {
                    if (long_flag) {
                        unsigned long num = va_arg(ap, unsigned long);
                        char num_buf[32];
                        number_to_str(num_buf, num, 16, 0, 0);
                        char *p = num_buf; while (*p) { *buf++ = *p++; count++; }
                    } else {
                        unsigned int num = va_arg(ap, unsigned int);
                        char num_buf[32];
                        number_to_str(num_buf, num, 16, 0, 0);
                        char *p = num_buf; while (*p) { *buf++ = *p++; count++; }
                    }
                    break;
                }
                case 's': {
                    char *str = va_arg(args_copy, char*);
                    while (*str) {
                        *buf++ = *str++;
                        count++;
                    }
                    break;
                }
                case 'c':{
                    char ch = (char)va_arg(args_copy, int);
                    *buf++ = ch;
                    count++;
                    break;
                }
                default:
                    *buf++ = '%';
                    *buf++ = *fmt;
                    count += 2;
                    break;
            }
            fmt++;
        } else {
            *buf++ = *fmt++;
            count++;
        }
    }
    *buf = '\0';
    va_end(args_copy);
    return count;
}

int sprintf(char *out, const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);
  int count = vsprintf(out, fmt, args);
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
