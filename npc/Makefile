# Makefile

# Top module name
# TOPNAME = ysyx_22040080_cpu
TOPNAME = ysyxSoCFull

# NXDC constraint file
# NXDC_FILES = constr/top.nxdc
FST_FILE = dump.vcd

# LLVM config
LLVM_CONFIG ?= llvm-config

# Detect config flags
CONFIG_ITRACE ?= y
CONFIG_FTRACE ?= y

# Include path for headers
INC_PATH ?=

# Verilator settings # 新增时序相关选项 timescale为Verilator 仿真设置时间尺度，定义仿真的基本时间单位为 1 纳秒，时间精度也为 1 纳秒
# -MMD 生成依赖文件(.d) --build 构建Verilator 对象文件 --cc 使用C++编译器编译Verilator 对象文件 -O3 优化级别为3 --x-assign fast --x-initial fast 快速赋值和初始化 --noassert 禁用断言 --trace 生成VCD文件 --timescale "1ns/1ns" 时间尺度为1ns/1ns --no-timing 禁用时序分析
VERILATOR = verilator
VERILATOR_CFLAGS += -MMD --build -cc \
					-autoflush	\
                    -O3 --x-assign fast --x-initial fast --noassert --trace -trace \
					--timescale "1ns/1ns" --no-timing


# Build directories
BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)


# Default target
default: $(BIN)

# Create build directory if it does not exist
$(shell mkdir -p $(BUILD_DIR))

# Auto bind pins using NVBoard script
#SRC_AUTO_BIND = $(abspath $(BUILD_DIR)/auto_bind.cpp)
# $(SRC_AUTO_BIND): $(NXDC_FILES)
# 	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

# Find Verilog and C++ source files
VSRCS = $(shell find $(abspath ./vsrc/generated) -name "*.v")
CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
# CSRCS += $(SRC_AUTO_BIND)

CUR_DIR := $(shell pwd)
# ysyxSoC 路径（相对 npc 目录，可根据实际布局调整）
YSYXSOC_DIR = $(abspath $(CUR_DIR)/../ysyxSoC)
# ysyxSoC/perip 及其子目录下的所有 .v 文件
PERIP_VSRCS = $(shell find $(YSYXSOC_DIR)/perip -name "*.v" 2>/dev/null)
VSRCS += $(PERIP_VSRCS)

# ========== 关键修改：添加ysyxSoCFull.v到Verilog文件列表 ==========
# 加入ysyxSoC/build/ysyxSoCFull.v文件
YSYXSOC_FULL_V = $(YSYXSOC_DIR)/build/ysyxSoCFull.v
VSRCS += $(YSYXSOC_FULL_V)

# Verilator include 搜索路径（用于 `include 指令，解决 uart_defines.v、spi_defines.v 等）
VERILATOR_INC = -I$(YSYXSOC_DIR)/perip/uart16550/rtl \
                -I$(YSYXSOC_DIR)/perip/spi/rtl


# LLVM disassembler support
ifeq ($(CONFIG_ITRACE), y)
  CSRCS += $(abspath ./csrc/utils/disasm.cc)
  CXXFLAGS += $(shell $(LLVM_CONFIG) --cxxflags) -fPIE
  LDFLAGS  += $(shell $(LLVM_CONFIG) --libs)
		
endif

# CFLAGS += -I./include -g
#  rv64imac 对应 64 位架构，带乘法、原子操作等；lp64 是 64 位 ABI
CFLAGS += -I./include -g
LDFLAGS		+=	-lreadline	-lncurses -ldl

ifeq ($(CONFIG_FTRACE), y)
  CSRCS += $(abspath ./csrc/utils/trace.c)
endif

# Include NVBoard rules
# include $(NVBOARD_HOME)/scripts/nvboard.mk

# Verilator include flags
INCFLAGS = $(addprefix -I, $(INC_PATH))
CXXFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOPNAME)\""

# Build the binary
# $(BIN): $(VSRCS) $(CSRCS) $(NVBOARD_ARCHIVE)
#	@rm -rf $(OBJ_DIR)  # 清空旧的编译目录（避免残留文件干扰）
#	$(VERILATOR) $(VERILATOR_CFLAGS) \
#		--top-module $(TOPNAME) $^ \ 用$^（自动引用所有依赖项）
#		$(addprefix -CFLAGS , $(CXXFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
#		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

# 在 verilator 调用处添加 $(VERILATOR_INC) （用于 `include 指令，解决 uart_defines.v、spi_defines.v 等）\  # 新增外设include路径
$(BIN): $(VSRCS) $(CSRCS)
	@rm -rf $(OBJ_DIR)  
	$(VERILATOR) $(VERILATOR_CFLAGS) $(VERILATOR_INC) \
		--top-module $(TOPNAME) $(VSRCS) $(CSRCS) \
		$(addprefix -CFLAGS , $(CXXFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

# Default and run targets
all: default

# 仿真目标
sim: $(BIN)
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "[SIM] 启动仿真..."
	@$(BIN)

run:$(BIN)
	@$^ $(ARGS) -- +trace

view:$(FST_FILE)
	gtkwave $(FST_FILE)

# Clean build directory
clean:
	rm -rf $(BUILD_DIR)

# 时序分析（STA）相关变量
DESIGN ?= $(TOPNAME)
SDC_FILE ?= constr/top.sdc
CLK_FREQ_MHZ ?= 100 # 时钟频率100MHZ
CLK_PORT_NAME ?= clk # 时钟端口名称
O ?= ./sta_output
RTL_FILES ?= $(VSRCS)

# 关键修改：在read_verilog后添加-sv，支持SystemVerilog的DPI-C语法
sta:
	@mkdir -p $(O)
	@echo "开始综合与时序分析..."
	yosys -p "read_verilog -sv $(RTL_FILES); hierarchy -top $(DESIGN); synth -top $(DESIGN); write_verilog $(O)/synth.v"
	sta $(SDC_FILE) -top $(DESIGN) -freq $(CLK_FREQ_MHZ) -port $(CLK_PORT_NAME) -o $(O)/sta_report.rpt
	@echo "时序分析结果已保存至 $(O)/sta_report.rpt"

.PHONY: default all clean run view sim

