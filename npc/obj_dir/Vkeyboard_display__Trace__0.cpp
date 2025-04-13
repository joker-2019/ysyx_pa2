// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vkeyboard_display__Syms.h"


void Vkeyboard_display___024root__trace_chg_0_sub_0(Vkeyboard_display___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vkeyboard_display___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root__trace_chg_0\n"); );
    // Init
    Vkeyboard_display___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vkeyboard_display___024root*>(voidSelf);
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vkeyboard_display___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vkeyboard_display___024root__trace_chg_0_sub_0(Vkeyboard_display___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root__trace_chg_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgBit(oldp+0,(vlSelf->keyboard_display__DOT__key_down));
        bufp->chgBit(oldp+1,(vlSelf->keyboard_display__DOT__keyup_flag));
        bufp->chgSData(oldp+2,(vlSelf->keyboard_display__DOT__buffer),10);
        bufp->chgCData(oldp+3,(vlSelf->keyboard_display__DOT__count),4);
        bufp->chgCData(oldp+4,(vlSelf->keyboard_display__DOT__ps2_clk_sync),3);
        bufp->chgBit(oldp+5,((IData)((4U == (6U & (IData)(vlSelf->keyboard_display__DOT__ps2_clk_sync))))));
        bufp->chgCData(oldp+6,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_ascii__seg),8);
        bufp->chgCData(oldp+7,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_ascii_1__seg),8);
        bufp->chgCData(oldp+8,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_count__seg),8);
        bufp->chgCData(oldp+9,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_count_1__seg),8);
        bufp->chgCData(oldp+10,((0xfU & ((IData)(vlSelf->keyboard_display__DOT__buffer) 
                                         >> 1U))),4);
        bufp->chgCData(oldp+11,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_key__seg),8);
        bufp->chgCData(oldp+12,((0xfU & ((IData)(vlSelf->keyboard_display__DOT__buffer) 
                                         >> 5U))),4);
        bufp->chgCData(oldp+13,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_key_1__seg),8);
    }
    bufp->chgBit(oldp+14,(vlSelf->reset));
    bufp->chgBit(oldp+15,(vlSelf->clk));
    bufp->chgBit(oldp+16,(vlSelf->ps2_clk));
    bufp->chgBit(oldp+17,(vlSelf->ps2_data));
    bufp->chgCData(oldp+18,(vlSelf->keycode),8);
    bufp->chgCData(oldp+19,(vlSelf->ascii_code),8);
    bufp->chgCData(oldp+20,(vlSelf->key_count),8);
    bufp->chgSData(oldp+21,(vlSelf->seg_key),16);
    bufp->chgSData(oldp+22,(vlSelf->seg_ascii),16);
    bufp->chgSData(oldp+23,(vlSelf->seg_count),16);
    bufp->chgCData(oldp+24,((0xfU & (IData)(vlSelf->ascii_code))),4);
    bufp->chgCData(oldp+25,((0xfU & ((IData)(vlSelf->ascii_code) 
                                     >> 4U))),4);
    bufp->chgCData(oldp+26,((0xfU & (IData)(vlSelf->key_count))),4);
    bufp->chgCData(oldp+27,((0xfU & ((IData)(vlSelf->key_count) 
                                     >> 4U))),4);
}

void Vkeyboard_display___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root__trace_cleanup\n"); );
    // Init
    Vkeyboard_display___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vkeyboard_display___024root*>(voidSelf);
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
