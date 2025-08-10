// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vysyx_22040080_cpu.h for the primary calling header

#include "Vysyx_22040080_cpu__pch.h"
#include "Vysyx_22040080_cpu___024root.h"

VL_ATTR_COLD void Vysyx_22040080_cpu___024root___eval_static(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vysyx_22040080_cpu___024root___eval_initial(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
}

VL_ATTR_COLD void Vysyx_22040080_cpu___024root___eval_final(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_final\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vysyx_22040080_cpu___024root___dump_triggers__stl(Vysyx_22040080_cpu___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vysyx_22040080_cpu___024root___eval_phase__stl(Vysyx_22040080_cpu___024root* vlSelf);

VL_ATTR_COLD void Vysyx_22040080_cpu___024root___eval_settle(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_settle\n"); );
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
            Vysyx_22040080_cpu___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("/home/wp/ysyx-workbench/npc/vsrc/ysyx_22040080_cpu.v", 1, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vysyx_22040080_cpu___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelf->__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vysyx_22040080_cpu___024root___dump_triggers__stl(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ vlSelf->__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vysyx_22040080_cpu___024root___stl_sequent__TOP__0(Vysyx_22040080_cpu___024root* vlSelf);

VL_ATTR_COLD void Vysyx_22040080_cpu___024root___eval_stl(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vysyx_22040080_cpu___024root___stl_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[1U] = 1U;
        vlSelf->__Vm_traceActivity[0U] = 1U;
    }
}

VL_ATTR_COLD void Vysyx_22040080_cpu___024root___stl_sequent__TOP__0(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___stl_sequent__TOP__0\n"); );
    // Body
    vlSelf->trace_pc = vlSelf->ysyx_22040080_cpu__DOT__pc;
    vlSelf->trace_instr = vlSelf->ysyx_22040080_cpu__DOT__instruction;
    vlSelf->ysyx_22040080_cpu__DOT__rs1_data = ((0U 
                                                 == 
                                                 (0x1fU 
                                                  & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                                     >> 0xfU)))
                                                 ? 0U
                                                 : 
                                                vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf
                                                [(0x1fU 
                                                  & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                                     >> 0xfU))]);
    vlSelf->ysyx_22040080_cpu__DOT__instr_type = ((0x33U 
                                                   == 
                                                   (0x7fU 
                                                    & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                                   ? 0U
                                                   : 
                                                  ((0x13U 
                                                    == 
                                                    (0x7fU 
                                                     & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                                    ? 1U
                                                    : 
                                                   ((3U 
                                                     == 
                                                     (0x7fU 
                                                      & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                                     ? 1U
                                                     : 
                                                    ((0x67U 
                                                      == 
                                                      (0x7fU 
                                                       & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                                      ? 1U
                                                      : 
                                                     ((0x73U 
                                                       == 
                                                       (0x7fU 
                                                        & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                                       ? 1U
                                                       : 
                                                      ((0x23U 
                                                        == 
                                                        (0x7fU 
                                                         & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                                        ? 2U
                                                        : 
                                                       ((0x63U 
                                                         == 
                                                         (0x7fU 
                                                          & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                                         ? 3U
                                                         : 
                                                        ((0x37U 
                                                          == 
                                                          (0x7fU 
                                                           & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                                          ? 4U
                                                          : 
                                                         ((0x17U 
                                                           == 
                                                           (0x7fU 
                                                            & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                                           ? 4U
                                                           : 
                                                          ((0x6fU 
                                                            == 
                                                            (0x7fU 
                                                             & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                                            ? 5U
                                                            : 7U))))))))));
    vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm = 
        ((4U & (IData)(vlSelf->ysyx_22040080_cpu__DOT__instr_type))
          ? ((2U & (IData)(vlSelf->ysyx_22040080_cpu__DOT__instr_type))
              ? 0U : ((1U & (IData)(vlSelf->ysyx_22040080_cpu__DOT__instr_type))
                       ? (((- (IData)((vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                       >> 0x1fU))) 
                           << 0x14U) | ((0xff000U & vlSelf->ysyx_22040080_cpu__DOT__instruction) 
                                        | ((0x800U 
                                            & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                               >> 9U)) 
                                           | (0x7feU 
                                              & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                                 >> 0x14U)))))
                       : (0xfffff000U & vlSelf->ysyx_22040080_cpu__DOT__instruction)))
          : ((2U & (IData)(vlSelf->ysyx_22040080_cpu__DOT__instr_type))
              ? ((1U & (IData)(vlSelf->ysyx_22040080_cpu__DOT__instr_type))
                  ? (((- (IData)((vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                  >> 0x1fU))) << 0xcU) 
                     | ((0x800U & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                   << 4U)) | ((0x7e0U 
                                               & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                                  >> 0x14U)) 
                                              | (0x1eU 
                                                 & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                                    >> 7U)))))
                  : (((- (IData)((vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                  >> 0x1fU))) << 0xcU) 
                     | ((0xfe0U & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                   >> 0x14U)) | (0x1fU 
                                                 & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                                    >> 7U)))))
              : ((1U & (IData)(vlSelf->ysyx_22040080_cpu__DOT__instr_type))
                  ? (((- (IData)((vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                  >> 0x1fU))) << 0xcU) 
                     | (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                        >> 0x14U)) : 0U)));
    vlSelf->ysyx_22040080_cpu__DOT__alu__DOT__alu_sum 
        = (((0x13U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))
             ? vlSelf->ysyx_22040080_cpu__DOT__rs1_data
             : ((0x17U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                 ? vlSelf->ysyx_22040080_cpu__DOT__pc
                 : ((0x67U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                     ? vlSelf->ysyx_22040080_cpu__DOT__rs1_data
                     : ((0x6fU == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                         ? vlSelf->ysyx_22040080_cpu__DOT__pc
                         : 0U)))) + vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm);
    vlSelf->ysyx_22040080_cpu__DOT__alu_result = 0U;
    vlSelf->ysyx_22040080_cpu__DOT__jal_target = 0U;
    vlSelf->ysyx_22040080_cpu__DOT__wen = 0U;
    if ((1U & (~ (((IData)((0U == (0x707fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))) 
                   & (0U == vlSelf->ysyx_22040080_cpu__DOT__rs1_data)) 
                  & (0U == vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm))))) {
        if ((0x40U & vlSelf->ysyx_22040080_cpu__DOT__instruction)) {
            if (VL_LIKELY((0x20U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                if ((0x10U & vlSelf->ysyx_22040080_cpu__DOT__instruction)) {
                    if (VL_UNLIKELY((8U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                        VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                     7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                    } else if (VL_UNLIKELY((4U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                        VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                     7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                    } else if (VL_LIKELY((2U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                        if ((1U & vlSelf->ysyx_22040080_cpu__DOT__instruction)) {
                            VL_WRITEF_NX("EBREAK at PC: 0x%08x\n",0,
                                         32,vlSelf->ysyx_22040080_cpu__DOT__pc);
                        } else {
                            VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                         7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                        }
                    } else {
                        VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                     7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                    }
                } else if ((8U & vlSelf->ysyx_22040080_cpu__DOT__instruction)) {
                    if (VL_LIKELY((4U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                        if (VL_LIKELY((2U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                            if (VL_LIKELY((1U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                                vlSelf->ysyx_22040080_cpu__DOT__alu_result 
                                    = ((IData)(4U) 
                                       + vlSelf->ysyx_22040080_cpu__DOT__pc);
                                vlSelf->ysyx_22040080_cpu__DOT__jal_target 
                                    = vlSelf->ysyx_22040080_cpu__DOT__alu__DOT__alu_sum;
                                vlSelf->ysyx_22040080_cpu__DOT__wen = 1U;
                            } else {
                                VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                             7,(0x7fU 
                                                & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                            }
                        } else {
                            VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                         7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                        }
                    } else {
                        VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                     7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                    }
                } else if (VL_LIKELY((4U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                    if (VL_LIKELY((2U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                        if (VL_LIKELY((1U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                            vlSelf->ysyx_22040080_cpu__DOT__alu_result 
                                = ((IData)(4U) + vlSelf->ysyx_22040080_cpu__DOT__pc);
                            vlSelf->ysyx_22040080_cpu__DOT__jal_target 
                                = (0xfffffffeU & vlSelf->ysyx_22040080_cpu__DOT__alu__DOT__alu_sum);
                            vlSelf->ysyx_22040080_cpu__DOT__wen = 1U;
                        } else {
                            VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                         7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                        }
                    } else {
                        VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                     7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                    }
                } else {
                    VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                 7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                }
            } else {
                VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                             7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
            }
        } else if ((0x20U & vlSelf->ysyx_22040080_cpu__DOT__instruction)) {
            if (VL_LIKELY((0x10U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                if (VL_UNLIKELY((8U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                    VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                 7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                } else if (VL_LIKELY((4U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                    if (VL_LIKELY((2U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                        if (VL_LIKELY((1U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                            vlSelf->ysyx_22040080_cpu__DOT__alu_result 
                                = vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm;
                            vlSelf->ysyx_22040080_cpu__DOT__wen = 1U;
                        } else {
                            VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                         7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                        }
                    } else {
                        VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                     7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                    }
                } else {
                    VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                 7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                }
            } else {
                VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                             7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
            }
        } else if (VL_LIKELY((0x10U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
            if (VL_UNLIKELY((8U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                             7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
            } else if ((4U & vlSelf->ysyx_22040080_cpu__DOT__instruction)) {
                if (VL_LIKELY((2U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                    if (VL_LIKELY((1U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                        vlSelf->ysyx_22040080_cpu__DOT__alu_result 
                            = vlSelf->ysyx_22040080_cpu__DOT__alu__DOT__alu_sum;
                        vlSelf->ysyx_22040080_cpu__DOT__wen = 1U;
                    } else {
                        VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                     7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                    }
                } else {
                    VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                 7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                }
            } else if (VL_LIKELY((2U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                if (VL_LIKELY((1U & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                    if ((0x4000U & vlSelf->ysyx_22040080_cpu__DOT__instruction)) {
                        if ((0x2000U & vlSelf->ysyx_22040080_cpu__DOT__instruction)) {
                            if ((0x1000U & vlSelf->ysyx_22040080_cpu__DOT__instruction)) {
                                vlSelf->ysyx_22040080_cpu__DOT__alu_result 
                                    = (vlSelf->ysyx_22040080_cpu__DOT__rs1_data 
                                       & vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm);
                                vlSelf->ysyx_22040080_cpu__DOT__wen = 1U;
                            } else {
                                vlSelf->ysyx_22040080_cpu__DOT__alu_result 
                                    = (vlSelf->ysyx_22040080_cpu__DOT__rs1_data 
                                       | vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm);
                                vlSelf->ysyx_22040080_cpu__DOT__wen = 1U;
                            }
                        } else if (VL_UNLIKELY((0x1000U 
                                                & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                            VL_WRITEF_NX("ERROR: Unsupported func3 %b for I-type instruction\n",0,
                                         3,(7U & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                                  >> 0xcU)));
                        } else {
                            vlSelf->ysyx_22040080_cpu__DOT__alu_result 
                                = (vlSelf->ysyx_22040080_cpu__DOT__rs1_data 
                                   ^ vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm);
                            vlSelf->ysyx_22040080_cpu__DOT__wen = 1U;
                        }
                    } else if (VL_UNLIKELY((0x2000U 
                                            & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                        VL_WRITEF_NX("ERROR: Unsupported func3 %b for I-type instruction\n",0,
                                     3,(7U & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                              >> 0xcU)));
                    } else if (VL_UNLIKELY((0x1000U 
                                            & vlSelf->ysyx_22040080_cpu__DOT__instruction))) {
                        VL_WRITEF_NX("ERROR: Unsupported func3 %b for I-type instruction\n",0,
                                     3,(7U & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                              >> 0xcU)));
                    } else {
                        vlSelf->ysyx_22040080_cpu__DOT__alu_result 
                            = vlSelf->ysyx_22040080_cpu__DOT__alu__DOT__alu_sum;
                        vlSelf->ysyx_22040080_cpu__DOT__wen = 1U;
                    }
                } else {
                    VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                                 7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
                }
            } else {
                VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                             7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
            }
        } else {
            VL_WRITEF_NX("ERROR: Unsupported opcode %b for func3=000\n",0,
                         7,(0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction));
        }
    }
    vlSelf->dnpc = vlSelf->ysyx_22040080_cpu__DOT__jal_target;
}

VL_ATTR_COLD void Vysyx_22040080_cpu___024root___eval_triggers__stl(Vysyx_22040080_cpu___024root* vlSelf);

VL_ATTR_COLD bool Vysyx_22040080_cpu___024root___eval_phase__stl(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_phase__stl\n"); );
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vysyx_22040080_cpu___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelf->__VstlTriggered.any();
    if (__VstlExecute) {
        Vysyx_22040080_cpu___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vysyx_22040080_cpu___024root___dump_triggers__act(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___dump_triggers__act\n"); );
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
VL_ATTR_COLD void Vysyx_22040080_cpu___024root___dump_triggers__nba(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ vlSelf->__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vysyx_22040080_cpu___024root___ctor_var_reset(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = 0;
    vlSelf->rst = 0;
    vlSelf->trace_pc = 0;
    vlSelf->trace_instr = 0;
    vlSelf->dnpc = 0;
    vlSelf->ysyx_22040080_cpu__DOT__pc = 0;
    vlSelf->ysyx_22040080_cpu__DOT__alu_result = 0;
    vlSelf->ysyx_22040080_cpu__DOT__instruction = 0;
    vlSelf->ysyx_22040080_cpu__DOT__rs1_data = 0;
    vlSelf->ysyx_22040080_cpu__DOT__wen = 0;
    vlSelf->ysyx_22040080_cpu__DOT__instr_type = 0;
    vlSelf->ysyx_22040080_cpu__DOT__jal_target = 0;
    vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm = 0;
    vlSelf->ysyx_22040080_cpu__DOT__alu__DOT__alu_sum = 0;
    for (int __Vi0 = 0; __Vi0 < 32; ++__Vi0) {
        vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
