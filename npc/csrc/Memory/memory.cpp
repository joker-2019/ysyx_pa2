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
static uint8_t flash[FLASH_SIZE];
static uint8_t sram[SRAM_SIZE];

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

// 在 flash_dpi.c 中添加初始化函数

void init_mem(){
    memset(pmem, 0, sizeof(pmem));
    memset(mrom, 0, sizeof(mrom));
    memset(sram, 0, sizeof(sram));
    memset(flash, 0, sizeof(flash));

    /*  uint32_t *flash_ptr = (uint32_t *)(flash + 0x100000); // 偏移 1MB 处
    *flash_ptr = 0xdeadbeef; */
}

uint8_t *guest_to_host(uint32_t paddr){
    if (paddr >= SRAM_BASE && paddr < SRAM_BASE + SRAM_SIZE) {
        return sram + (paddr - SRAM_BASE);
    }
    if(paddr >= MROM_BASE && paddr < MROM_BASE + MROM_SIZE) {
        return mrom + (paddr - MROM_BASE);
    }
    if (paddr >= CONFIG_MBASE && paddr < CONFIG_MBASE + CONFIG_MSIZE) {
        return pmem + (paddr - CONFIG_MBASE);
    }
    if (paddr >= FLASH_BASE && paddr < FLASH_BASE + FLASH_SIZE) {
        return flash + (paddr - FLASH_BASE);
    }
    return NULL;
}

uint32_t phys_mem_read(uint32_t addr, int len) {
    uint8_t *host_addr = guest_to_host(addr);
    assert(host_addr != NULL && "phys_mem_read out of SoC memory range");

    #if ENABLE_MTRACE
    display_mread(addr, len);
    #endif
    
    uint32_t ret = host_read(host_addr, len); 
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
    uint32_t uaddr = (uint32_t)addr;

    // itrace 读取 FLASH 范围指令
    if (uaddr >= MROM_BASE && uaddr + (uint32_t)len <= MROM_BASE + MROM_SIZE) {
        uint32_t data = 0;
        memcpy(&data, mrom + (uaddr - MROM_BASE), len);
        return data;
    }
    if (uaddr >= FLASH_BASE && uaddr + (uint32_t)len <= FLASH_BASE + FLASH_SIZE) {
        uint32_t data = 0;
        memcpy(&data, flash + (uaddr - FLASH_BASE), len);
        return data;
    }
    uint8_t *host_addr = guest_to_host(uaddr);
    // 地址越界检查：只有在 SRAM/PSRAM 范围内才访问内存，否则返回 0
    if (host_addr == NULL) {
        return 0;
    }
     #if ENABLE_MTRACE
    display_mread(addr, len);
    #endif
    uint32_t ret = host_read(host_addr, len);
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
     // 边界检查：与 pmem_read 同理，组合逻辑驱动时可能传入无效地址
     uint32_t uaddr = (uint32_t)addr;
     uint8_t *host_addr = guest_to_host(uaddr);
     if (host_addr == NULL) {
         return;
     }
    #if ENABLE_MTRACE
    display_mwrite(addr, len, data);
    #endif

    // 写入data到物理内存 (小端存储)
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

/* long load_flash(const char *filename) {
    if (!filename) return 0;
    FILE *fp = fopen(filename, "rb");
    if (!fp) {
        printf("[FLASH] Cannot open '%s'\n", filename);
        return -1;
    }
    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);
    assert(size <= FLASH_SIZE);
    fseek(fp, 0, SEEK_SET);
    int ret = fread(flash, size, 1, fp);
    assert(ret == 1);
    fclose(fp);
    printf("[FLASH] Loaded %ld bytes from '%s'\n", size, filename);
    return size;
} */

extern "C" void flash_read(int32_t addr, int32_t *data) {
    // printf("flash_read addr = %08x\n", addr);
   /*  uint32_t offset = (uint32_t)addr;
    if (offset + 4 <= FLASH_SIZE) {
        memcpy(data, flash + offset, 4);
    } else {
        *data = 0;
    } */
    uint32_t offset = (uint32_t)addr;
    // 我们在此处直接返回 char-test.bin 的机器码以模拟存放在 flash 颗粒中
    const uint32_t char_test_bin[] = {
        0x100007b7, // lui a5,0x10000
        0x04100713, // li a4,65 ('A')
        0x00e78023, // sb a4,0(a5)
        0x0000006f  // j 0 (死循环)
    };
    if (offset < sizeof(char_test_bin)) {
        memcpy(data, (uint8_t*)char_test_bin + offset, 4);
    } else {
        *data = 0; // 其他地址默认返回 0
    }

}

extern "C" void mrom_read(int32_t addr, int32_t *data) {
    uint32_t offset = (uint32_t)addr - MROM_BASE;
    if (offset + 4 <= MROM_SIZE) {
        memcpy(data, mrom + offset, 4);
    } else {
        *data = 0;
    }
    // *data = 0;
}

// 返回 guest 物理地址对应的 host 指针（支持 MROM/SRAM/PSRAM）
void *pmem_addr(uint32_t addr) {
    uint32_t uaddr = addr;
    if (uaddr >= MROM_BASE && uaddr < MROM_BASE + MROM_SIZE)
        return (void *)(mrom + (uaddr - MROM_BASE));
    if (uaddr >= FLASH_BASE && uaddr < FLASH_BASE + FLASH_SIZE)
        return (void *)(flash + (uaddr - FLASH_BASE));
    if (uaddr >= SRAM_BASE && uaddr < SRAM_BASE + SRAM_SIZE)
        return (void *)(sram + (uaddr - SRAM_BASE));
    return (void *)guest_to_host(uaddr);
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

