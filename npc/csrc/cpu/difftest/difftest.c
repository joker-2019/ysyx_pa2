#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include "../../include/cpu/difftest.h"
#include <assert.h>
// #include "../cpu.h"

// 动态库句柄和函数指针
static void* nemu_so = NULL;
static void (*p_difftest_memcpy)(paddr_t, void*, size_t, bool) = NULL;
static void (*p_difftest_regcpy)(void*, bool) = NULL;
static void (*p_difftest_exec)(uint64_t) = NULL;
static void (*p_difftest_raise_intr)(word_t) = NULL;
static void (*p_difftest_init)(int) = NULL;

// extern void update_register(void);

void difftest_init_nemu() {
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
    
 p_difftest_init(0); // 初始化 NEMU 仿真环境
 // ========== 新增：初始化时同步MROM内容到NEMU ==========
 // printf("[DiffTest] Sync MROM (0x%08x - 0x%08x) to NEMU...\n", MROM_BASE, MROM_BASE + MROM_SIZE);
 // p_difftest_memcpy(MROM_BASE, pmem_addr(MROM_BASE), MROM_SIZE, DIFFTEST_TO_REF);
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

void check_difftest_memcpy(paddr_t addr, void *buf, size_t n) {
    uint8_t *npc_mem = (uint8_t *)buf;
    uint8_t nemu_mem[n];

    // 从NEMU中读取内存数据
    p_difftest_memcpy(addr, nemu_mem, n, DIFFTEST_TO_DUT);

    // 逐字节比对
    for (size_t i = 0; i < n; i++) {
        if (npc_mem[i] != nemu_mem[i]) {
            printf("[DiffTest Mem Mismatch] addr = 0x%08lx npc = 0x%02x nemu = 0x%02x\n",
                   addr + i, npc_mem[i], nemu_mem[i]);
            assert(0);
        }
    }
    printf("[DiffTest] Memory Check Passed! Addr = 0x%08x, Size = %ld\n", addr, n);
}


