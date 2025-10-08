#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdint.h>
#include "host.h"
#include "../utils/autoconf.h"
#include "../utils/iringbuf.h"
#include "../config/config.h"
#include <sys/time.h>
#include <stdint.h>

#define PG_ALIGN __attribute((aligned(4096)))
uint8_t pmem[CONFIG_MSIZE] PG_ALIGN = {};

#define SERIAL_ADDR  0x10000000 //串口地址
static uint64_t boot_time = 0; //系统启动时间
#define RTC_ADDR     0xa0000048  // real-time clock MMIO 地址

// 获取系统当前时间（微秒）
static uint64_t get_time_us() {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (uint64_t)tv.tv_sec * 1000000 + tv.tv_usec;
}

// 初始化时钟（在仿真启动时调用）
void init_clock() {
    boot_time = get_time_us();
}

// 获取从启动到现在的时间（微秒）
uint64_t get_clock_time() {
    return get_time_us() - boot_time;
}

void init_mem(){
    memset(pmem, 0, sizeof(pmem));  // 清空内存
}

uint8_t *guest_to_host(uint32_t paddr){
    return pmem + (paddr - CONFIG_MBASE);
}

uint32_t phys_mem_read(uint32_t addr, int len) {
    uint32_t offset = addr - CONFIG_MBASE; // 按照字节寻址(uint8_t)
    assert(offset + len <= CONFIG_MSIZE && "phys_mem_read overflow");
    // assert(addr >= CONFIG_MBASE && addr + len <= CONFIG_MBASE + CONFIG_MSIZE);

    #if ENABLE_MTRACE
    display_mread(addr, len);
    #endif
    
    uint32_t ret = host_read(guest_to_host(addr), len); 
    return ret;
}

extern "C" uint32_t mem_read(int pc) {
    if (pc == 0){
        return 0;
    }
    assert((pc & 0x3) == 0 && "Instruction address misaligned");
    uint32_t offset = pc - CONFIG_MBASE;
    assert(offset + 4 <= CONFIG_MSIZE && "Instruction memory overflow");
    // 读取4字节，解释为uint32_t（小端对齐）
    uint32_t inst;
    memcpy(&inst, pmem + offset, 4);
    // printf("DEBUG: pc=0x%08x → index=%d → instr=0x%08x\n", pc, offset, inst);
    return inst;
    // return phys_mem_read((uint32_t)pc, 4);
}

extern "C" uint32_t lw_mem_read(int addr, int len) {
    // 判断是否访问时钟 MMIO
    if ((addr & ~0x3u) == RTC_ADDR) {
        uint64_t now = get_clock_time();
        return (uint32_t)(now & 0xffffffff); // 返回低32位（us）
    }
    // uint32_t offset = addr - CONFIG_MBASE; // 按照字节寻址(uint8_t)
    assert(addr >= CONFIG_MBASE && addr + len <= CONFIG_MBASE + CONFIG_MSIZE);
     #if ENABLE_MTRACE
    display_mread(addr, len);
    #endif
    uint32_t ret = host_read(guest_to_host(addr), len);
    return ret;
    // return phys_mem_read((uint32_t)addr, len);
}

// 写入数据
// 注意：RISC-V数据访问通常是按字（4字节）对齐
extern "C" void sw_mem_write(int addr, int len, int data) {
    // 串口写入
    if (addr == SERIAL_ADDR) {
        putchar((char)(data & 0xFF));
        fflush(stdout);  // 立即刷新输出
        return;
    }
    assert(addr >= CONFIG_MBASE && addr + len <= CONFIG_MBASE + CONFIG_MSIZE);

    #if ENABLE_MTRACE
    display_mwrite(addr, len, data);
    #endif

    // 写入data到物理内存 (小端存储)
    // memcpy(pmem + offset, &data, len);
    uint8_t *host_addr = guest_to_host(addr);
    for (int i = 0; i < len; i++) {
        host_addr[i] = (data >> (8 * i)) & 0xFF;  //  按字节写入（小端）
    }
}

