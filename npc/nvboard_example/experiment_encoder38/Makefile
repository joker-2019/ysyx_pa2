# Makefile

# Top module name
TOPNAME = decode38

# NXDC constraint file
NXDC_FILES = constr/decode38.nxdc
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
CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
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

# 仿真目标
sim: $(BIN)
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "[SIM] 启动仿真..."
	@$(BIN)

run: $(BIN)
	@$^

view:$(FST_FILE)
	gtkwave $(FST_FILE)

# Clean build directory
clean:
	rm -rf $(BUILD_DIR)
        
.PHONY: default all clean run view sim

