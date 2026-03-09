/* ysyxSoC TRM 启动代码
 * CPU 从 MROM(0x20000000) 取第一条指令执行
 * 栈分配在 SRAM(0x0f000000) 中，由链接脚本定义 _stack_pointer
 *
 * 启动流程：
 *   1. 将 .data 段从 MROM（LMA）拷贝到 SRAM（VMA）
 *   2. 将 .bss 段清零
 *   3. 设置栈指针，跳转到 _trm_init
 */
.section entry, "ax"
.globl _start
.type _start, @function

_start:
  /* 帧指针清零，方便调试时识别调用栈底部 */
  mv   s0, zero

  /* ---- 拷贝 .data 段：从 MROM(_data_lma) 到 SRAM(_data_start.._data_end) ---- */
  la   a0, _data_lma    /* a0 = LMA（MROM 中的源地址） */
  la   a1, _data_start  /* a1 = VMA 起始（SRAM 目标地址） */
  la   a2, _data_end    /* a2 = VMA 结束 */
  beq  a1, a2, .Lbss_init   /* .data 为空时跳过 */
.Ldata_copy:
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

  /* ---- 加载栈顶指针，跳转到 TRM 初始化函数 ---- */
.Lstack_init:
  la   sp, _stack_pointer
  jal  _trm_init
