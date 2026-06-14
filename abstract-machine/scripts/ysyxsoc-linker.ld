/* ysyxSoC 专用链接脚本 - 两级 bootloader (FSBL + SSBL)
 *
 * 内存布局：
 *   FLASH 0x30000000  16MB  存放 FSBL/SSBL/程序的初始化镜像（LMA）
 *   SRAM  0x0f000000  8KB   SSBL 运行地址（VMA 底部）+ 栈（顶部向低地址增长）
 *   PSRAM 0x80000000  4MB   程序运行地址（VMA）
 *
 * LMA/VMA 分离方案：
 *   .fsbl  VMA=LMA=FLASH：FSBL 在 FLASH 中原地执行
 *   .ssbl  LMA=FLASH（紧跟 .fsbl）, VMA=SRAM 底部：FSBL 将其拷贝到 SRAM 再执行
 *   .text/.rodata/.data  LMA=FLASH（紧跟 .ssbl）, VMA=PSRAM：SSBL 将其拷贝到 PSRAM 再执行
 *   .bss   NOLOAD，VMA=PSRAM：SSBL 负责清零
 *   栈     始终位于 SRAM 顶部，向低地址增长
 */
ENTRY(_start)

MEMORY {
  /* mrom : ORIGIN = 0x20000000, LENGTH = 0x1000  4KB MROM  */
  flash : ORIGIN = 0X30000000, LENGTH = 0X01000000  /* 16MB FLASH */
  sram : ORIGIN = 0x0f000000, LENGTH = 0x2000   /* 8KB SRAM */
  psram : ORIGIN = 0x80000000, LENGTH = 0x400000 /* 4MB PSRAM */
}

SECTIONS {
  /* ---- FLASH：FSBL（VMA = LMA = FLASH，CPU 复位后原地执行）---- */
  . = ORIGIN(flash);

  .fsbl : {
    KEEP(*(fsbl))   /* _start 必须是第一条指令 */
  } > flash

  /* ---- SRAM：SSBL（VMA = SRAM 底部，LMA = FLASH 紧跟 .fsbl）----
   *
   * FSBL 负责将此段从 FLASH LMA 拷贝到 SRAM VMA，然后跳转执行。
   * SSBL 体积小，放在 SRAM 底部；栈在 SRAM 顶部，两者不重叠。
   */
  . = ORIGIN(sram);

  .ssbl : AT(ALIGN(LOADADDR(.fsbl) + SIZEOF(.fsbl), 4)) {
    _ssbl_start = .;
    KEEP(*(ssbl))
    . = ALIGN(4);
    _ssbl_end = .;
  } > sram

  /* 供 FSBL 拷贝 SSBL 时使用的地址/长度符号 */
  _ssbl_ma  = LOADADDR(.ssbl);  /* SSBL 在 FLASH 中的加载地址（LMA） */
  _ssbl_sa  = ADDR(.ssbl);      /* SSBL 在 SRAM 中的运行地址（VMA） */
  _ssbl_len = SIZEOF(.ssbl);

  /* ---- PSRAM：程序运行时代码和数据（VMA），LMA 紧跟 .ssbl 之后在 FLASH ---- */
  . = ORIGIN(psram);

  /* .text：VMA 在 PSRAM，LMA 在 FLASH（紧跟 .ssbl 之后） */
  .text : AT(ALIGN(LOADADDR(.ssbl) + SIZEOF(.ssbl), 4)) {
    _text_start = .;
    *(.text*)
    . = ALIGN(4);
    _text_end = .;
  } > psram

  /* 供 SSBL 拷贝 .text 时使用的地址/长度符号 */
  _text_ma  = LOADADDR(.text);
  _text_sa  = ADDR(.text);
  _text_len = SIZEOF(.text);

  /* .rodata：VMA 在 PSRAM，LMA 在 FLASH（紧跟 .text 之后） */
  .rodata : AT(ALIGN(LOADADDR(.text) + SIZEOF(.text), 4)) {
    _rodata_start = .;
    *(.rodata*)
    *(.srodata*)
    . = ALIGN(4);
    _rodata_end = .;
  } > psram

  _rodata_ma  = LOADADDR(.rodata);
  _rodata_sa  = ADDR(.rodata);
  _rodata_len = SIZEOF(.rodata);

  /* .data：VMA 在 PSRAM，LMA 在 FLASH（紧跟 .rodata 之后）
   *
   * extra.ld 通过 INSERT AFTER .data 插入 .data.extra（带 AT() 指令），
   * 使 .data.extra 的 LMA 紧跟 .data 之后落入 FLASH，再由 SSBL 单独拷贝。
   */
  .data : AT(ALIGN(LOADADDR(.rodata) + SIZEOF(.rodata), 4)) {
    _data_start = .;
    *(.data)
    *(.data*)
    *(.sdata*)
    . = ALIGN(4);
    _data_end = .;
  } > psram

  _data_ma  = LOADADDR(.data);
  _data_sa  = ADDR(.data);
  _data_len = SIZEOF(.data);

  /* .data.extra 由 extra.ld INSERT AFTER .data 插入，其 LMA 紧跟 .data 之后，
   * 因此这些符号可在 SSBL 中用于将 .data.extra 从 FLASH 拷贝到 PSRAM。
   * 注：符号在 .data 段之后定义，此时 .data.extra 已通过 INSERT AFTER 加入布局。
   *
   * 【RT-Thread 专用，已注释】只有在引入 extra.ld 时 .data.extra 段才存在；
   * 普通程序(如 mem-test)不含 extra.ld，对不存在的段取 LOADADDR/ADDR/SIZEOF
   * 会触发 "undefined section `.data.extra'" 链接错误。测试 RT-Thread 时再恢复，
   * 并同步恢复 start.S 中 .data.extra 的拷贝循环。 */
  /*
  _data_extra_ma  = LOADADDR(.data.extra);
  _data_extra_sa  = ADDR(.data.extra);
  _data_extra_len = SIZEOF(.data.extra);
  */

  /* ---- PSRAM：BSS + 堆 ---- */

  /* extra.ld 通过 INSERT BEFORE .bss 在 .data.extra 和 .bss.extra 之后插入，
   * 但 GNU ld 的 INSERT 指令不更新主脚本的位置计数器，导致 .bss VMA 与
   * .data.extra 重叠——SSBL BSS 清零循环会覆盖已写入的 .rti_fn* 函数指针。
   * 修复：extra.ld 在 .bss.extra 末尾定义 _bss_extra_end；此处用显式 VMA 表达式
   * 设置 .bss 起始地址，令其紧跟所有 INSERT 段之后。
   * PROVIDE 为无 extra.ld 场景提供安全的后备值（. = 当前位置）。 */
  PROVIDE(_bss_extra_end = .);

  .bss _bss_extra_end (NOLOAD) : {
    _bss_start = .;
    *(.bss*)
    *(.sbss*)
    *(.scommon)
    . = ALIGN(4);
    _bss_end = .;
  } > psram

  /* 堆：放在 .bss 之后，上限为 PSRAM 末尾 */
  _heap_start = ALIGN(_bss_end, 0x10);
  _heap_end   = ORIGIN(psram) + LENGTH(psram);

  /* ---- SRAM：仅放栈，向低地址增长（.ssbl 在 SRAM 底部，栈在 SRAM 顶部）---- */
  _stack_pointer = ORIGIN(sram) + LENGTH(sram);
  _stack_top     = ORIGIN(sram);
}
