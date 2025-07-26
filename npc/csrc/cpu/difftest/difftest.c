#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include "../../include/cpu/difftest.h"

// 动态库句柄和函数指针
static void* nemu_so = NULL;
static void (*p_difftest_memcpy)(paddr_t, void*, size_t, bool) = NULL;
static void (*p_difftest_regcpy)(void*, bool) = NULL;
static void (*p_difftest_exec)(uint64_t) = NULL;
static void (*p_difftest_raise_intr)(word_t) = NULL;
static void (*p_difftest_init)(int) = NULL;

void difftest_init_nemu(int difftest_port) {
 // 加载 NEMU 共享库
  nemu_so = dlopen("/home/wp/ysyx-workbench/nemu/build/riscv32-nemu-interpreter-so", RTLD_LAZY);
 if (!nemu_so) {
  fprintf(stderr, "Error loading NEMU shared object: %s\n", dlerror());
  exit(1);
 }

 // 获取函数指针
 p_difftest_memcpy = (void (*)(paddr_t, void*, size_t, bool)) dlsym(nemu_so, "difftest_memcpy");
 p_difftest_regcpy = (void (*)(void*, bool)) dlsym(nemu_so, "difftest_regcpy");
 p_difftest_exec = (void (*)(uint64_t)) dlsym(nemu_so, "difftest_exec");
 p_difftest_raise_intr = (void (*)(word_t)) dlsym(nemu_so, "difftest_raise_intr");
 p_difftest_init = (void (*)(int)) dlsym(nemu_so, "difftest_init");
    
 // 检查所有函数是否加载成功
 if (!p_difftest_memcpy || !p_difftest_regcpy || !p_difftest_exec || !p_difftest_init) {
 fprintf(stderr, "Error loading function symbols: %s\n", dlerror());
 exit(1);
 }
    
 // 初始化 NEMU 仿真环境
 p_difftest_init(difftest_port);
}

// 封装调用接口
void difftest_memcpy(paddr_t addr, void *buf, size_t n, bool direction) {
 if (!p_difftest_memcpy) return;
 p_difftest_memcpy(addr, buf, n, direction);
}

void difftest_regcpy(void *dut, bool direction) {
    if (!p_difftest_regcpy) return;
    p_difftest_regcpy(dut, direction);
}

void difftest_exec(uint64_t n) {
    if (!p_difftest_exec) return;
    p_difftest_exec(n);
}

void difftest_raise_intr(word_t NO) {
    if (!p_difftest_raise_intr) return;
    p_difftest_raise_intr(NO);
}

void difftest_close() {
    if (nemu_so) {
        dlclose(nemu_so);
        nemu_so = NULL;
    }
}