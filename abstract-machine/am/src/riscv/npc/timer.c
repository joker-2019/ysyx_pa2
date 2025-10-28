#include <am.h>

#define RTC_ADDR     0xa0000048
static inline uint32_t inl(uintptr_t addr) { return *(volatile uint32_t *)addr; }

void __am_timer_init() {
}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {
  // uptime->us = 0;
  // 获取当前时间，单位为毫秒
  uint32_t low = inl(RTC_ADDR);     // 低32位
  uint32_t high = inl(RTC_ADDR + 4); // 高32位
  uptime->us = ((uint64_t)high << 32) | low;
}

void __am_timer_rtc(AM_TIMER_RTC_T *rtc) {
  rtc->second = 0;
  rtc->minute = 0;
  rtc->hour   = 0;
  rtc->day    = 0;
  rtc->month  = 0;
  rtc->year   = 1900;
}
