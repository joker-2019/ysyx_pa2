/* ysyxSoC TRM 启动代码
 * CPU 从 MROM(0x30000000) 取第一条指令执行 FLASH
 * 栈分配在 SRAM(0x0f000000) 中，由链接脚本定义 _stack_pointer
 *
 * 启动流程：
 *   1. 将 .rodata/.data 从 FLASH（MA/LMA）拷贝到 SRAM（SA/VMA）
 *   2. 将 .bss 段清零
 *   3. 跳转到 _trm_init
 */
.section entry, "ax"
.globl _start
.type _start, @function

_start:
  la   sp, _stack_pointer /* 立即把SP指向SRAM的栈顶，避免任何栈操作踩空 */
  /* 帧指针清零，方便调试时识别调用栈底部 */
  mv   s0, zero

  /* ---- bootloader: 拷贝 .rodata（MA->SA）---- */
  la   a0, _rodata_ma
  la   a1, _rodata_sa
  la   a2, _rodata_len
  add  a2, a1, a2
  beq  a1, a2, .Ldata_init
.Lrodata_copy:
  lw   t0, 0(a0)
  sw   t0, 0(a1)
  addi a0, a0, 4
  addi a1, a1, 4
  blt  a1, a2, .Lrodata_copy

  /* ---- bootloader: 拷贝 .data（MA->SA）----
   * a0 = MA: _data_ma  (MROM load address)
   * a1 = SA: _data_sa  (FLASH run address)
   * a2 = SA_end = SA + LEN
   */
.Ldata_init:
  la   a0, _data_ma
  la   a1, _data_sa
  la   a2, _data_len
  add  a2, a1, a2
  beq  a1, a2, .Lbss_init   /* .data 为空时跳过 */
.Ldata_copy:
  /* 链接脚本已保证 .data 的 MA/SA/LEN 按 4 字节对齐，使用字拷贝 */
  lw   t0, 0(a0)
  sw   t0, 0(a1)
  addi a0, a0, 4
  addi a1, a1, 4
  blt  a1, a2, .Ldata_copy

  /* ---- 清零 .bss 段：_bss_start.._bss_end ---- */
.Lbss_init:
  la   a1, _bss_start
  la   a2, _bss_end
  beq  a1, a2, .Lstack_init
.Lbss_zero:
  sw   zero, 0(a1)
  addi a1, a1, 4
  blt  a1, a2, .Lbss_zero

  /* ---- 跳转到 TRM 初始化函数 ---- */
.Lstack_init:
  jal  _trm_init
