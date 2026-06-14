#include <am.h>

/* NPC 仿真器中 RTC MMIO 地址（同 npc 平台） */
#define RTC_ADDR 0xa0000048

static inline uint32_t inl(uintptr_t addr) {
  return *(volatile uint32_t *)addr;
}

void __am_timer_init() {
}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {
  /* 防止高低字之间发生进位，读两次高字 */
  uint32_t hi1 = inl(RTC_ADDR + 4);
  uint32_t lo  = inl(RTC_ADDR);
  uint32_t hi2 = inl(RTC_ADDR + 4);
  if (hi1 != hi2) {
    lo  = inl(RTC_ADDR);
    hi1 = hi2;
  }
  uptime->us = ((uint64_t)hi1 << 32) | lo;
}

void __am_timer_rtc(AM_TIMER_RTC_T *rtc) {
  rtc->second = 0;
  rtc->minute = 0;
  rtc->hour   = 0;
  rtc->day    = 0;
  rtc->month  = 0;
  rtc->year   = 1900;
}
