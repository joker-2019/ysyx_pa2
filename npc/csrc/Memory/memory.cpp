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

static uint64_t boot_time = 0; //系统启动时间
static uint8_t mrom[MROM_SIZE];

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

extern "C" uint32_t pmem_read(int addr, int len) {

    uint64_t now = get_time_us() - boot_time; // 启动后的微秒数
    if (addr == RTC_ADDR){
        fflush(stdout);
        return (uint32_t)(now & 0xffffffff); // 返回低32位 (us)
    } 
    if (addr == RTC_ADDR + 4){
        fflush(stdout);
        return (uint32_t)(now >> 32); // 返回高32位
    }
    /* printf("[pmem_read] 调试信息：\n");
    printf("  addr=0x%x, len=%d\n", addr, len);
    printf("  内存范围: 0x%x ~ 0x%x (不包含0x%x)\n", CONFIG_MBASE, CONFIG_MBASE + CONFIG_MSIZE - 1, CONFIG_MBASE + CONFIG_MSIZE);
    printf("  addr >= mem_base? %s\n", (addr >= CONFIG_MBASE) ? "是" : "否");
    printf("  addr + len <= mem_end? %s(addr+len=0x%x)\n", (addr + len <= CONFIG_MBASE + CONFIG_MSIZE) ? "是" : "否", addr + len);
    assert(addr >= CONFIG_MBASE && addr + len <= CONFIG_MBASE + CONFIG_MSIZE); */
    uint32_t uaddr = (uint32_t)addr;

    // itrace 读取 MROM 范围指令（0x20000000），走 mrom[] 数组
    if (uaddr >= MROM_BASE && uaddr + (uint32_t)len <= MROM_BASE + MROM_SIZE) {
        uint32_t data = 0;
        memcpy(&data, mrom + (uaddr - MROM_BASE), len);
        return data;
    }
    // 地址越界检查：只有在 SRAM/PSRAM 范围内才访问 pmem，否则返回 0 (地址越界检查在初始化时也对0地址进行判别，否则会导致0地址的越界访问)
    if (uaddr < CONFIG_MBASE || uaddr + (uint32_t)len > CONFIG_MBASE + CONFIG_MSIZE) {
        return 0;
    }
     #if ENABLE_MTRACE
    display_mread(addr, len);
    #endif
    uint32_t ret = host_read(guest_to_host(addr), len);
    return ret;
}

// 写入数据
// 注意：RISC-V数据访问通常是按字（4字节）对齐
extern "C" void pmem_write(int addr, int len, int data) {
    // printf("[UART] addr=0x%x, data=0x%x, len=%u\n", addr, data, len);
    // 串口写入
    if (addr >= UART_BASE && addr <= UART_BASE + UART_SIZE) {
        // printf("[UART] write char = '%c' (0x%02x)\n", data & 0xFF, data & 0xFF);
        // putchar((char)(data & 0xFF)); 
        // fflush(stdout);  // 立即刷新输出
        need_update = true;
        uart_char = data & 0xFF;  // 保存要输出的字符
        return;
    }
    // printf("[pmem_write] 调试信息：\n");
    // printf("  addr=0x%x, len=%d\n", addr, len);
    // printf("  内存范围: 0x%x ~ 0x%x (不包含0x%x)\n", CONFIG_MBASE, CONFIG_MBASE + CONFIG_MSIZE - 1, CONFIG_MBASE + CONFIG_MSIZE);
    // printf("  addr >= mem_base? %s\n", (addr >= CONFIG_MBASE) ? "是" : "否");
    // printf("  addr + len <= mem_end? %s(addr+len=0x%x)\n", (addr + len <= CONFIG_MBASE + CONFIG_MSIZE) ? "是" : "否", addr + len);
    
    // assert(addr >= CONFIG_MBASE && addr + len <= CONFIG_MBASE + CONFIG_MSIZE);
     // 边界检查：与 pmem_read 同理，组合逻辑驱动时可能传入无效地址
     uint32_t uaddr = (uint32_t)addr;
     if (uaddr < CONFIG_MBASE || uaddr + len > CONFIG_MBASE + CONFIG_MSIZE) {
         return;
     }
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

long load_mrom(const char *filename) {
    if (!filename) return 0;
    FILE *fp = fopen(filename, "rb");
    if (!fp) {
        printf("[MROM] Cannot open '%s'\n", filename);
        return -1;
    }
    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);
    assert(size <= MROM_SIZE);
    fseek(fp, 0, SEEK_SET);
    int ret = fread(mrom, size, 1, fp);
    assert(ret == 1);
    fclose(fp);
    printf("[MROM] Loaded %ld bytes from '%s'\n", size, filename);
    return size;
}

extern "C" void flash_read(int32_t addr, int32_t *data) { 
    uint32_t offset = (uint32_t)addr;
    if (offset + 4 <= FLASH_SIZE) {
        memcpy(data, flash + offset, 4);
    } else {
        *data = 0;
    }
}

extern "C" void mrom_read(int32_t addr, int32_t *data) {
    uint32_t offset = (uint32_t)addr - MROM_BASE;
    if (offset + 4 <= MROM_SIZE) {
        memcpy(data, mrom + offset, 4);
    } else {
        *data = 0;
    }
}

// 返回 guest 物理地址对应的 host 指针（支持 MROM/SRAM/PSRAM）
void *pmem_addr(uint32_t addr) {
    uint32_t uaddr = addr;
    if (uaddr >= MROM_BASE && uaddr < MROM_BASE + MROM_SIZE)
        return (void *)(mrom + (uaddr - MROM_BASE));
    if (uaddr >= CONFIG_MBASE && uaddr < CONFIG_MBASE + CONFIG_MSIZE)
        return (void *)(pmem + (uaddr - CONFIG_MBASE));
    return NULL;
}

extern bool sim_in_reset;

extern "C" int is_valid_address(uint32_t addr) {
    // 检查地址是否在合法范围
    int valid = 1;
    /* int valid = (addr >= MROM_BASE  && addr < MROM_BASE  + MROM_SIZE)  ||
                (addr >= SRAM_BASE  && addr < SRAM_BASE  + SRAM_SIZE)  ||
                (addr >= CLINT_BASE && addr < CLINT_BASE + CLINT_SIZE) ||
                (addr >= UART_BASE  && addr < UART_BASE  + UART_SIZE)  ||
                (addr >= SPI_BASE   && addr < SPI_BASE   + SPI_SIZE)   ||
                (addr >= GPIO_BASE  && addr < GPIO_BASE  + GPIO_SIZE)  ||
                (addr >= PSRAM_BASE && addr < PSRAM_BASE + PSRAM_SIZE);
 */
    return valid; // 合法返回1，非法返回0；由硬件 access_fault 信号处理后续跳转
  }

