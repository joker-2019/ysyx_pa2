#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

size_t strlen(const char *s) {
  const char * start = s; //构建常量start指向字符串s
  while(*s != '\0'){  //字符s不为0,循环++
    s++;
  }
  return s - start;  //返回末位 - 初位
 //panic("Not implemented");
}

char *strcpy(char *dst, const char *src) {
  if(dst == NULL || src == NULL) return NULL; // 若当前任意指向的字符为空，直接返回NULL
  char *temp = dst;
  while(*src != '\0'){
    *dst++ = *src++;
  }
  *dst = '\0';  // 必须补上终止符
  return temp;

  // panic("Not implemented");
}
// 若src长度 < n，则用'\0'填充剩余空间。 若src长度 ≥ n，则不添加终止符，需调用者自行处理。
char *strncpy(char *dst, const char *src, size_t n) {
  char *temp = dst;
  while(n-- && *src != '\0'){
    *dst++ = *src++;
  }
  while (n-- > 0){
    *dst++ = '\0';
  }
  
  return temp;
  //panic("Not implemented");
}

char *strcat(char *dst, const char *src) {
  char *temp = dst;
  //找到dst的终止位置
  while(*dst != '\0'){
    dst++;
  }
  //将src中的字符复制到dst中
  while(*src != '\0'){
    *dst++ = *src++;
  }
  return temp;
  //panic("Not implemented");
}

int strcmp(const char *s1, const char *s2) {
  while(*s1 == *s2){ 
    if(*s1 == '\0') return 0;
    s1++;
    s2++;
  }
   //  返回无符号字符值的差值（确保ASCII正确比较）
  return (*(unsigned char*)s1 - *(unsigned char*)s2);
  //panic("Not implemented");
}

int strncmp(const char *s1, const char *s2, size_t n) {
  if(n == 0) return 0;
  while(n--){
    if(*s1 != *s2){
      return (*(unsigned char*)s1 - *(unsigned char*)s2);
    }
    if(*s1 == '\0'){
      break; //reach to end of string
    }
    s1++;
    s2++;
  }
  return 0;
  //panic("Not implemented");
}

//memset（）函数用常数字节c填充s指向的存储区的前n个字节。
void *memset(void *s, int c, size_t n) {
  unsigned char *temp = s;
  while(n--){
    *temp++ = (unsigned char)c;
  }
  return s;
  //panic("Not implemented");
}

void *memmove(void *dst, const void *src, size_t n) {
  unsigned char *d = dst;
  const unsigned char *s = src;

    if(d < s){  //若d的位置在s之前，可以直接复制，避免了内存重叠的问题
      while(n--){
        *d++ = *s++;
      }
    }else{  //当d>=s时，可能出现内存重叠问题，所以反向复制
        d += n; // 移动到目标末尾
        s += n; // 移动到源末尾
        while (n--){
          *--d = *--s; // 从后往前复制 
        }
        
    }
    return dst;
  
  //panic("Not implemented");
}

void *memcpy(void *out, const void *in, size_t n) {
  unsigned char *dst = out;
  const unsigned char *src = in;
  while (n--)
  {
    *dst++ = *src++;
  }
  return dst;
  
  //panic("Not implemented");
}

//memcmp作为二进制内存比较函数，不关心也不检查'\0'。它必须严格比较前n个字节，无论这些字节是否为'\0'。
int memcmp(const void *s1, const void *s2, size_t n) {
  if(n == 0) return 0;
  const unsigned char *p1 = s1; 
  const unsigned char *p2 = s2;
  while (n--){
    if(*p1 != *p2){
      return *p1 - *p2;
    }
    p1++;
    p2++;
  }
  
  return 0;
  //panic("Not implemented");
}

#endif
