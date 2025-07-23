# Verilated -*- Makefile -*-
# DESCRIPTION: Verilator output: Makefile for building Verilated archive or executable
#
# Execute this makefile from the object directory:
#    make -f Vysyx_22040080_cpu.mk

default: libVysyx_22040080_cpu

### Constants...
# Perl executable (from $PERL)
PERL = perl
# Path to Verilator kit (from $VERILATOR_ROOT)
VERILATOR_ROOT = /usr/local/share/verilator
# SystemC include directory with systemc.h (from $SYSTEMC_INCLUDE)
SYSTEMC_INCLUDE ?= 
# SystemC library directory with libsystemc.a (from $SYSTEMC_LIBDIR)
SYSTEMC_LIBDIR ?= 

### Switches...
# C++ code coverage  0/1 (from --prof-c)
VM_PROFC = 0
# SystemC output mode?  0/1 (from --sc)
VM_SC = 0
# Legacy or SystemC output mode?  0/1 (from --sc)
VM_SP_OR_SC = $(VM_SC)
# Deprecated
VM_PCLI = 1
# Deprecated: SystemC architecture to find link library path (from $SYSTEMC_ARCH)
VM_SC_TARGET_ARCH = linux

### Vars...
# Design prefix (from --prefix)
VM_PREFIX = Vysyx_22040080_cpu
# Module prefix (from --prefix)
VM_MODPREFIX = Vysyx_22040080_cpu
# User CFLAGS (from -CFLAGS on Verilator command line)
VM_USER_CFLAGS = \

# User LDLIBS (from -LDFLAGS on Verilator command line)
VM_USER_LDLIBS = \

# User .cpp files (from .cpp's on Verilator command line)
VM_USER_CLASSES = \
	memory \
	main \
	expr \
	watchpoint \
	disasm \
	iringbuf \
	trace \

# User .cpp directories (from .cpp's on Verilator command line)
VM_USER_DIR = \
	/home/wp/ysyx-workbench/npc/csrc \
	/home/wp/ysyx-workbench/npc/csrc/Memory \
	/home/wp/ysyx-workbench/npc/csrc/monitor \
	/home/wp/ysyx-workbench/npc/csrc/utils \


### Default rules...
# Include list of all generated classes
include Vysyx_22040080_cpu_classes.mk
# Include global rules
include $(VERILATOR_ROOT)/include/verilated.mk
memory.o: /home/wp/ysyx-workbench/npc/csrc/Memory/memory.cpp
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
main.o: /home/wp/ysyx-workbench/npc/csrc/main.cpp
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
expr.o: /home/wp/ysyx-workbench/npc/csrc/monitor/expr.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
watchpoint.o: /home/wp/ysyx-workbench/npc/csrc/monitor/watchpoint.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
disasm.o: /home/wp/ysyx-workbench/npc/csrc/utils/disasm.cc
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
iringbuf.o: /home/wp/ysyx-workbench/npc/csrc/utils/iringbuf.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
trace.o: /home/wp/ysyx-workbench/npc/csrc/utils/trace.c
	$(OBJCACHE) $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<

### Library rules (default lib mode)
libVysyx_22040080_cpu.a: $(VK_OBJS) $(VK_USER_OBJS) $(VM_HIER_LIBS)
libverilated.a: $(VK_GLOBAL_OBJS)
libVysyx_22040080_cpu: libVysyx_22040080_cpu.a libverilated.a $(VM_PREFIX)__ALL.a

# Verilated -*- Makefile -*-
