CROSS_COMPILE = riscv64-linux-gnu-
CC      = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy

CFLAGS  = -march=rv32i -mabi=ilp32 -nostdlib -nostartfiles -O2
LDFLAGS = -Ttext=0x20000000

TARGET  = char-test

all: $(TARGET).bin

$(TARGET).elf: $(TARGET).c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary -j .text $< $@

clean:
	rm -f $(TARGET).elf $(TARGET).bin

.PHONY: all clean
