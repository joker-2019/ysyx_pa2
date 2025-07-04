include $(AM_HOME)/scripts/isa/riscv.mk
include $(AM_HOME)/scripts/platform/npc.mk
# 指定目标架构为 ​​RV32E​​（精简嵌入式架构，仅16个通用寄存器）并启用 ​​Zicsr扩展​​（支持控制和状态寄存器操作），适用于资源受限的嵌入式场景
# 设置ABI（应用二进制接口）为 ​​ILP32E​​，规定：
# int、long、指针为32位（ILP32）
# 寄存器传递规则适配RV32E的16寄存器架构（E后缀）
COMMON_CFLAGS += -march=rv32e_zicsr -mabi=ilp32e  # overwrite  
LDFLAGS       += -melf32lriscv                    # overwrite 链接器选项，指定输出目标文件格式为 ​​ELF32（小端序）​​，匹配32位RISC-V架构

AM_SRCS += riscv/npc/libgcc/div.S \
	riscv/npc/libgcc/muldi3.S \
	riscv/npc/libgcc/multi3.c \
	riscv/npc/libgcc/ashldi3.c \
	riscv/npc/libgcc/unused.c