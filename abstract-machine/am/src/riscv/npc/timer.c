#include <am.h>

// #define RTC_ADDR 0xa0000048

#define CLINT_MTIME_ADDR 0xa0000048
// 设置为仿真等效主频(Hz)，可按需调整
#define CLINT_FREQ_HZ    1000000
static inline uint32_t inl(uintptr_t addr) { return *(volatile uint32_t *)addr; }

void __am_timer_init() {
}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {
  // uptime->us = 0;
  // 获取当前时间，单位为毫秒
  /* uint32_t low = inl(RTC_ADDR);     // 低32位
  uint32_t high = inl(RTC_ADDR + 4); // 高32位
  uptime->us = ((uint64_t)high << 32) | low; */
  uint32_t hi1 = inl(CLINT_MTIME_ADDR + 4);
  uint32_t lo  = inl(CLINT_MTIME_ADDR);
  uint32_t hi2 = inl(CLINT_MTIME_ADDR + 4);
  if (hi1 != hi2) {
    lo = inl(CLINT_MTIME_ADDR);
    hi1 = hi2;
  }
  uint64_t mtime = ((uint64_t)hi1 << 32) | lo;
  uptime->us = (mtime * 1000000ull) / CLINT_FREQ_HZ;
}

void __am_timer_rtc(AM_TIMER_RTC_T *rtc) {
  rtc->second = 0;
  rtc->minute = 0;
  rtc->hour   = 0;
  rtc->day    = 0;
  rtc->month  = 0;
  rtc->year   = 1900;
}
