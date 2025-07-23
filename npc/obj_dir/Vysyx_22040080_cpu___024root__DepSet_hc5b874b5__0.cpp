// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vysyx_22040080_cpu.h for the primary calling header

#include "Vysyx_22040080_cpu__pch.h"
#include "Vysyx_22040080_cpu__Syms.h"
#include "Vysyx_22040080_cpu___024root.h"

extern "C" void ebreak_trigger();

VL_INLINE_OPT void Vysyx_22040080_cpu___024root____Vdpiimwrap_ysyx_22040080_cpu__DOT__ebreak_trigger_TOP() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root____Vdpiimwrap_ysyx_22040080_cpu__DOT__ebreak_trigger_TOP\n"); );
    // Body
    ebreak_trigger();
}

extern "C" int imem_read(int pc);

VL_INLINE_OPT void Vysyx_22040080_cpu___024root____Vdpiimwrap_ysyx_22040080_cpu__DOT__ifu__DOT__imem_read_TOP(IData/*31:0*/ pc, IData/*31:0*/ &imem_read__Vfuncrtn) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root____Vdpiimwrap_ysyx_22040080_cpu__DOT__ifu__DOT__imem_read_TOP\n"); );
    // Body
    int pc__Vcvt;
    for (size_t pc__Vidx = 0; pc__Vidx < 1; ++pc__Vidx) pc__Vcvt = pc;
    int imem_read__Vfuncrtn__Vcvt;
    imem_read__Vfuncrtn__Vcvt = imem_read(pc__Vcvt);
    imem_read__Vfuncrtn = imem_read__Vfuncrtn__Vcvt;
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vysyx_22040080_cpu___024root___dump_triggers__act(Vysyx_22040080_cpu___024root* vlSelf);
#endif  // VL_DEBUG

void Vysyx_22040080_cpu___024root___eval_triggers__act(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->clk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__clk__0))));
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vysyx_22040080_cpu___024root___dump_triggers__act(vlSelf);
    }
#endif
}
