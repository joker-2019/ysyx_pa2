
#include "mmio.h"
#include <time.h>

#define RTC_ADDR  0xa0000048
#define RTC_SIZE  8

static uint8_t rtc_space[RTC_SIZE];

static void rtc_io_handler(uint32_t offset, int len, bool is_write) {
    assert(offset == 0 || offset == 4);
    if (!is_write) {
        struct timespec ts;
        clock_gettime(CLOCK_REALTIME, &ts);
        uint64_t us = (uint64_t)ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000ULL;
        uint32_t low = (uint32_t)(us & 0xffffffff);
        uint32_t high = (uint32_t)(us >> 32);
        *(uint32_t *)(rtc_space + 0) = low;
        *(uint32_t *)(rtc_space + 4) = high;
    }
}
void init_timer() {
  // rtc_port_base = (uint32_t *)new_space(8);
  // add_mmio_map("rtc", CONFIG_RTC_MMIO, rtc_port_base, 8, rtc_io_handler);
  add_mmio_map("rtc", RTC_ADDR, RTC_SIZE, rtc_space, rtc_io_handler);
  printf("[RTC] Initialized at 0x%08x\n", RTC_ADDR);
}