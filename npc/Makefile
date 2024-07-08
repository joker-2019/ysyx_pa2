# Verilog and C++ source files
VERILOG_SOURCES = top.v
CPP_SOURCES = sim_main.cpp

# Output directories and files
OBJ_DIR = obj_dir
EXE_FILE = $(OBJ_DIR)/Vtop
FST_FILE = waveform.fst

# Verilator options
VERILATOR_FLAGS = --cc --exe --trace --trace-fst

# Compiler options
CXXFLAGS = -Wall -Wextra

all:
	@echo "Write this Makefile by your self."
# Run Verilator to compile Verilog and C++ sources
$(EXE_FILE): $(VERILOG_SOURCES) $(CPP_SOURCES)
        verilator $(VERILATOR_FLAGS) $(VERILOG_SOURCES) $(CPP_SOURCES)
        make -C $(OBJ_DIR) -f Vtop.mk Vtop

# Run the simulation
run: $(EXE_FILE)
        $(EXE_FILE)

# Clean up generated files
clean:
	 rm -rf $(OBJ_DIR) $(FST_FILE)

# View the waveform using GTKWave
view: $(FST_FILE)
        gtkwave $(FST_FILE)


sim:
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "Write this Makefile by your self."
	
.PHONY: all run clean view


include ../Makefile
