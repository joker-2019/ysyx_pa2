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

# 仅改链接脚本时，.o/.a 时间戳不变，Make 默认不会重链接 .elf；显式把 .ld 列为依赖
$(IMAGE).elf: $(AM_HOME)/scripts/ysyxsoc-linker.ld

CFLAGS  += -DMAINARGS=\"$(mainargs)\"
.PHONY: $(AM_HOME)/am/src/riscv/ysyxsoc/trm.c

# objdump -d：反汇编 ELF 文件的代码段，输出到 $(IMAGE).txt，方便调试（查看汇编指令）
# ysyxSoC 使用 MROM+SRAM 分离地址，.bss 由启动代码清零，不应打包进 bin
# @$(OBJCOPY) -S --set-section-flags .bss=alloc,contents -O binary $(IMAGE).elf $(IMAGE).bin 
# .bss段专门存放未初始化 / 初始值为 0 的全局 / 静态变量   
# 会把.bss段的大小全部用 0 填充进 bin，比如你的.bss段有 16KB，bin 就会多 16KB 的 0；
# 如果地址分离，甚至会生成几百 MB / 几 GB 的无效 bin
# 旧的编译包含.text(代码)、.rodata(只读数据)、.data(有初值的变量)、强制加入的.bss段（全 0 填充） 体积巨大
# 现在的做法是仅包含.text、.rodata、.data三个必须的段，无任何冗余内容
image: $(IMAGE).elf
	@$(OBJDUMP) -d $(IMAGE).elf > $(IMAGE).txt
	@echo + OBJCOPY "->" $(IMAGE_REL).bin
	@$(OBJCOPY) -S -j .text -j .rodata -j .data -O binary $(IMAGE).elf $(IMAGE).bin	

.PHONY: run
run: image
	@echo + RUNNING $(IMAGE).bin ON ysyxSoC NPC
	$(MAKE) -C $(NPC_HOME) ISA=$(ISA) run ARGS="-e $(IMAGE).elf $(IMAGE).bin" IMG=$(IMAGE).bin
# $(MAKE) -C $(NPC_HOME) 进入 $(NPC_HOME)（NPC 模拟器的目录）执行 make；
# ISA=$(ISA)：传递给 NPC 模拟器的 ISA 参数，确保使用正确的指令集架构；
# ARGS="-e $(IMAGE).elf $(IMAGE).bin"：传递给 NPC 模拟器的参数，-e 指定 ELF 文件，$(IMAGE).bin 指定 bin 文件；
# IMG=$(IMAGE).bin：指定 bin 文件，用于后续的仿真；