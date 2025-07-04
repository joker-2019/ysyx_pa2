#include <am.h>
#include <nemu.h>
#include <stdint.h>
#include <stdio.h>
#include <klib.h>

#define AUDIO_FREQ_ADDR      (AUDIO_ADDR + 0x00)
#define AUDIO_CHANNELS_ADDR  (AUDIO_ADDR + 0x04)
#define AUDIO_SAMPLES_ADDR   (AUDIO_ADDR + 0x08)
#define AUDIO_SBUF_SIZE_ADDR (AUDIO_ADDR + 0x0c)
#define AUDIO_INIT_ADDR      (AUDIO_ADDR + 0x10)
#define AUDIO_COUNT_ADDR     (AUDIO_ADDR + 0x14)

static uint32_t audio_rb_pos = 0; // 环形缓冲区写入位置

void __am_audio_init() {
  // 初始化音频控制器
  outl(AUDIO_FREQ_ADDR, 44100);        // 设置默认音频频率
  outl(AUDIO_CHANNELS_ADDR, 2);        // 设置默认声道数（立体声）
  outl(AUDIO_SAMPLES_ADDR, 1024);      // 设置默认采样数
  outl(AUDIO_SBUF_SIZE_ADDR, 4096);    // 设置音频缓冲区大小

  outl(AUDIO_INIT_ADDR, 0);            // 通知音频控制器初始化
  outl(AUDIO_COUNT_ADDR, 0);            // 初始时缓冲区数据量为0
}

void __am_audio_config(AM_AUDIO_CONFIG_T *cfg) {
  uint32_t sbuf_size = inl(AUDIO_SBUF_SIZE_ADDR); // 读取音频缓冲区大小

  *cfg = (AM_AUDIO_CONFIG_T) {
    .present = true,
    .bufsize = sbuf_size
  };
}

void __am_audio_ctrl(AM_AUDIO_CTRL_T *ctrl) {
  outl(AUDIO_FREQ_ADDR, ctrl->freq);        // 设置音频频率
  outl(AUDIO_CHANNELS_ADDR, ctrl->channels); // 设置音频声道数
  outl(AUDIO_SAMPLES_ADDR, ctrl->samples);   // 设置音频采样数

  // 通知音频控制器初始化
  outl(AUDIO_INIT_ADDR, 1);
}

void __am_audio_status(AM_AUDIO_STATUS_T *stat) {
  // 读取音频样本计数
  stat->count = inl(AUDIO_COUNT_ADDR);
}

void __am_audio_play(AM_AUDIO_PLAY_T *ctl) {
 /*  uint8_t *buf_start = ctl->buf.start;
  uint8_t *buf_end = ctl->buf.end;

  int total_len = buf_end - buf_start;
  if (total_len <= 0) return;  // 如果没有数据，直接返回

  uint8_t *sbuf = (uint8_t *)AUDIO_SBUF_ADDR; // 获取音频缓冲区地址
  uint32_t sbuf_size = inl(AUDIO_SBUF_SIZE_ADDR);  // 总缓冲区大小

  uint32_t write_ptr = 0; // 当前写入位置

  while (write_ptr < total_len) {
    uint32_t count = inl(AUDIO_COUNT_ADDR);        // 当前已填充样本数
    uint32_t free_space = sbuf_size - count;

    if (free_space == 0) continue;  // 等待直到有空位（或 sleep）

    // 本次写入的数据长度
    uint32_t chunk = total_len - write_ptr;
    if (chunk > free_space) chunk = free_space;

    // 写入 chunk 个字节到 sbuf
    for (uint32_t i = 0; i < chunk; i++) {
      sbuf[(count + i) % sbuf_size] = buf_start[write_ptr + i];
    }

    // 通知硬件写入了多少数据
    outl(AUDIO_COUNT_ADDR, count + chunk);
    write_ptr += chunk;
  }  */
  // static int play_count = 0;
  // uint32_t len1 = ctl->buf.end - ctl->buf.start;
  
  // printf("[AM_PLAY] 第%d次播放请求: 数据长度=%u字节\n", ++play_count, len1);
  uint8_t *audio_area = (ctl->buf).start;
  uint32_t audio_rb_size = inl(AUDIO_SBUF_SIZE_ADDR);
  uint32_t len = (ctl->buf).end - (ctl->buf).start;
  uint8_t *audio_ringbuff = (uint8_t *)(uintptr_t)AUDIO_SBUF_ADDR;
  
  // 检查当前可用空间
  uint32_t count = inl(AUDIO_COUNT_ADDR);
  
  // 如果空间不足，等待直到有足够空间
  
  // 更智能的等待策略
  while (count + len > audio_rb_size) {
    // 使用指数退避算法
    static int wait_cycles = 100;
    for (volatile int i = 0; i < wait_cycles; i++);
    
    // 如果连续等待，增加等待时间以减少CPU使用
    wait_cycles = wait_cycles < 10000 ? wait_cycles * 2 : wait_cycles;
    
    count = inl(AUDIO_COUNT_ADDR);
  }
  
  // 写入数据
  if (audio_rb_pos + len <= audio_rb_size) {
    // 可以一次性复制
    memcpy(audio_ringbuff + audio_rb_pos, audio_area, len);
    audio_rb_pos = (audio_rb_pos + len) & (audio_rb_size - 1);
  } else {
    // 需要分两次复制（环形缓冲区环绕）
    int first_part = audio_rb_size - audio_rb_pos;
    memcpy(audio_ringbuff + audio_rb_pos, audio_area, first_part);
    memcpy(audio_ringbuff, audio_area + first_part, len - first_part);
    audio_rb_pos = len - first_part;
  }
  
  // 更新计数
  outl(AUDIO_COUNT_ADDR, count + len);
  // printf("[AM_PLAY] 播放请求完成: count=%u\n", inl(AUDIO_COUNT_ADDR));
}
