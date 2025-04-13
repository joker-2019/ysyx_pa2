// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vkeyboard_display.h for the primary calling header

#include "Vkeyboard_display__pch.h"
#include "Vkeyboard_display__Syms.h"
#include "Vkeyboard_display___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vkeyboard_display___024root___dump_triggers__act(Vkeyboard_display___024root* vlSelf);
#endif  // VL_DEBUG

void Vkeyboard_display___024root___eval_triggers__act(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->clk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__clk__0))));
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vkeyboard_display___024root___dump_triggers__act(vlSelf);
    }
#endif
}
