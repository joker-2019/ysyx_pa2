AM_SRCS := platform/nemu/trm.c \
           platform/nemu/ioe/ioe.c \
           platform/nemu/ioe/timer.c \
           platform/nemu/ioe/input.c \
           platform/nemu/ioe/gpu.c \
           platform/nemu/ioe/audio.c \
           platform/nemu/ioe/disk.c \
           platform/nemu/mpe.c

CFLAGS    += -fdata-sections -ffunction-sections
LDFLAGS   += -T $(AM_HOME)/scripts/linker.ld \
             --defsym=_pmem_start=0x80000000 --defsym=_entry_offset=0x0
LDFLAGS   += --gc-sections -e _start
NEMUFLAGS += -l $(shell dirname $(IMAGE).elf)/nemu-log.txt
# 解析make命令行选项
ifdef b
  BATCH_MODE := 1
else ifdef batch
  BATCH_MODE := 1
else
  BATCH_MODE := 0
endif

ifdef e
  ELF_FILE := $(e)
else ifdef elf_file
  ELF_FILE := $(elf_file)
else
  ELF_FILE := $(IMAGE).elf  # 默认使用生成的ELF文件
endif

# 默认配置
BATCH_MODE ?= 0  # 默认禁用批处理模式
ELF_FILE ?= $(IMAGE).elf  # 默认ELF文件路径

NEMUFLAGS += $(if $(BATCH_MODE),--batch,)
NEMUFLAGS += $(if $(ELF_FILE),-e $(ELF_FILE),)

CFLAGS += -DMAINARGS=\"$(mainargs)\"
CFLAGS += -I$(AM_HOME)/am/src/platform/nemu/include
.PHONY: $(AM_HOME)/am/src/platform/nemu/trm.c

image: $(IMAGE).elf
	@$(OBJDUMP) -d $(IMAGE).elf > $(IMAGE).txt
	@echo + OBJCOPY "->" $(IMAGE_REL).bin
	@$(OBJCOPY) -S --set-section-flags .bss=alloc,contents -O binary $(IMAGE).elf $(IMAGE).bin

run: image
	$(MAKE) -C $(NEMU_HOME) ISA=$(ISA) run ARGS="$(NEMUFLAGS)" IMG=$(IMAGE).bin

gdb: image
	$(MAKE) -C $(NEMU_HOME) ISA=$(ISA) gdb ARGS="$(NEMUFLAGS)" IMG=$(IMAGE).bin
