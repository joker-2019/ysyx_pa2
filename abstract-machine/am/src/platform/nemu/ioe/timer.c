#include <am.h>
#include <nemu.h>
#include <time.h>
//系统启动时间，用于计算相对时间
static uint64_t boot_time;

void __am_timer_init() {
    // 获取当前时间，单位为毫秒
  uint32_t low = inl(RTC_ADDR);     // 低32位
  uint32_t high = inl(RTC_ADDR + 4); // 高32位
  // 将当前初始化时间转换为64位整数
  boot_time = ((uint64_t)high << 32) | low;

}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {

 // 获取当前时间，单位为毫秒
  uint32_t low = inl(RTC_ADDR);     // 低32位
  uint32_t high = inl(RTC_ADDR + 4); // 高32位
  uptime->us = ((uint64_t)high << 32) | low;
  // 计算从启动到现在的时间差（毫秒）
  //uint64_t elapsed_ms = current_time - boot_time;

  // 计算自系统启动以来的微秒数
  //uptime->us = elapsed_ms * 1000; // 转换为微秒
  //uptime->us = current_time;

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

