// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vysyx_22040080_cpu__Syms.h"


void Vysyx_22040080_cpu___024root__trace_chg_0_sub_0(Vysyx_22040080_cpu___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vysyx_22040080_cpu___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root__trace_chg_0\n"); );
    // Init
    Vysyx_22040080_cpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vysyx_22040080_cpu___024root*>(voidSelf);
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vysyx_22040080_cpu___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vysyx_22040080_cpu___024root__trace_chg_0_sub_0(Vysyx_22040080_cpu___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root__trace_chg_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgIData(oldp+0,(vlSelf->ysyx_22040080_cpu__DOT__pc),32);
        bufp->chgIData(oldp+1,(vlSelf->ysyx_22040080_cpu__DOT__alu_result),32);
        bufp->chgIData(oldp+2,(vlSelf->ysyx_22040080_cpu__DOT__instruction),32);
        bufp->chgCData(oldp+3,((0x1fU & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                         >> 0xfU))),5);
        bufp->chgCData(oldp+4,((0x1fU & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                         >> 7U))),5);
        bufp->chgCData(oldp+5,((0x1fU & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                         >> 0x14U))),5);
        bufp->chgCData(oldp+6,((7U & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                      >> 0xcU))),3);
        bufp->chgIData(oldp+7,(vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm),32);
        bufp->chgCData(oldp+8,((0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction)),7);
        bufp->chgIData(oldp+9,(vlSelf->ysyx_22040080_cpu__DOT__rs1_data),32);
        bufp->chgBit(oldp+10,(vlSelf->ysyx_22040080_cpu__DOT__wen));
        bufp->chgBit(oldp+11,((IData)((0x100073U == 
                                       (0xfff0707fU 
                                        & vlSelf->ysyx_22040080_cpu__DOT__instruction)))));
        bufp->chgCData(oldp+12,(vlSelf->ysyx_22040080_cpu__DOT__instr_type),3);
        bufp->chgIData(oldp+13,(vlSelf->ysyx_22040080_cpu__DOT__jal_target),32);
        bufp->chgIData(oldp+14,((((0x63U == (0x7fU 
                                             & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                  & ((IData)(((0U == 
                                               (0x7000U 
                                                & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                              & (0U 
                                                 == vlSelf->ysyx_22040080_cpu__DOT__rs1_data))) 
                                     | ((IData)(((0x1000U 
                                                  == 
                                                  (0x7000U 
                                                   & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                                 & (0U 
                                                    != vlSelf->ysyx_22040080_cpu__DOT__rs1_data))) 
                                        | ((IData)(
                                                   ((0x4000U 
                                                     == 
                                                     (0x7000U 
                                                      & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                                    & VL_GTS_III(32, 0U, vlSelf->ysyx_22040080_cpu__DOT__rs1_data))) 
                                           | (IData)(
                                                     ((0x5000U 
                                                       == 
                                                       (0x7000U 
                                                        & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                                      & VL_LTES_III(32, 0U, vlSelf->ysyx_22040080_cpu__DOT__rs1_data)))))))
                                  ? (vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm 
                                     + vlSelf->ysyx_22040080_cpu__DOT__pc)
                                  : (((0x6fU == (0x7fU 
                                                 & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                      | (0x67U == (0x7fU 
                                                   & vlSelf->ysyx_22040080_cpu__DOT__instruction)))
                                      ? vlSelf->ysyx_22040080_cpu__DOT__jal_target
                                      : ((IData)(4U) 
                                         + vlSelf->ysyx_22040080_cpu__DOT__pc)))),32);
        bufp->chgBit(oldp+15,((0x6fU == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
        bufp->chgBit(oldp+16,((0x67U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
        bufp->chgBit(oldp+17,((0x63U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
        bufp->chgBit(oldp+18,(((0x63U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                               & ((IData)(((0U == (0x7000U 
                                                   & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                           & (0U == vlSelf->ysyx_22040080_cpu__DOT__rs1_data))) 
                                  | ((IData)(((0x1000U 
                                               == (0x7000U 
                                                   & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                              & (0U 
                                                 != vlSelf->ysyx_22040080_cpu__DOT__rs1_data))) 
                                     | ((IData)(((0x4000U 
                                                  == 
                                                  (0x7000U 
                                                   & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                                 & VL_GTS_III(32, 0U, vlSelf->ysyx_22040080_cpu__DOT__rs1_data))) 
                                        | (IData)((
                                                   (0x5000U 
                                                    == 
                                                    (0x7000U 
                                                     & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                                   & VL_LTES_III(32, 0U, vlSelf->ysyx_22040080_cpu__DOT__rs1_data)))))))));
        bufp->chgIData(oldp+19,((vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm 
                                 + vlSelf->ysyx_22040080_cpu__DOT__pc)),32);
        bufp->chgIData(oldp+20,(((0x13U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                  ? vlSelf->ysyx_22040080_cpu__DOT__rs1_data
                                  : ((0x17U == (0x7fU 
                                                & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                      ? vlSelf->ysyx_22040080_cpu__DOT__pc
                                      : ((0x67U == 
                                          (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                          ? vlSelf->ysyx_22040080_cpu__DOT__rs1_data
                                          : ((0x6fU 
                                              == (0x7fU 
                                                  & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                              ? vlSelf->ysyx_22040080_cpu__DOT__pc
                                              : 0U))))),32);
        bufp->chgIData(oldp+21,(vlSelf->ysyx_22040080_cpu__DOT__alu__DOT__alu_sum),32);
        bufp->chgBit(oldp+22,((0x33U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
        bufp->chgBit(oldp+23,(((0x13U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                               | (3U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction)))));
        bufp->chgBit(oldp+24,((0x23U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
        bufp->chgBit(oldp+25,((0x37U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
        bufp->chgIData(oldp+26,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[0]),32);
        bufp->chgIData(oldp+27,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[1]),32);
        bufp->chgIData(oldp+28,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[2]),32);
        bufp->chgIData(oldp+29,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[3]),32);
        bufp->chgIData(oldp+30,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[4]),32);
        bufp->chgIData(oldp+31,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[5]),32);
        bufp->chgIData(oldp+32,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[6]),32);
        bufp->chgIData(oldp+33,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[7]),32);
        bufp->chgIData(oldp+34,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[8]),32);
        bufp->chgIData(oldp+35,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[9]),32);
        bufp->chgIData(oldp+36,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[10]),32);
        bufp->chgIData(oldp+37,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[11]),32);
        bufp->chgIData(oldp+38,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[12]),32);
        bufp->chgIData(oldp+39,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[13]),32);
        bufp->chgIData(oldp+40,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[14]),32);
        bufp->chgIData(oldp+41,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[15]),32);
        bufp->chgIData(oldp+42,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[16]),32);
        bufp->chgIData(oldp+43,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[17]),32);
        bufp->chgIData(oldp+44,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[18]),32);
        bufp->chgIData(oldp+45,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[19]),32);
        bufp->chgIData(oldp+46,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[20]),32);
        bufp->chgIData(oldp+47,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[21]),32);
        bufp->chgIData(oldp+48,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[22]),32);
        bufp->chgIData(oldp+49,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[23]),32);
        bufp->chgIData(oldp+50,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[24]),32);
        bufp->chgIData(oldp+51,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[25]),32);
        bufp->chgIData(oldp+52,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[26]),32);
        bufp->chgIData(oldp+53,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[27]),32);
        bufp->chgIData(oldp+54,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[28]),32);
        bufp->chgIData(oldp+55,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[29]),32);
        bufp->chgIData(oldp+56,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[30]),32);
        bufp->chgIData(oldp+57,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[31]),32);
    }
    bufp->chgBit(oldp+58,(vlSelf->clk));
    bufp->chgBit(oldp+59,(vlSelf->rst));
    bufp->chgIData(oldp+60,(vlSelf->trace_pc),32);
    bufp->chgIData(oldp+61,(vlSelf->trace_instr),32);
    bufp->chgIData(oldp+62,(vlSelf->dnpc),32);
}

void Vysyx_22040080_cpu___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root__trace_cleanup\n"); );
    // Init
    Vysyx_22040080_cpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vysyx_22040080_cpu___024root*>(voidSelf);
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
