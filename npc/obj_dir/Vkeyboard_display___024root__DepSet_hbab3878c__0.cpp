// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vkeyboard_display.h for the primary calling header

#include "Vkeyboard_display__pch.h"
#include "Vkeyboard_display___024root.h"

void Vkeyboard_display___024root___eval_act(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_act\n"); );
}

void Vkeyboard_display___024root___nba_sequent__TOP__0(Vkeyboard_display___024root* vlSelf);

void Vkeyboard_display___024root___eval_nba(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vkeyboard_display___024root___nba_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[1U] = 1U;
    }
}

extern const VlUnpacked<CData/*7:0*/, 16> Vkeyboard_display__ConstPool__TABLE_h8f5fe856_0;
extern const VlUnpacked<CData/*7:0*/, 256> Vkeyboard_display__ConstPool__TABLE_h06ac1970_0;

VL_INLINE_OPT void Vkeyboard_display___024root___nba_sequent__TOP__0(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___nba_sequent__TOP__0\n"); );
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
    CData/*2:0*/ __Vdly__keyboard_display__DOT__ps2_clk_sync;
    __Vdly__keyboard_display__DOT__ps2_clk_sync = 0;
    CData/*3:0*/ __Vdly__keyboard_display__DOT__count;
    __Vdly__keyboard_display__DOT__count = 0;
    CData/*0:0*/ __Vdly__keyboard_display__DOT__key_down;
    __Vdly__keyboard_display__DOT__key_down = 0;
    CData/*0:0*/ __Vdly__keyboard_display__DOT__keyup_flag;
    __Vdly__keyboard_display__DOT__keyup_flag = 0;
    // Body
    __Vdly__keyboard_display__DOT__ps2_clk_sync = vlSelf->keyboard_display__DOT__ps2_clk_sync;
    __Vdly__keyboard_display__DOT__keyup_flag = vlSelf->keyboard_display__DOT__keyup_flag;
    __Vdly__keyboard_display__DOT__key_down = vlSelf->keyboard_display__DOT__key_down;
    __Vdly__keyboard_display__DOT__count = vlSelf->keyboard_display__DOT__count;
    __Vdly__keyboard_display__DOT__ps2_clk_sync = (
                                                   (6U 
                                                    & ((IData)(vlSelf->keyboard_display__DOT__ps2_clk_sync) 
                                                       << 1U)) 
                                                   | (IData)(vlSelf->ps2_clk));
    if (vlSelf->reset) {
        __Vdly__keyboard_display__DOT__count = 0U;
        __Vdly__keyboard_display__DOT__key_down = 0U;
        __Vdly__keyboard_display__DOT__keyup_flag = 0U;
    } else if ((IData)((4U == (6U & (IData)(vlSelf->keyboard_display__DOT__ps2_clk_sync))))) {
        if ((0xaU == (IData)(vlSelf->keyboard_display__DOT__count))) {
            if (VL_UNLIKELY((((~ (IData)(vlSelf->keyboard_display__DOT__buffer)) 
                              & (IData)(vlSelf->ps2_data)) 
                             & VL_REDXOR_32((0x1ffU 
                                             & ((IData)(vlSelf->keyboard_display__DOT__buffer) 
                                                >> 1U)))))) {
                VL_WRITEF_NX("receive %x\n",0,8,(0xffU 
                                                 & ((IData)(vlSelf->keyboard_display__DOT__buffer) 
                                                    >> 1U)));
                if ((0xf0U == (IData)(vlSelf->keycode))) {
                    __Vdly__keyboard_display__DOT__key_down = 0U;
                    __Vdly__keyboard_display__DOT__keyup_flag = 1U;
                } else if (vlSelf->keyboard_display__DOT__keyup_flag) {
                    vlSelf->keyboard_display__DOT__buffer 
                        = (0x201U & (IData)(vlSelf->keyboard_display__DOT__buffer));
                    __Vdly__keyboard_display__DOT__keyup_flag = 0U;
                } else if ((1U & (~ (IData)(vlSelf->keyboard_display__DOT__key_down)))) {
                    vlSelf->key_count = (0xffU & ((IData)(1U) 
                                                  + (IData)(vlSelf->key_count)));
                    __Vdly__keyboard_display__DOT__key_down = 1U;
                }
            }
            __Vdly__keyboard_display__DOT__count = 0U;
        } else {
            vlSelf->keyboard_display__DOT____Vlvbound_h2a4d04d8__0 
                = vlSelf->ps2_data;
            if ((9U >= (IData)(vlSelf->keyboard_display__DOT__count))) {
                vlSelf->keyboard_display__DOT__buffer 
                    = (((~ ((IData)(1U) << (IData)(vlSelf->keyboard_display__DOT__count))) 
                        & (IData)(vlSelf->keyboard_display__DOT__buffer)) 
                       | (0x3ffU & ((IData)(vlSelf->keyboard_display__DOT____Vlvbound_h2a4d04d8__0) 
                                    << (IData)(vlSelf->keyboard_display__DOT__count))));
            }
            __Vdly__keyboard_display__DOT__count = 
                (0xfU & ((IData)(1U) + (IData)(vlSelf->keyboard_display__DOT__count)));
        }
    }
    vlSelf->keyboard_display__DOT__count = __Vdly__keyboard_display__DOT__count;
    vlSelf->keyboard_display__DOT__key_down = __Vdly__keyboard_display__DOT__key_down;
    vlSelf->keyboard_display__DOT__keyup_flag = __Vdly__keyboard_display__DOT__keyup_flag;
    vlSelf->keyboard_display__DOT__ps2_clk_sync = __Vdly__keyboard_display__DOT__ps2_clk_sync;
    __Vtableidx6 = (0xfU & (IData)(vlSelf->key_count));
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_count__seg 
        = Vkeyboard_display__ConstPool__TABLE_h8f5fe856_0
        [__Vtableidx6];
    __Vtableidx7 = (0xfU & ((IData)(vlSelf->key_count) 
                            >> 4U));
    vlSelf->keyboard_display__DOT____Vcellout__u_seg_count_1__seg 
        = Vkeyboard_display__ConstPool__TABLE_h8f5fe856_0
        [__Vtableidx7];
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
    vlSelf->keycode = (0xffU & ((IData)(vlSelf->keyboard_display__DOT__buffer) 
                                >> 1U));
    vlSelf->seg_count = (((IData)(vlSelf->keyboard_display__DOT____Vcellout__u_seg_count_1__seg) 
                          << 8U) | (IData)(vlSelf->keyboard_display__DOT____Vcellout__u_seg_count__seg));
    vlSelf->seg_key = (((IData)(vlSelf->keyboard_display__DOT____Vcellout__u_seg_key_1__seg) 
                        << 8U) | (IData)(vlSelf->keyboard_display__DOT____Vcellout__u_seg_key__seg));
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

void Vkeyboard_display___024root___eval_triggers__act(Vkeyboard_display___024root* vlSelf);

bool Vkeyboard_display___024root___eval_phase__act(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vkeyboard_display___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vkeyboard_display___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vkeyboard_display___024root___eval_phase__nba(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vkeyboard_display___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vkeyboard_display___024root___dump_triggers__nba(Vkeyboard_display___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vkeyboard_display___024root___dump_triggers__act(Vkeyboard_display___024root* vlSelf);
#endif  // VL_DEBUG

void Vkeyboard_display___024root___eval(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vkeyboard_display___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("/home/wp/ysyx-workbench/npc/vsrc/keyboard_display.v", 1, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vkeyboard_display___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("/home/wp/ysyx-workbench/npc/vsrc/keyboard_display.v", 1, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vkeyboard_display___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vkeyboard_display___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vkeyboard_display___024root___eval_debug_assertions(Vkeyboard_display___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->reset & 0xfeU))) {
        Verilated::overWidthError("reset");}
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->ps2_clk & 0xfeU))) {
        Verilated::overWidthError("ps2_clk");}
    if (VL_UNLIKELY((vlSelf->ps2_data & 0xfeU))) {
        Verilated::overWidthError("ps2_data");}
}
#endif  // VL_DEBUG
