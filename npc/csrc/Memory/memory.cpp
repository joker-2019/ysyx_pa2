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
#include <time.h>

#define PG_ALIGN __attribute((aligned(4096)))
uint8_t pmem[CONFIG_MSIZE] PG_ALIGN = {};

#define SERIAL_ADDR  0x10000000 //串口地址
static uint64_t boot_time = 0; //系统启动时间
#define RTC_ADDR     0xa0000048  // real-time clock MMIO 地址

static bool need_update = false;
static int uart_char;

uint64_t get_time_us() {
    struct timespec ts;
    // clock_gettime(CLOCK_MONOTONIC, &ts);
    clock_gettime(CLOCK_REALTIME, &ts);
    return (uint64_t)(ts.tv_sec * 1000000 + ts.tv_nsec / 1000);
}

void init_device() {
  boot_time = get_time_us();
  printf("[Device Init] boot_time = %lu us\n", boot_time);
}

void device_update() {
    // printf("device_update called\n");
    if (need_update)
    {
        putchar(uart_char);
        fflush(stdout);
        need_update = false;
    }
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

    uint64_t now = get_time_us() - boot_time; // 启动后的微秒数
    if (addr == RTC_ADDR){
        // printf("[RTC] read time = %u\n", (uint32_t)(now & 0xffffffff));
        fflush(stdout);
        return (uint32_t)(now & 0xffffffff); // 返回低32位 (us)
    } 
    if (addr == RTC_ADDR + 4){
        // printf("[DBG] lw_mem_read: RTC high read -> %u\n", (uint32_t)(now >> 32));
        fflush(stdout);
        return (uint32_t)(now >> 32); // 返回高32位
    }
    // 💡 模拟串口接收寄存器读取
    /* if (addr == SERIAL_ADDR) {
        // 没有外部输入时返回 0，表示没有数据
        // printf("[DBG] lw_mem_read: SERIAL_ADDR read (addr=0x%x len=%d)\n", addr, len);
        fflush(stdout);
        return 0;
    } */

    assert(addr >= CONFIG_MBASE && addr + len <= CONFIG_MBASE + CONFIG_MSIZE);
     #if ENABLE_MTRACE
    display_mread(addr, len);
    #endif
    uint32_t ret = host_read(guest_to_host(addr), len);
    return ret;
}

// 写入数据
// 注意：RISC-V数据访问通常是按字（4字节）对齐
extern "C" void sw_mem_write(int addr, int len, int data) {
    // printf("[UART] addr=0x%x, data=0x%x, len=%u\n", addr, data, len);
    // 串口写入
    if (addr == SERIAL_ADDR) {
        // printf("[UART] write char = '%c' (0x%02x)\n", data & 0xFF, data & 0xFF);
        // putchar((char)(data & 0xFF)); 
        // fflush(stdout);  // 立即刷新输出
        need_update = true;
        uart_char = data & 0xFF;  // 保存要输出的字符
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

