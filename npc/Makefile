# Makefile

# Top module name
# TOPNAME = top
# TOPNAME = mux41
# TOPNAME = decode38
# TOPNAME = ALU
# TOPNAME = LFSR_8bit
TOPNAME = keyboard_display

# NXDC constraint file
# NXDC_FILES = constr/top.nxdc
# NXDC_FILES = constr/mux41.nxdc
# NXDC_FILES = constr/decode38.nxdc
# NXDC_FILES = constr/ALU.nxdc
# NXDC_FILES = constr/LFSR_8bit.nxdc
NXDC_FILES = constr/keyboard_display.nxdc
FST_FILE = dump.vcd

# Include path for headers
INC_PATH ?=

# Verilator settings
VERILATOR = verilator
VERILATOR_CFLAGS += -MMD --build -cc \
                    -O3 --x-assign fast --x-initial fast --noassert --trace -trace

# Build directories
BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)

# Default target
default: $(BIN)

# Create build directory if it does not exist
$(shell mkdir -p $(BUILD_DIR))

# Auto bind pins using NVBoard script
SRC_AUTO_BIND = $(abspath $(BUILD_DIR)/auto_bind.cpp)
$(SRC_AUTO_BIND): $(NXDC_FILES)
	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

# Find Verilog and C++ source files
VSRCS = $(shell find $(abspath ./vsrc) -name "*.v")
# CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
# VSRCS = $(shell find $(abspath ./vsrc) -name "mux41.v")
# VSRCS = $(shell find $(abspath ./vsrc) -name "decode38.v")
#VSRCS = $(shell find $(abspath ./vsrc) -name "ALU.v" -o -name "bcd7seg.v" -o -name "ALU_control.v" -o -name "ALU_logic.v")
# CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
# CSRCS = $(shell find $(abspath ./csrc) -name "mux41.cpp")
# CSRCS = $(shell find $(abspath ./csrc) -name "decode38.cpp")
# CSRCS = $(shell find $(abspath ./csrc) -name "ALU.cpp")
# CSRCS = $(shell find $(abspath ./csrc) -name "LFSR_8bit.cpp")
CSRCS = $(shell find $(abspath ./csrc) -name "keyboard_display.cpp")
CSRCS += $(SRC_AUTO_BIND)

# Include NVBoard rules
include $(NVBOARD_HOME)/scripts/nvboard.mk

# Verilator include flags
INCFLAGS = $(addprefix -I, $(INC_PATH))
CXXFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOPNAME)\""

# Build the binary
$(BIN): $(VSRCS) $(CSRCS) $(NVBOARD_ARCHIVE)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CXXFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

# Default and run targets
all: default
run: $(BIN)
	@$^

view:$(FST_FILE)
	gtkwave $(FST_FILE)

# Clean build directory
clean:
	rm -rf $(BUILD_DIR)
        
.PHONY: default all clean run

