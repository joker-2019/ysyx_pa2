/* ysyxSoC 专用链接脚本
 *
 * 内存布局：
 *   MROM  0x20000000  4KB  只读（CPU 复位入口，存放代码、只读数据、.data 初始值）
 *   SRAM  0x0f000000  8KB  可读写（.data 运行时、.bss、栈、堆）
 *
 * .data 段采用 LMA/VMA 分离方案：
 *   LMA（加载地址）= MROM（ELF 文件中存储初始值，紧接 .rodata）
 *   VMA（运行地址）= SRAM（运行时读写）
 *   启动代码负责将 .data 从 MROM 拷贝到 SRAM。
 */
ENTRY(_start)

MEMORY {
  mrom : ORIGIN = 0x20000000, LENGTH = 0x1000   /* 4KB MROM */
  sram : ORIGIN = 0x0f000000, LENGTH = 0x2000   /* 8KB SRAM */
}
/*
* PHDRS（Program Headers）：定义 ELF 文件的程序头（供加载器使用），标记哪些段需要加载到内存；
* text PT_LOAD：标记 .text 段为可加载  data PT_LOAD：标记 .bss 等数据段为可加载
*/
PHDRS {
  text PT_LOAD;
  data PT_LOAD;
}

SECTIONS {
  /* ---- MROM：代码 + 只读数据 + .data 初始值（LMA） ---- */
  . = ORIGIN(mrom);

  .text : {
    *(entry)        /* _start 必须是第一条指令 代码段（存放指令）*/
    *(.text*)
  } > mrom : text

  .rodata : {
    *(.rodata*)
    *(.srodata*)
  } > mrom

  /* 记录 .data 在 MROM 中的加载起始地址（LMA） */
  _data_lma = .;

  /* .data：LMA 在 MROM（AT(_data_lma)），VMA 在 SRAM（> sram） */
  .data : AT(_data_lma) {
    _data_start = .;        /* VMA 起始（SRAM 运行地址） */
    *(.data)
    *(.data*)
    *(.sdata*)
    . = ALIGN(4);
    _data_end = .;          /* VMA 结束 */
  } > sram : data

  /* ---- SRAM：BSS + 栈 + 堆 ---- */

  .bss (NOLOAD) : {
    _bss_start = .;
    *(.bss*)
    *(.sbss*)
    *(.scommon)
    . = ALIGN(4);
    _bss_end = .;
  } > sram

  /* 栈：紧跟 BSS，向高地址增长，分配 4KB */
  _stack_top     = ALIGN(0x10);
  . = _stack_top + 0x1000;
  _stack_pointer = .;

  /* 堆：栈之后到 SRAM 末尾 */
  _heap_start = ALIGN(0x10);
  _heap_end   = ORIGIN(sram) + LENGTH(sram);
}
