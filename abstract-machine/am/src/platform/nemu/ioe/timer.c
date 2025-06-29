#include <am.h>
#include <nemu.h>
#include <time.h>
//系统启动时间，用于计算相对时间
//static uint64_t boot_time;

void __am_timer_init() {
}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {
 // 获取当前时间，单位为毫秒
  uint32_t low = inl(RTC_ADDR);     // 低32位
  uint32_t high = inl(RTC_ADDR + 4); // 高32位
  uptime->us = ((uint64_t)high << 32) | low;
}

void __am_timer_rtc(AM_TIMER_RTC_T *rtc) {
  // 填充 AM_TIMER_RTC_T 结构体
  rtc->second = 0;
  rtc->minute = 0;
  rtc->hour   = 0;
  rtc->day    = 0;
  rtc->month  = 0;
  rtc->year   = 1990;
}

