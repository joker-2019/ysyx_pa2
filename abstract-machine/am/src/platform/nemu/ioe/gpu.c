#include <am.h>
#include <nemu.h>

#define SYNC_ADDR (VGACTL_ADDR + 4)

void __am_gpu_init() {
}

void __am_gpu_config(AM_GPU_CONFIG_T *cfg) {
  //从vgactl寄存器中读取显示设备的配置.
  uint32_t vga = inl(VGACTL_ADDR);
  uint32_t W = (vga >> 16) & 0xFFFF; // 获取宽度
  uint32_t H = vga & 0xFFFF;         // 获取高度
  *cfg = (AM_GPU_CONFIG_T) {
    .present = true, .has_accel = false,
    .width = W, .height = H,
    .vmemsz = 0
  };
}

void __am_gpu_fbdraw(AM_GPU_FBDRAW_T *ctl) {
  int x = ctl->x, y = ctl->y, w = ctl->w, h = ctl->h;
  if (!ctl->sync && (w == 0 || h == 0)) return; //如果不需要同步, 且宽度或高度为0, 则直接返回.

  //将ctl->pixels中的像素数据绘制到帧缓冲区中.
  uint32_t *fb = (uint32_t *)(uintptr_t)FB_ADDR;
  uint32_t screen_w = inl(VGACTL_ADDR) >> 16; // 读取VGACTL寄存器以确保设备已准备好
  uint32_t *pixels = ctl->pixels;
  for (int j = 0; j < h; j++) { // 遍历高度
    for (int i = 0; i < w; i++) { // 遍历宽度
      fb[(y + j) * screen_w + (x + i)] = pixels[j * w + i];
    }
  }
  if (ctl->sync) {
    //如果需要同步, 则向VGACTL寄存器的同步地址写入1.
    outl(SYNC_ADDR, 1);
  }

}

void __am_gpu_status(AM_GPU_STATUS_T *status) {
  status->ready = true;
}
