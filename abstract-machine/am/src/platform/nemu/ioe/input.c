#include <am.h>
#include <nemu.h>

#define KEYDOWN_MASK 0x8000
static uint32_t key_state = 0; // 跟踪所有按键状态
#define KEY_MASK(key) (1 << (key & 0x1F)) // 为每个键码分配一个位

void __am_input_keybrd(AM_INPUT_KEYBRD_T *kbd) {
    // 从键盘端口读取按键状态
    uint32_t key_code = inl(KBD_ADDR);
    // 设置键盘状态
    kbd->keydown = (key_code & KEYDOWN_MASK) ? 1 : 0;  // 检查按键是否被按下
    kbd->keycode = key_code & ~KEYDOWN_MASK;  // 获取按键的断码, 去掉KEYDOWN_MASK位
    // 更新全局按键状态
    if (kbd->keydown) {
        key_state |= KEY_MASK(kbd->keycode);  // 设置按键状态为按下
    } else {
        key_state &= ~KEY_MASK(kbd->keycode); // 清除按键状态
    }
}
