#include <am.h>
#include <nemu.h>

#define AUDIO_FREQ_ADDR      (AUDIO_ADDR + 0x00)
#define AUDIO_CHANNELS_ADDR  (AUDIO_ADDR + 0x04)
#define AUDIO_SAMPLES_ADDR   (AUDIO_ADDR + 0x08)
#define AUDIO_SBUF_SIZE_ADDR (AUDIO_ADDR + 0x0c)
#define AUDIO_INIT_ADDR      (AUDIO_ADDR + 0x10)
#define AUDIO_COUNT_ADDR     (AUDIO_ADDR + 0x14)

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
  // 获取音频缓冲区的起始地址和结束地址
  uint8_t *buf_start = ctl->buf.start;
  uint8_t *buf_end = ctl->buf.end;

  // 计算缓冲区的大小
  int len = buf_end - buf_start;

  // 将音频数据写入 audio-sbuf（起始地址应为 AUDIO_SBUF_ADDR）
  uint8_t *sbuf = (uint8_t *)AUDIO_SBUF_ADDR;

   for (int i = 0; i < len; i++) {
    sbuf[i] = buf_start[i];
  } 

  // 通知硬件样本增加
  outl(AUDIO_COUNT_ADDR, len);
}
