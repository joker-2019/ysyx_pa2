#include <am.h>
#include <nemu.h>
#include <stdint.h>
#include <stdio.h>

#define AUDIO_FREQ_ADDR      (AUDIO_ADDR + 0x00)
#define AUDIO_CHANNELS_ADDR  (AUDIO_ADDR + 0x04)
#define AUDIO_SAMPLES_ADDR   (AUDIO_ADDR + 0x08)
#define AUDIO_SBUF_SIZE_ADDR (AUDIO_ADDR + 0x0c)
#define AUDIO_INIT_ADDR      (AUDIO_ADDR + 0x10)
#define AUDIO_COUNT_ADDR     (AUDIO_ADDR + 0x14)

static uint32_t write_total = 0;  // 写入总字节数，全局变量
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

/*   uint8_t *buf_start = ctl->buf.start;
  uint8_t *buf_end = ctl->buf.end;
  int total_len = buf_end - buf_start;
  uint8_t *sbuf = (uint8_t *)AUDIO_SBUF_ADDR;

  uint32_t sbuf_size = inl(AUDIO_SBUF_SIZE_ADDR);  // 总缓冲区大小
  uint32_t write_ptr = 0;

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
  } */
   uint8_t *buf_start = ctl->buf.start;
  uint8_t *buf_end = ctl->buf.end;
  int total_len = buf_end - buf_start;
  if (total_len <= 0) return;

  uint8_t *sbuf = (uint8_t *)AUDIO_SBUF_ADDR;
  uint32_t sbuf_size = inl(AUDIO_SBUF_SIZE_ADDR);
  uint32_t write_ptr = 0;

  while (write_ptr < total_len) {
    uint32_t played = inl(AUDIO_COUNT_ADDR);                 // 已播放的数据量
    uint32_t buffered = write_total - played;                // 当前缓冲区中已写未播的数据
    uint32_t free_space = sbuf_size - buffered;

    if (free_space == 0) continue;  // 缓冲区满了，等待

    uint32_t chunk = total_len - write_ptr;
    if (chunk > free_space) chunk = free_space;

    // 写入 chunk 字节，从 write_total % sbuf_size 开始
    for (uint32_t i = 0; i < chunk; i++) {
      uint32_t pos = (write_total + i) % sbuf_size;
      sbuf[pos] = buf_start[write_ptr + i];
    }

    write_total += chunk;
    write_ptr += chunk;

    // 通知音频系统总的已写数据量（不加 chunk，会导致只播第一个音节）
    outl(AUDIO_COUNT_ADDR, write_total);
  }
}
