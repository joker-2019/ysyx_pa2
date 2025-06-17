#include <am.h>
#include <nemu.h>

#define AUDIO_FREQ_ADDR      (AUDIO_ADDR + 0x00)
#define AUDIO_CHANNELS_ADDR  (AUDIO_ADDR + 0x04)
#define AUDIO_SAMPLES_ADDR   (AUDIO_ADDR + 0x08)
#define AUDIO_SBUF_SIZE_ADDR (AUDIO_ADDR + 0x0c)
#define AUDIO_INIT_ADDR      (AUDIO_ADDR + 0x10)
#define AUDIO_COUNT_ADDR     (AUDIO_ADDR + 0x14)

void __am_audio_init() {
}

void __am_audio_config(AM_AUDIO_CONFIG_T *cfg) {
  // 检查音频控制器是否存在
  if (!inl(AUDIO_ADDR)) {
    cfg->present = false;
    return;
  }
  // 读取音频缓冲区大小
  // 注意: 在实际硬件中，可能需要通过特定的寄存器或方法来获取音频缓冲区的大小
  // 此处假设AUDIO_SBUF_SIZE_ADDR是一个有效的地址，用于获取音频缓冲区大小
  // 在NEMU中，AUDIO_SBUF_SIZE_ADDR可能需要根据具体实现进行调整
  if (AUDIO_SBUF_SIZE_ADDR < MMIO_BASE || AUDIO_SBUF_SIZE_ADDR >= MMIO_BASE + 0x1000) {
    cfg->present = false;
    return;
  }
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
  
  // 将音频数据写入音频控制器的缓冲区
  for (int i = 0; i < len; i++) {
    outb(AUDIO_ADDR + i, buf_start[i]);
  }
}
