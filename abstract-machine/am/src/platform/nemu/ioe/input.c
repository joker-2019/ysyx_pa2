#include <am.h>
#include <nemu.h>

#define KEYDOWN_MASK 0x8000

void __am_input_keybrd(AM_INPUT_KEYBRD_T *kbd) {

    uint32_t key_code = inl(0x60);
    // 设置键盘状态
    kbd->keydown = (key_code & KEYDOWN_MASK) ? 1 : 0;  // 检查按键是否被按下
    kbd->keycode = key_code & ~KEYDOWN_MASK;  // 获取按键的断码, 去掉KEYDOWN_MASK位

  
}
