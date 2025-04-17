#ifndef __MEMORY_H__
#define __MEMORY_H__

#include <cstdint>
#include <cstring>
#include <cassert>
#include <iostream>

// 内存从 MEM_BASE = 0x80000000 地址开始，大小为 MEM_SIZE = 0x8000000，
// 即模拟了一个从 0x80000000 到 0x80FFFFFF（结束地址）之间的 128MB 内存区域

#define MEM_BASE 0x80000000  //代表了内存的起始地址，即模拟内存的基址。
#define MEM_SIZE 0x8000000  // 表示了内存的大小，即模拟内存空间的总大小。 转换为10进制后是 134217728 字节，即 128MB


// 定义一个模拟内存空间
extern uint8_t pmem[MEM_SIZE];

// 读 4 字节，模拟一个32位总线
inline uint32_t pmem_read(uint32_t addr) {
     if (addr < MEM_BASE || addr + 3 >= MEM_BASE + MEM_SIZE) {
        printf("Memory read out of bounds! addr = 0x%x\n", addr);
        assert(0);
    }
    uint32_t offset = addr - MEM_BASE;
    uint32_t data = 0;
    std::memcpy(&data, &pmem[offset], 4); // little-endian
    return data;
}

// 写 4 字节
inline void pmem_write(uint32_t addr, uint32_t data) {
    if (addr < MEM_BASE || addr + 3 >= MEM_BASE + MEM_SIZE) {
        printf("Memory write out of bounds! addr = 0x%x\n", addr);
        assert(0);
    }
    uint32_t offset = addr - MEM_BASE;
    std::memcpy(&pmem[offset], &data, 4); // little-endian
}

#endif
