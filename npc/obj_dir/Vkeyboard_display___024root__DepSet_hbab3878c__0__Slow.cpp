// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vkeyboard_display.h for the primary calling header

#include "Vkeyboard_display__pch.h"
#include "Vkeyboard_display___024root.h"

VL_ATTR_COLD void Vkeyboard_display___024root___eval_static(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vkeyboard_display___024root___eval_initial(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
}

VL_ATTR_COLD void Vkeyboard_display___024root___eval_final(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_final\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vkeyboard_display___024root___dump_triggers__stl(Vkeyboard_display___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vkeyboard_display___024root___eval_phase__stl(Vkeyboard_display___024root* vlSelf);

VL_ATTR_COLD void Vkeyboard_display___024root___eval_settle(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_settle\n"); );
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelf->__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY((0x64U < __VstlIterCount))) {
#ifdef VL_DEBUG
            Vkeyboard_display___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("/home/wp/ysyx-workbench/npc/vsrc/keyboard_display.v", 1, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vkeyboard_display___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelf->__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vkeyboard_display___024root___dump_triggers__stl(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ vlSelf->__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vkeyboard_display___024root___stl_sequent__TOP__0(Vkeyboard_display___024root* vlSelf);

VL_ATTR_COLD void Vkeyboard_display___024root___eval_stl(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vkeyboard_display___024root___stl_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[1U] = 1U;
        vlSelf->__Vm_traceActivity[0U] = 1U;
    }
}

extern const VlUnpacked<CData/*7:0*/, 16> Vkeyboard_display__ConstPool__TABLE_h8f5fe856_0;
extern const VlUnpacked<CData/*7:0*/, 256> Vkeyboard_display__ConstPool__TABLE_h06ac1970_0;

VL_ATTR_COLD void Vkeyboard_display___024root___stl_sequent__TOP__0(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___stl_sequent__TOP__0\n"); );
    // Init
    CData/*7:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    CData/*3:0*/ __Vtableidx2;
    __Vtableidx2 = 0;
    CData/*3:0*/ __Vtableidx3;
    __Vtableidx3 = 0;
    CData/*3:0*/ __Vtableidx4;
    __Vtableidx4 = 0;
    CData/*3:0*/ __Vtableidx5;
    __Vtableidx5 = 0;
    CData/*3:0*/ __Vtableidx6;
    __Vtableidx6 = 0;
    CData/*3:0*/ __Vtableidx7;
    __Vtableidx7 = 0;
    // Body
    __Vtableidx2 = (0xfU & ((IData)(vlSelf->keyboard_display__DOT__buffer) 
                            >> 1U));
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_key__seg 
        = Vkeyboard_display__ConstPool__TABLE_h8f5fe856_0
        [__Vtableidx2];
    __Vtableidx3 = (0xfU & ((IData)(vlSelf->keyboard_display__DOT__buffer) 
                            >> 5U));
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_key_1__seg 
        = Vkeyboard_display__ConstPool__TABLE_h8f5fe856_0
        [__Vtableidx3];
    __Vtableidx6 = (0xfU & (IData)(vlSelf->key_count));
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_count__seg 
        = Vkeyboard_display__ConstPool__TABLE_h8f5fe856_0
        [__Vtableidx6];
    __Vtableidx7 = (0xfU & ((IData)(vlSelf->key_count) 
                            >> 4U));
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_count_1__seg 
        = Vkeyboard_display__ConstPool__TABLE_h8f5fe856_0
        [__Vtableidx7];
    vlSelf->keycode = (0xffU & ((IData)(vlSelf->keyboard_display__DOT__buffer) 
                                >> 1U));
    vlSelf->seg_key = (((IData)(vlSelf->keyboard_display__DOT____Vcellout__u_seg_key_1__seg) 
                        << 8U) | (IData)(vlSelf->keyboard_display__DOT____Vcellout__u_seg_key__seg));
    vlSelf->seg_count = (((IData)(vlSelf->keyboard_display__DOT____Vcellout__u_seg_count_1__seg) 
                          << 8U) | (IData)(vlSelf->keyboard_display__DOT____Vcellout__u_seg_count__seg));
    __Vtableidx1 = vlSelf->keycode;
    vlSelf->ascii_code = Vkeyboard_display__ConstPool__TABLE_h06ac1970_0
        [__Vtableidx1];
    __Vtableidx4 = (0xfU & (IData)(vlSelf->ascii_code));
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_ascii__seg 
        = Vkeyboard_display__ConstPool__TABLE_h8f5fe856_0
        [__Vtableidx4];
    __Vtableidx5 = (0xfU & ((IData)(vlSelf->ascii_code) 
                            >> 4U));
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_ascii_1__seg 
        = Vkeyboard_display__ConstPool__TABLE_h8f5fe856_0
        [__Vtableidx5];
    vlSelf->seg_ascii = (((IData)(vlSelf->keyboard_display__DOT____Vcellout__u_seg_ascii_1__seg) 
                          << 8U) | (IData)(vlSelf->keyboard_display__DOT____Vcellout__u_seg_ascii__seg));
}

VL_ATTR_COLD void Vkeyboard_display___024root___eval_triggers__stl(Vkeyboard_display___024root* vlSelf);

VL_ATTR_COLD bool Vkeyboard_display___024root___eval_phase__stl(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_phase__stl\n"); );
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vkeyboard_display___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelf->__VstlTriggered.any();
    if (__VstlExecute) {
        Vkeyboard_display___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vkeyboard_display___024root___dump_triggers__act(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ vlSelf->__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vkeyboard_display___024root___dump_triggers__nba(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ vlSelf->__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vkeyboard_display___024root___ctor_var_reset(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->reset = VL_RAND_RESET_I(1);
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->ps2_clk = VL_RAND_RESET_I(1);
    vlSelf->ps2_data = VL_RAND_RESET_I(1);
    vlSelf->keycode = VL_RAND_RESET_I(8);
    vlSelf->ascii_code = VL_RAND_RESET_I(8);
    vlSelf->key_count = VL_RAND_RESET_I(8);
    vlSelf->seg_key = VL_RAND_RESET_I(16);
    vlSelf->seg_ascii = VL_RAND_RESET_I(16);
    vlSelf->seg_count = VL_RAND_RESET_I(16);
    vlSelf->keyboard_display__DOT__key_down = VL_RAND_RESET_I(1);
    vlSelf->keyboard_display__DOT__keyup_flag = VL_RAND_RESET_I(1);
    vlSelf->keyboard_display__DOT__buffer = VL_RAND_RESET_I(10);
    vlSelf->keyboard_display__DOT__count = VL_RAND_RESET_I(4);
    vlSelf->keyboard_display__DOT__ps2_clk_sync = VL_RAND_RESET_I(3);
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_key__seg = VL_RAND_RESET_I(8);
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_key_1__seg = VL_RAND_RESET_I(8);
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_ascii__seg = VL_RAND_RESET_I(8);
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_ascii_1__seg = VL_RAND_RESET_I(8);
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_count__seg = VL_RAND_RESET_I(8);
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_count_1__seg = VL_RAND_RESET_I(8);
    vlSelf->keyboard_display__DOT____Vlvbound_h2a4d04d8__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
