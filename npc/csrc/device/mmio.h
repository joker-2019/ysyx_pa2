#ifndef __MMIO_H__
#define __MMIO_H__

#include <stdint.h>
#include "../utils/autoconf.h"
#include <string>
#include <vector>
#include <cassert>

// IO 回调函数
typedef void (*io_callback_t)(uint32_t offset, int len, bool is_write);

// IO 映射结构体
struct IOMap {
    std::string name;
    uint32_t low;
    uint32_t high;
    uint8_t *space;
    io_callback_t callback;
};

// 添加 MMIO 映射
void add_mmio_map(const char *name, uint32_t addr, uint32_t len, uint8_t *space, io_callback_t callback);

// 通过地址过去对应的 IOMap
IOMap* fetch_mmio_map(uint32_t addr);

// 初始化设备
void init_device();  // 在 main 中调用 

#endif