AM_SRCS := riscv/npc/start.S \
           riscv/npc/trm.c \
           riscv/npc/ioe.c \
           riscv/npc/timer.c \
           riscv/npc/input.c \
           riscv/npc/cte.c \
           riscv/npc/trap.S \
           platform/dummy/vme.c \
           platform/dummy/mpe.c

CFLAGS	+= -fdata-sections -ffunction-sections 
LDFLAGS	+= -T $(AM_HOME)/scripts/linker.ld \
	   					--defsym=_pmem_start=0x80000000 \
	--defsym=_entry_offset=0x0 
LDFLAGS	+= --gc-sections -e _start


# 默认加载的 elf 镜像路径
NPCFLAGS += -e $(IMAGE).elf $(IMAGE).bin

CFLAGS	+= -DMAINARGS=\"$(mainargs)\"
.PHONY: $(AM_HOME)/am/src/riscv/npc/trm.c 

image: $(IMAGE).elf
	@$(OBJDUMP) -d $(IMAGE).elf > $(IMAGE).txt 
	@echo + OBJCOPY "->" $(IMAGE_REL).bin
	@$(OBJCOPY) -S --set-section-flags .bss=alloc,contents -O binary $(IMAGE).elf $(IMAGE).bin

.PHONY: run
run: image
	@echo + RUNNING $(IMAGE).bin ON NPC
	$(MAKE) -C $(NPC_HOME) ISA=$(ISA) run ARGS="$(NPCFLAGS)" IMG=$(IMAGE).bin
# @echo + RUNNING $(IMAGE).bin ON NPC
# @echo $(AM_HOME)/../npc
# @cd $(AM_HOME)/../npc && make run image=$(AM_HOME)/$(IMAGE).bin
