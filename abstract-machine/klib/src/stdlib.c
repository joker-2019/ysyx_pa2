#include <am.h>
#include <klib.h>
#include <klib-macros.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)
static unsigned long int next = 1;

// 当前分配位置的指针
static void *addr = 0;

int rand(void) {
  // RAND_MAX assumed to be 32767
  next = next * 1103515245 + 12345;
  return (unsigned int)(next/65536) % 32768;
}

void srand(unsigned int seed) {
  next = seed;
}

int abs(int x) {
  return (x < 0 ? -x : x);
}

int atoi(const char* nptr) {
  int x = 0;
  while (*nptr == ' ') { nptr ++; }
  while (*nptr >= '0' && *nptr <= '9') {
    x = x * 10 + *nptr - '0';
    nptr ++;
  }
  return x;
}

void *malloc(size_t size) {
  // On native, malloc() will be called during initializaion of C runtime.
  // Therefore do not call panic() here, else it will yield a dead recursion:
  //   panic() -> putchar() -> (glibc) -> malloc() -> panic()
#if !(defined(__ISA_NATIVE__) && defined(__NATIVE_USE_KLIB__))
  if(addr == 0) {
    // Initialize addr to a specific memory location, e.g., 0x80000000
    addr = (void *)heap.start;
  }
  //此时完成地址初始化，保存当前分配地址作为返回值
  void *ret = (void*)addr;
  addr += size; // 更新分配地址
  
  // 检查是否超过堆的结束地址
  if (addr > (void *)heap.end) {
    return NULL; // 堆空间不足
  }
  // 返回当前分配地址
  return ret;
#else
  // 在非原生模式下，直接返回 NULL
  //panic("Not implemented"); 
#endif
  return NULL;
}

void free(void *ptr) {
}

#endif
