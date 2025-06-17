/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <common.h>
#include <device/map.h>
#include <SDL2/SDL.h>

enum {
  reg_freq, // Audio frequency 音频频率
  reg_channels, // Number of audio channels
  reg_samples, // Number of samples in the audio buffer
  reg_sbuf_size, // Size of the sample buffer
  reg_init, // Initialization status
  reg_count, // Sample count
  nr_reg // Total number of audio registers
};

static uint8_t *sbuf = NULL;
static uint32_t *audio_base = NULL; // Base address for audio registers
static SDL_AudioDeviceID dev = 0; // SDL audio device ID
static SDL_AudioSpec obtained; // Audio specifications

// Audio callback function
static void audio_callback(void *userdata, uint8_t *stream, int len) {
  if(audio_base[reg_count] > 0) { // 如果有样本可用，则继续处理；否则直接返回（输出静音）
    int nread = len < audio_base[reg_count] ? len : audio_base[reg_count]; // Read up to 'len' bytes from the sample buffer
    memcpy(stream, sbuf, nread);  // 将 nread 字节的样本从 sbuf 复制到输出流 stream
    memmove(sbuf, sbuf + nread, audio_base[reg_count] - nread); // 使用 memmove 函数将剩余样本向前移动
    audio_base[reg_count] -= nread; // 更新可用样本数量
    if(len > nread){
      memset(stream + nread, 0, len - nread); // 如果复制的样本不足以填满整个缓冲区（len > nread），则剩余部分填充 0
    }
  } else {
      memset(stream, 0, len);  // 没有样本时，全部填充为0
  }
}

// Audio I/O handler
static void audio_io_handler(uint32_t offset, int len, bool is_write) {
  if (offset == reg_init * sizeof(uint32_t) && is_write) {
    //// Initialize audio device
    if(audio_base[reg_init]){
      SDL_CloseAudioDevice(dev); // Close the audio device if it was already initialized
      // 初始化SDL音频子系统(如果需要)
      if (SDL_WasInit(SDL_INIT_AUDIO) == 0) {
          if (SDL_InitSubSystem(SDL_INIT_AUDIO) != 0) {
              Log("SDL音频初始化失败: %s", SDL_GetError());
              return;
          }
      }
      // Configure audio specifications
      SDL_AudioSpec s = {};
      s.freq = audio_base[reg_freq]; // Set audio frequency
      s.format = AUDIO_S16SYS;
      s.channels = audio_base[reg_channels]; // Set number of channels
      s.samples = audio_base[reg_samples]; // Set number of samples in the buffer
      s.callback = audio_callback;
      s.userdata = NULL;

      dev = SDL_OpenAudioDevice(NULL, 0, &s, &obtained, 0); // Open the audio device
      if (dev == 0) {
        printf("Failed to open audio device: %s\n", SDL_GetError());
        return;
      } else {
        // 验证获得的参数是否匹配
        if (obtained.freq != s.freq || obtained.format != s.format || 
              obtained.channels != s.channels) {
              Log("音频设备不支持请求的格式");
        }
        SDL_PauseAudioDevice(dev, 0); // Start playing audio
      }

    }
  } else if(offset == reg_count * sizeof(uint32_t) && !is_write) {
    // Return current count of available samples
    return;
  }
}

void init_audio() {
  uint32_t space_size = sizeof(uint32_t) * nr_reg;
  audio_base = (uint32_t *)new_space(space_size);
#ifdef CONFIG_HAS_PORT_IO
  add_pio_map ("audio", CONFIG_AUDIO_CTL_PORT, audio_base, space_size, audio_io_handler);
#else
  add_mmio_map("audio", CONFIG_AUDIO_CTL_MMIO, audio_base, space_size, audio_io_handler);
#endif

  sbuf = (uint8_t *)new_space(CONFIG_SB_SIZE);
  add_mmio_map("audio-sbuf", CONFIG_SB_ADDR, sbuf, CONFIG_SB_SIZE, NULL);
}
