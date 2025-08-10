// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vysyx_22040080_cpu.h for the primary calling header

#ifndef VERILATED_VYSYX_22040080_CPU___024ROOT_H_
#define VERILATED_VYSYX_22040080_CPU___024ROOT_H_  // guard

#include "verilated.h"


class Vysyx_22040080_cpu__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vysyx_22040080_cpu___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst,0,0);
    CData/*0:0*/ ysyx_22040080_cpu__DOT__wen;
    CData/*2:0*/ ysyx_22040080_cpu__DOT__instr_type;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __VactContinue;
    VL_OUT(trace_pc,31,0);
    VL_OUT(trace_instr,31,0);
    VL_OUT(dnpc,31,0);
    IData/*31:0*/ ysyx_22040080_cpu__DOT__pc;
    IData/*31:0*/ ysyx_22040080_cpu__DOT__alu_result;
    IData/*31:0*/ ysyx_22040080_cpu__DOT__instruction;
    IData/*31:0*/ ysyx_22040080_cpu__DOT__rs1_data;
    IData/*31:0*/ ysyx_22040080_cpu__DOT__jal_target;
    IData/*31:0*/ ysyx_22040080_cpu__DOT__idu__DOT__imm;
    IData/*31:0*/ ysyx_22040080_cpu__DOT__alu__DOT__alu_sum;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 32> ysyx_22040080_cpu__DOT__regfile__DOT__rf;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vysyx_22040080_cpu__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vysyx_22040080_cpu___024root(Vysyx_22040080_cpu__Syms* symsp, const char* v__name);
    ~Vysyx_22040080_cpu___024root();
    VL_UNCOPYABLE(Vysyx_22040080_cpu___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
