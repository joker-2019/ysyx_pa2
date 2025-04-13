// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vkeyboard_display.h for the primary calling header

#ifndef VERILATED_VKEYBOARD_DISPLAY___024ROOT_H_
#define VERILATED_VKEYBOARD_DISPLAY___024ROOT_H_  // guard

#include "verilated.h"


class Vkeyboard_display__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vkeyboard_display___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(reset,0,0);
    VL_IN8(ps2_clk,0,0);
    VL_IN8(ps2_data,0,0);
    VL_OUT8(keycode,7,0);
    VL_OUT8(ascii_code,7,0);
    VL_OUT8(key_count,7,0);
    CData/*0:0*/ keyboard_display__DOT__key_down;
    CData/*0:0*/ keyboard_display__DOT__keyup_flag;
    CData/*3:0*/ keyboard_display__DOT__count;
    CData/*2:0*/ keyboard_display__DOT__ps2_clk_sync;
    CData/*7:0*/ keyboard_display__DOT____Vcellout__u_seg_key__seg;
    CData/*7:0*/ keyboard_display__DOT____Vcellout__u_seg_key_1__seg;
    CData/*7:0*/ keyboard_display__DOT____Vcellout__u_seg_ascii__seg;
    CData/*7:0*/ keyboard_display__DOT____Vcellout__u_seg_ascii_1__seg;
    CData/*7:0*/ keyboard_display__DOT____Vcellout__u_seg_count__seg;
    CData/*7:0*/ keyboard_display__DOT____Vcellout__u_seg_count_1__seg;
    CData/*0:0*/ keyboard_display__DOT____Vlvbound_h2a4d04d8__0;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __VactContinue;
    VL_OUT16(seg_key,15,0);
    VL_OUT16(seg_ascii,15,0);
    VL_OUT16(seg_count,15,0);
    SData/*9:0*/ keyboard_display__DOT__buffer;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vkeyboard_display__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vkeyboard_display___024root(Vkeyboard_display__Syms* symsp, const char* v__name);
    ~Vkeyboard_display___024root();
    VL_UNCOPYABLE(Vkeyboard_display___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
