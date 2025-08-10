// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Prototypes for DPI import and export functions.
//
// Verilator includes this file in all generated .cpp files that use DPI functions.
// Manually include this file where DPI .c import functions are declared to ensure
// the C functions match the expectations of the DPI imports.

#ifndef VERILATED_VYSYX_22040080_CPU__DPI_H_
#define VERILATED_VYSYX_22040080_CPU__DPI_H_  // guard

#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif


    // DPI IMPORTS
    // DPI import at /home/wp/ysyx-workbench/npc/vsrc/ysyx_22040080_cpu.v:22:30
    extern void ebreak_trigger();
    // DPI import at /home/wp/ysyx-workbench/npc/vsrc/ysyx_22040080_ifu.v:9:29
    extern int imem_read(int pc);

#ifdef __cplusplus
}
#endif

#endif  // guard
