// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vkeyboard_display__Syms.h"


VL_ATTR_COLD void Vkeyboard_display___024root__trace_init_sub__TOP__0(Vkeyboard_display___024root* vlSelf, VerilatedVcd* tracep) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+15,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+16,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+17,0,"ps2_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+18,0,"ps2_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+19,0,"keycode",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+20,0,"ascii_code",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+21,0,"key_count",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+22,0,"seg_key",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 15,0);
    tracep->declBus(c+23,0,"seg_ascii",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 15,0);
    tracep->declBus(c+24,0,"seg_count",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 15,0);
    tracep->pushPrefix("keyboard_display", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+15,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+16,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+17,0,"ps2_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+18,0,"ps2_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+19,0,"keycode",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+20,0,"ascii_code",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+21,0,"key_count",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+22,0,"seg_key",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 15,0);
    tracep->declBus(c+23,0,"seg_ascii",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 15,0);
    tracep->declBus(c+24,0,"seg_count",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 15,0);
    tracep->declBit(c+1,0,"key_down",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"keyup_flag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+3,0,"buffer",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 9,0);
    tracep->declBus(c+4,0,"count",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+5,0,"ps2_clk_sync",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBit(c+6,0,"sampling",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("u_key_rom", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+19,0,"key_code",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+20,0,"ascill_code",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->popPrefix();
    tracep->pushPrefix("u_seg_ascii", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+25,0,"key_code",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+7,0,"seg",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->popPrefix();
    tracep->pushPrefix("u_seg_ascii_1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+26,0,"key_code",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+8,0,"seg",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->popPrefix();
    tracep->pushPrefix("u_seg_count", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+27,0,"key_code",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+9,0,"seg",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->popPrefix();
    tracep->pushPrefix("u_seg_count_1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+28,0,"key_code",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+10,0,"seg",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->popPrefix();
    tracep->pushPrefix("u_seg_key", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+11,0,"key_code",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+12,0,"seg",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->popPrefix();
    tracep->pushPrefix("u_seg_key_1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+13,0,"key_code",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+14,0,"seg",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void Vkeyboard_display___024root__trace_init_top(Vkeyboard_display___024root* vlSelf, VerilatedVcd* tracep) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root__trace_init_top\n"); );
    // Body
    Vkeyboard_display___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vkeyboard_display___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vkeyboard_display___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vkeyboard_display___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vkeyboard_display___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vkeyboard_display___024root__trace_register(Vkeyboard_display___024root* vlSelf, VerilatedVcd* tracep) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root__trace_register\n"); );
    // Body
    tracep->addConstCb(&Vkeyboard_display___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&Vkeyboard_display___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&Vkeyboard_display___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vkeyboard_display___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vkeyboard_display___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root__trace_const_0\n"); );
    // Init
    Vkeyboard_display___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vkeyboard_display___024root*>(voidSelf);
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
}

VL_ATTR_COLD void Vkeyboard_display___024root__trace_full_0_sub_0(Vkeyboard_display___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vkeyboard_display___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root__trace_full_0\n"); );
    // Init
    Vkeyboard_display___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vkeyboard_display___024root*>(voidSelf);
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vkeyboard_display___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vkeyboard_display___024root__trace_full_0_sub_0(Vkeyboard_display___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    (void)vlSelf;  // Prevent unused variable warning
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vkeyboard_display___024root__trace_full_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullBit(oldp+1,(vlSelf->keyboard_display__DOT__key_down));
    bufp->fullBit(oldp+2,(vlSelf->keyboard_display__DOT__keyup_flag));
    bufp->fullSData(oldp+3,(vlSelf->keyboard_display__DOT__buffer),10);
    bufp->fullCData(oldp+4,(vlSelf->keyboard_display__DOT__count),4);
    bufp->fullCData(oldp+5,(vlSelf->keyboard_display__DOT__ps2_clk_sync),3);
    bufp->fullBit(oldp+6,((IData)((4U == (6U & (IData)(vlSelf->keyboard_display__DOT__ps2_clk_sync))))));
    bufp->fullCData(oldp+7,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_ascii__seg),8);
    bufp->fullCData(oldp+8,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_ascii_1__seg),8);
    bufp->fullCData(oldp+9,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_count__seg),8);
    bufp->fullCData(oldp+10,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_count_1__seg),8);
    bufp->fullCData(oldp+11,((0xfU & ((IData)(vlSelf->keyboard_display__DOT__buffer) 
                                      >> 1U))),4);
    bufp->fullCData(oldp+12,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_key__seg),8);
    bufp->fullCData(oldp+13,((0xfU & ((IData)(vlSelf->keyboard_display__DOT__buffer) 
                                      >> 5U))),4);
    bufp->fullCData(oldp+14,(vlSelf->keyboard_display__DOT____Vcellout__u_seg_key_1__seg),8);
    bufp->fullBit(oldp+15,(vlSelf->reset));
    bufp->fullBit(oldp+16,(vlSelf->clk));
    bufp->fullBit(oldp+17,(vlSelf->ps2_clk));
    bufp->fullBit(oldp+18,(vlSelf->ps2_data));
    bufp->fullCData(oldp+19,(vlSelf->keycode),8);
    bufp->fullCData(oldp+20,(vlSelf->ascii_code),8);
    bufp->fullCData(oldp+21,(vlSelf->key_count),8);
    bufp->fullSData(oldp+22,(vlSelf->seg_key),16);
    bufp->fullSData(oldp+23,(vlSelf->seg_ascii),16);
    bufp->fullSData(oldp+24,(vlSelf->seg_count),16);
    bufp->fullCData(oldp+25,((0xfU & (IData)(vlSelf->ascii_code))),4);
    bufp->fullCData(oldp+26,((0xfU & ((IData)(vlSelf->ascii_code) 
                                      >> 4U))),4);
    bufp->fullCData(oldp+27,((0xfU & (IData)(vlSelf->key_count))),4);
    bufp->fullCData(oldp+28,((0xfU & ((IData)(vlSelf->key_count) 
                                      >> 4U))),4);
}
