// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vysyx_22040080_cpu.h for the primary calling header

#include "Vysyx_22040080_cpu__pch.h"
#include "Vysyx_22040080_cpu___024root.h"

void Vysyx_22040080_cpu___024root___eval_act(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_act\n"); );
}

void Vysyx_22040080_cpu___024root___nba_sequent__TOP__0(Vysyx_22040080_cpu___024root* vlSelf);

void Vysyx_22040080_cpu___024root___eval_nba(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vysyx_22040080_cpu___024root___nba_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[1U] = 1U;
    }
}

void Vysyx_22040080_cpu___024root____Vdpiimwrap_ysyx_22040080_cpu__DOT__ebreak_trigger_TOP();
void Vysyx_22040080_cpu___024root____Vdpiimwrap_ysyx_22040080_cpu__DOT__ifu__DOT__imem_read_TOP(IData/*31:0*/ pc, IData/*31:0*/ &imem_read__Vfuncrtn);

VL_INLINE_OPT void Vysyx_22040080_cpu___024root___nba_sequent__TOP__0(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___nba_sequent__TOP__0\n"); );
    // Init
    IData/*31:0*/ __Vfunc_ysyx_22040080_cpu__DOT__ifu__DOT__imem_read__1__Vfuncout;
    __Vfunc_ysyx_22040080_cpu__DOT__ifu__DOT__imem_read__1__Vfuncout = 0;
    IData/*31:0*/ __Vdly__ysyx_22040080_cpu__DOT__pc;
    __Vdly__ysyx_22040080_cpu__DOT__pc = 0;
    IData/*31:0*/ __Vdly__ysyx_22040080_cpu__DOT__instruction;
    __Vdly__ysyx_22040080_cpu__DOT__instruction = 0;
    IData/*31:0*/ __VdlyVal__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0;
    __VdlyVal__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0 = 0;
    CData/*4:0*/ __VdlyDim0__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0;
    __VdlyDim0__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0 = 0;
    CData/*0:0*/ __VdlySet__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0;
    __VdlySet__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0 = 0;
    // Body
    __Vdly__ysyx_22040080_cpu__DOT__pc = vlSelf->ysyx_22040080_cpu__DOT__pc;
    if ((IData)((0x100073U == (0xfff0707fU & vlSelf->ysyx_22040080_cpu__DOT__instruction)))) {
        Vysyx_22040080_cpu___024root____Vdpiimwrap_ysyx_22040080_cpu__DOT__ebreak_trigger_TOP();
    }
    __VdlySet__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0 = 0U;
    __Vdly__ysyx_22040080_cpu__DOT__instruction = vlSelf->ysyx_22040080_cpu__DOT__instruction;
    if (((IData)(vlSelf->ysyx_22040080_cpu__DOT__wen) 
         & (0U != (0x1fU & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                            >> 7U))))) {
        __VdlyVal__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0 
            = vlSelf->ysyx_22040080_cpu__DOT__alu_result;
        __VdlyDim0__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0 
            = (0x1fU & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                        >> 7U));
        __VdlySet__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0 = 1U;
    }
    __Vdly__ysyx_22040080_cpu__DOT__pc = ((IData)(vlSelf->rst)
                                           ? 0x80000000U
                                           : ((IData)(4U) 
                                              + vlSelf->ysyx_22040080_cpu__DOT__pc));
    if (VL_LIKELY(vlSelf->rst)) {
        __Vdly__ysyx_22040080_cpu__DOT__instruction = 0U;
    } else {
        VL_WRITEF_NX("pc %x\n",0,32,vlSelf->ysyx_22040080_cpu__DOT__pc);
        Vysyx_22040080_cpu___024root____Vdpiimwrap_ysyx_22040080_cpu__DOT__ifu__DOT__imem_read_TOP(vlSelf->ysyx_22040080_cpu__DOT__pc, __Vfunc_ysyx_22040080_cpu__DOT__ifu__DOT__imem_read__1__Vfuncout);
        __Vdly__ysyx_22040080_cpu__DOT__instruction 
            = __Vfunc_ysyx_22040080_cpu__DOT__ifu__DOT__imem_read__1__Vfuncout;
        VL_WRITEF_NX("instruction %x\n",0,32,vlSelf->ysyx_22040080_cpu__DOT__instruction);
    }
    if (__VdlySet__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0) {
        vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[__VdlyDim0__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0] 
            = __VdlyVal__ysyx_22040080_cpu__DOT__regfile__DOT__rf__v0;
    }
    vlSelf->ysyx_22040080_cpu__DOT__pc = __Vdly__ysyx_22040080_cpu__DOT__pc;
    vlSelf->ysyx_22040080_cpu__DOT__instruction = __Vdly__ysyx_22040080_cpu__DOT__instruction;
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

void Vysyx_22040080_cpu___024root___eval_triggers__act(Vysyx_22040080_cpu___024root* vlSelf);

bool Vysyx_22040080_cpu___024root___eval_phase__act(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vysyx_22040080_cpu___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vysyx_22040080_cpu___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vysyx_22040080_cpu___024root___eval_phase__nba(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vysyx_22040080_cpu___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vysyx_22040080_cpu___024root___dump_triggers__nba(Vysyx_22040080_cpu___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vysyx_22040080_cpu___024root___dump_triggers__act(Vysyx_22040080_cpu___024root* vlSelf);
#endif  // VL_DEBUG

void Vysyx_22040080_cpu___024root___eval(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vysyx_22040080_cpu___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("/home/wp/ysyx-workbench/npc/vsrc/ysyx_22040080_cpu.v", 1, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vysyx_22040080_cpu___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("/home/wp/ysyx-workbench/npc/vsrc/ysyx_22040080_cpu.v", 1, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vysyx_22040080_cpu___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vysyx_22040080_cpu___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vysyx_22040080_cpu___024root___eval_debug_assertions(Vysyx_22040080_cpu___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
}
#endif  // VL_DEBUG
