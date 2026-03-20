/* ysyxSoC 专用链接脚本
 *
 * 内存布局：
 *   MROM  0x20000000  4KB  只读（CPU 复位入口，存放代码 + rodata/data 初始化镜像）
 *   SRAM  0x0f000000  8KB  可读写（.rodata/.data 运行时、.bss、栈、堆）
 *
 * .rodata/.data 段采用 LMA/VMA 分离方案：
 *   LMA（加载地址）= MROM（ELF 文件中存储初始化镜像）
 *   VMA（运行地址）= SRAM（运行时访问地址）
 *   启动代码负责将 .rodata/.data 从 MROM 拷贝到 SRAM。
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

  /* 切换到 SRAM，放置运行时 rodata/data */
  . = ORIGIN(sram);

  /* .rodata：VMA 在 SRAM，LMA 在 MROM(.text 之后) */
  .rodata : AT(ALIGN(LOADADDR(.text) + SIZEOF(.text), 4)) {
    _rodata_start = .;
    *(.rodata*)
    *(.srodata*)
    . = ALIGN(4);
    _rodata_end = .;
  } > sram : data

  /* .data：VMA 在 SRAM，LMA 紧跟 .rodata 的 LMA */
  .data : AT(ALIGN(LOADADDR(.rodata) + SIZEOF(.rodata), 4)) {
    _data_start = .;        /* VMA 起始（SRAM 运行地址） */
    *(.data)
    *(.data*)
    *(.sdata*)
    . = ALIGN(4);
    _data_end = .;          /* VMA 结束 */
  } > sram : data

  /* 显式导出 MA/SA/LEN，供启动代码拷贝 .rodata/.data 使用 */
  _rodata_ma  = LOADADDR(.rodata);
  _rodata_sa  = ADDR(.rodata);
  _rodata_len = SIZEOF(.rodata);

  _data_ma  = LOADADDR(.data);
  _data_sa  = ADDR(.data);
  _data_len = SIZEOF(.data);
  _data_lma = _data_ma;

  /* ---- SRAM：BSS + 栈 + 堆 ---- */

  .bss (NOLOAD) : {
    _bss_start = .;
    *(.bss*)
    *(.sbss*)
    *(.scommon)
    . = ALIGN(4);
    _bss_end = .;
  } > sram :NONE

  /* 堆：放在 .bss 之后，避免覆盖全局变量 */
  _heap_start = ALIGN(_bss_end, 0x10);

  /* 栈：固定在 SRAM 末尾，向低地址增长，分配 4KB */
  /* 堆范围是 [heap_start, stack_top)  栈范围是[stack_top, sram_end) 动态加载获取 SRAM 首尾地址*/
  _stack_pointer = ORIGIN(sram) + LENGTH(sram);
  _stack_top     = _stack_pointer - 0x1000;
  _heap_end      = _stack_top;
}
