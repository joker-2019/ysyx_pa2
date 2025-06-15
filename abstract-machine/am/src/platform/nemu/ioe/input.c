#include <am.h>
#include <nemu.h>

#define KEYDOWN_MASK 0x8000

#define KEY_QUEUE_LEN 1024  // 定义一个宏, 用于定义键盘输入队列的长度
static int key_queue[KEY_QUEUE_LEN] = {};  // 定义一个数组, 用于存储键盘输入的断码
static int queue_head = 0, queue_tail = 0;  // 定义两个变量, 分别表示队列的头和尾

static void keyboard_interrupt() {
  // 读取键盘状态
  uint8_t status = inb(0x64);

  // 检查是否有数据可读
  if (status & 0x01) {
    uint8_t key = inb(0x60);

    // 将按键存入队列
    key_queue[queue_tail] = key;
    queue_tail = (queue_tail + 1) % KEY_QUEUE_LEN;
  }
}


void __am_input_keybrd(AM_INPUT_KEYBRD_T *kbd) {
  //AM_INPUT_KEYBRD_T是一个结构体, 包含两个成员: keydown和keycode.
  //keydown表示按键是否被按下, keycode表示按键的断码
  //AM_INPUT_KEYBRD_T是一个输入设备的状态结构体, 用于表示键盘输入的状态.
  // 检查并处理键盘中断
  keyboard_interrupt();
  // 如果队列不为空, 则从队列中取出一个按键
  if (queue_head != queue_tail) {
      // 有按键在队列中
      uint32_t key_code = key_queue[queue_head];
      queue_head = (queue_head + 1) % KEY_QUEUE_LEN;
      
      // 设置键盘状态
      kbd->keydown = (key_code & KEYDOWN_MASK) ? 1 : 0;  // 检查按键是否被按下
      kbd->keycode = key_code & ~KEYDOWN_MASK;  // 获取按键的断码, 去掉KEYDOWN_MASK位
  }else{
      // 队列为空, 设置默认值
      kbd->keydown = 0;  // 没有按键被按下
      kbd->keycode = AM_KEY_NONE;  // 设置为无效按键
  }
  
}
