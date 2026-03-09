# ysyxSoC 平台 AM 源文件列表 s代表.S文件 c代表.c文件 SR代表源文件source
AM_SRCS := riscv/ysyxsoc/start.S \
           riscv/ysyxsoc/trm.c \
           platform/dummy/vme.c \
           platform/dummy/mpe.c
# 编译（CFLAGS）和链接（LDFLAGS）参数  - -fdata-sections：每个全局变量单独生成一个数据段； - -ffunction-sections：每个函数单独生成一个代码段；
# 作用：为后续链接时的 “垃圾回收” 做准备，只保留用到的段。  - --gc-sections：开启 “垃圾回收”，删除未被使用的代码段 / 数据段
CFLAGS  += -fdata-sections -ffunction-sections
LDFLAGS += -T $(AM_HOME)/scripts/ysyxsoc-linker.ld
LDFLAGS += --gc-sections -e _start  # 指定程序的入口点为 _start（对应 start.S 中的 _start 符号)

CFLAGS  += -DMAINARGS=\"$(mainargs)\"
.PHONY: $(AM_HOME)/am/src/riscv/ysyxsoc/trm.c

# objdump -d：反汇编 ELF 文件的代码段，输出到 $(IMAGE).txt，方便调试（查看汇编指令）； --set-section-flags .bss=alloc,contents设置 .bss 段（未初始化全局变量）的属性为 “可分配 + 有内容”，确保 .bss 段被包含到 bin 文件中；
image: $(IMAGE).elf
	@$(OBJDUMP) -d $(IMAGE).elf > $(IMAGE).txt
	@echo + OBJCOPY "->" $(IMAGE_REL).bin
	@$(OBJCOPY) -S --set-section-flags .bss=alloc,contents -O binary $(IMAGE).elf $(IMAGE).bin

.PHONY: run
run: image
	@echo + RUNNING $(IMAGE).bin ON ysyxSoC NPC
	$(MAKE) -C $(NPC_HOME) ISA=$(ISA) run ARGS="-e $(IMAGE).elf $(IMAGE).bin" IMG=$(IMAGE).bin
# $(MAKE) -C $(NPC_HOME) 进入 $(NPC_HOME)（NPC 模拟器的目录）执行 make；
# ISA=$(ISA)：传递给 NPC 模拟器的 ISA 参数，确保使用正确的指令集架构；
# ARGS="-e $(IMAGE).elf $(IMAGE).bin"：传递给 NPC 模拟器的参数，-e 指定 ELF 文件，$(IMAGE).bin 指定 bin 文件；
# IMG=$(IMAGE).bin：指定 bin 文件，用于后续的仿真；