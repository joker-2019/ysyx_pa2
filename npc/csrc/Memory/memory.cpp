#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdint.h>
#include "host.h"
#include "../utils/autoconf.h"
#include "../utils/iringbuf.h"
#include "../config/config.h"

#define PG_ALIGN __attribute((aligned(4096)))
uint8_t pmem[CONFIG_MSIZE] PG_ALIGN = {};

void init_mem(){
    memset(pmem, 0, sizeof(pmem));  // 清空内存
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
}

uint8_t *guest_to_host(uint32_t paddr){
    return pmem + (paddr - CONFIG_MBASE);
}


uint32_t phys_mem_read(uint32_t addr, int len) {
    // 转换为数组索引 (因为每个元素是 4 字节)
    // uint32_t index = (addr - CONFIG_MBASE) / 4;
    uint32_t offset = addr - CONFIG_MBASE; // 按照字节寻址(uint8_t)
    assert(offset + len <= CONFIG_MSIZE && "phys_mem_read overflow");

/*     // 检查边界
    if(index >= CONFIG_MSIZE) {
    // if(index >= MEM_SIZE) {
        return 0; // 或触发错误
    } */
    #if ENABLE_MTRACE
    display_mread(addr, len);
    #endif
    
    uint32_t ret = host_read(guest_to_host(addr), len);
    // return pmem[index];  
    return ret;
}

extern "C" uint32_t lw_mem_read(int addr, int len) {
    uint32_t offset = addr - CONFIG_MBASE; // 按照字节寻址(uint8_t)
    assert(addr >= CONFIG_MBASE && addr + len <= CONFIG_MBASE + CONFIG_MSIZE);
    #if ENABLE_MTRACE
    display_mread(addr, len);
    #endif
    uint32_t ret = host_read(guest_to_host(addr), len);
    /* uint32_t data = 0;
    uint8_t *host_addr = guest_to_host(addr);
    for (int i = 0; i < len; i++) {
        data |= host_addr[i] << (8 * i);  // 小端组合
    } */
    return ret;
}

// 写入数据
// 注意：RISC-V数据访问通常是按字（4字节）对齐
extern "C" void sw_mem_write(int addr, int len, int data) {
    uint32_t offset = addr - CONFIG_MBASE;
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

