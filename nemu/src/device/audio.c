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
  // static int audio_read_pos = 0; // Position in the sample buffer for reading

  // Audio callback function
  static void audio_callback(void *userdata, uint8_t *stream, int len) {
     if(audio_base[reg_count] > 0) { // 如果有样本可用，则继续处理；否则直接返回（输出静音）
      printf("Audio callback called with len: %d, available samples: %d\n", len, audio_base[reg_count]);
      int nread = len < audio_base[reg_count] ? len : audio_base[reg_count]; // Read up to 'len' bytes from the sample buffer
      if (nread > CONFIG_SB_SIZE) nread = CONFIG_SB_SIZE; // 确保读取的样本不超过缓冲区大小
      memcpy(stream, sbuf, nread);  // 将 nread 字节的样本从 sbuf 复制到输出流 stream
/*    // 剩余有效样本数量
      int remain = audio_base[reg_count] - nread;
      // 将剩余样本向前移动
      memmove(sbuf, sbuf + nread, remain);
      memset(sbuf + remain, 0, CONFIG_SB_SIZE - remain);
      audio_base[reg_count] = remain; */

      memmove(sbuf, sbuf + nread, CONFIG_SB_SIZE - nread); // 使用 memmove 函数将剩余样本向前移动
      // 清零缓冲区尾部，避免残留旧数据
      memset(sbuf + audio_base[reg_count] - nread, 0, nread);
      // 清零剩余空间，避免残留脏数据导致杂音
      audio_base[reg_count] -= nread; // 更新可用样本数量
      if(len > nread){
        printf("Audio callback: not enough samples, filling with silence\n");
        memset(stream + nread, 0, len - nread); // 如果复制的样本不足以填满整个缓冲区（len > nread），则剩余部分填充 0
      }
    } else {
      printf("Audio callback called with len: %d, but no samples available\n", len);
        memset(stream, 0, len);  // 没有样本时，全部填充为0
    } 
/*   uint32_t count = audio_base[reg_count];
  printf("audio_callback called with len: %d, available samples: %d\n", len, count);
  uint32_t sbuf_size = audio_base[reg_sbuf_size];
  printf("sbuf_size: %d\n", sbuf_size);

  int nread = (len < count) ? len : count;
    printf("nread: %d\n", nread);

  for (int i = 0; i < nread; i++) {
    stream[i] = sbuf[(audio_read_pos + i) % sbuf_size];
  }
  audio_read_pos = (audio_read_pos + nread) % sbuf_size;
  audio_base[reg_count] -= nread;
  if (nread < len) {
    memset(stream + nread, 0, len - nread); // 剩余部分填0（静音）
  }
  // Debug log
  printf("audio_callback: len = %d, nread = %d, remaining = %d\n", len, nread, audio_base[reg_count]); */
  }

  // Audio I/O handler
  static void audio_io_handler(uint32_t offset, int len, bool is_write) {
    uint32_t index = offset / sizeof(uint32_t); // Calculate the register index based on the offset
    if(is_write && index == reg_init && audio_base[reg_init]) {
        //clean old status
        audio_base[reg_init] = 0; // Reset initialization status
        memset(sbuf, 0, CONFIG_SB_SIZE); // Clear the sample buffer 
        audio_base[reg_count] = 0;
        if(dev){
          SDL_CloseAudioDevice(dev); // Close the audio device if it was previously opened
          dev = 0; // Reset the device ID
        }
        // Initialize SDL audio subsystem if not already initialized
        if(SDL_WasInit(SDL_INIT_AUDIO) == 0) {
          if (SDL_InitSubSystem(SDL_INIT_AUDIO) != 0) {
            Log("SDL音频初始化失败: %s", SDL_GetError());
            return;
          }
        }     
    
      // Configure audio specifications
      SDL_AudioSpec s = {
        .freq = audio_base[reg_freq], // Set audio frequency
        .format = AUDIO_S16SYS,
        .channels = audio_base[reg_channels], // Set number of channels
        .samples = audio_base[reg_samples], // Set number of samples in the buffer
        .callback = audio_callback,
        .userdata = NULL
      };
        
      dev = SDL_OpenAudioDevice(NULL, 0, &s, &obtained, 0); // Open the audio device
      if (dev == 0) {
        printf("Failed to open audio device: %s\n", SDL_GetError());
        return;
      }
      // 验证获得的参数是否匹配
      if (obtained.freq != s.freq || obtained.format != s.format || obtained.channels != s.channels) {
          Log("音频设备不支持请求的格式");
      }
      SDL_PauseAudioDevice(dev, 0); // Start playing audio
    }
    // 读取 count 寄存器的情况（为 completeness 保留）
    if (!is_write && index == reg_count) {
      uint32_t val = audio_base[reg_count];
      memcpy((void *)(&audio_base[reg_count]), &val, sizeof(uint32_t));
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
