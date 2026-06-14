/* ysyxSoC TRM 两级 bootloader 启动代码
 *
 * 内存布局：
 *   FLASH  0x30000000  存放 FSBL/SSBL/程序的初始化镜像（LMA）
 *   SRAM   0x0f000000  SSBL 运行地址（VMA），栈分配在 SRAM 顶部向低地址增长
 *   PSRAM  0x80000000  程序运行地址（VMA）
 *
 * 启动流程：
 *   1. FSBL（VMA=LMA=FLASH）原地执行：
 *        - 初始化栈指针到 SRAM 顶部
 *        - 将 SSBL 从 FLASH 拷贝到 SRAM
 *        - 跳转到 SRAM 中的 SSBL 执行
 *   2. SSBL（VMA=SRAM，LMA=FLASH）在 SRAM 执行：
 *        - 将 .text/.rodata/.data/.data.extra 从 FLASH 拷贝到 PSRAM
 *        - 将 .bss 段清零
 *        - 跳转到 _trm_init 开始执行程序
 */

/* ================================================================
 * FSBL: 在 FLASH 中原地执行（VMA = LMA = FLASH）
 * ================================================================ */
.section fsbl, "ax"
.globl _start
.type _start, @function

_start:
  la   sp, _stack_pointer    /* 立即把 SP 指向 SRAM 的栈顶，避免任何栈操作踩空 */
  mv   s0, zero              /* 清零帧指针，方便调试时识别调用栈底部 */

  /* ---- 将 SSBL 从 FLASH（_ssbl_ma）拷贝到 SRAM（_ssbl_sa）---- */
  la   a0, _ssbl_ma          /* 源地址：SSBL 在 FLASH 中的 LMA */
  la   a1, _ssbl_sa          /* 目标地址：SSBL 在 SRAM 中的 VMA */
  la   a2, _ssbl_len
  add  a2, a1, a2            /* a2 = 拷贝结束地址 */
  beq  a1, a2, .Ljump_ssbl  /* SSBL 为空时直接跳过（理论上不会发生） */
.Lfsbl_copy:
  lw   t0, 0(a0)
  sw   t0, 0(a1)
  addi a0, a0, 4
  addi a1, a1, 4
  blt  a1, a2, .Lfsbl_copy

  /* ---- 跳转到 SRAM 中已拷贝好的 SSBL ---- */
.Ljump_ssbl:
  la   t0, _ssbl_sa
  jalr t0

/* ================================================================
 * SSBL: 由 FSBL 拷贝到 SRAM 后执行（VMA = SRAM，LMA = FLASH）
 *
 * 注意：此段在 SRAM 中执行，但目标程序的 LMA（_text_ma 等）在 FLASH 中，
 *       因为 SRAM 可读写、FLASH 也可寻址，两者均在当前阶段可访问。
 *       .bss 的 VMA 在 PSRAM 中，由下面的清零循环负责填充，
 *       PSRAM 在当前阶段同样可读写访问。
 * ================================================================ */
.section ssbl, "ax"

  /* ---- 拷贝 .text（FLASH -> PSRAM）---- */
  la   a0, _text_ma
  la   a1, _text_sa
  la   a2, _text_len
  add  a2, a1, a2
  beq  a1, a2, .Lrodata_init
.Ltext_copy:
  lw   t0, 0(a0)
  sw   t0, 0(a1)
  addi a0, a0, 4
  addi a1, a1, 4
  blt  a1, a2, .Ltext_copy

  /* ---- 拷贝 .rodata（FLASH -> PSRAM）---- */
.Lrodata_init:
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

  /* ---- 拷贝 .data（FLASH -> PSRAM）---- */
.Ldata_init:
  la   a0, _data_ma
  la   a1, _data_sa
  la   a2, _data_len
  add  a2, a1, a2
  beq  a1, a2, .Lbss_init
.Ldata_copy:
  lw   t0, 0(a0)
  sw   t0, 0(a1)
  addi a0, a0, 4
  addi a1, a1, 4
  blt  a1, a2, .Ldata_copy

  /* ---- 拷贝 .data.extra（FLASH -> PSRAM）----
   * 【RT-Thread 专用，已用 #if 0 关闭】此段仅在引入 extra.ld 时存在；普通程序
   * (如 mem-test) 不含 extra.ld，链接脚本中 _data_extra_* 符号也已注释。
   * 测试 RT-Thread 时把下面的 #if 0 改回 #if 1（并恢复链接脚本中的符号定义）。
   * 关闭后，.Ldata_copy 结束会直接落入 .Lbss_init。 */
#if 0
  la   a0, _data_extra_ma
  la   a1, _data_extra_sa
  la   a2, _data_extra_len
  add  a2, a1, a2
  beq  a1, a2, .Lbss_init
.Ldata_extra_copy:
  lw   t0, 0(a0)
  sw   t0, 0(a1)
  addi a0, a0, 4
  addi a1, a1, 4
  blt  a1, a2, .Ldata_extra_copy
#endif

  /* ---- 清零 .bss 段（PSRAM 中）：_bss_start.._bss_end ---- */
.Lbss_init:
  la   a1, _bss_start
  la   a2, _bss_end
  beq  a1, a2, .Ltrm_init
.Lbss_zero:
  sw   zero, 0(a1)
  addi a1, a1, 4
  blt  a1, a2, .Lbss_zero

  /* ---- 跳转到 TRM 初始化函数（PSRAM 中）---- */
.Ltrm_init:
  la   t0, _trm_init
  jalr t0
