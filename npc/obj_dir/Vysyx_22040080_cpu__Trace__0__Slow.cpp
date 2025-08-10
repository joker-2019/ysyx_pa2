// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vysyx_22040080_cpu__Syms.h"


VL_ATTR_COLD void Vysyx_22040080_cpu___024root__trace_init_sub__TOP__0(Vysyx_22040080_cpu___024root* vlSelf, VerilatedVcd* tracep) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+59,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+60,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+61,0,"trace_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+62,0,"trace_instr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+63,0,"dnpc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("ysyx_22040080_cpu", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+59,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+60,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+61,0,"trace_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+62,0,"trace_instr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+63,0,"dnpc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+1,0,"pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+2,0,"alu_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+3,0,"instruction",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+4,0,"rs1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+5,0,"rd",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+6,0,"rs2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+7,0,"func3",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+8,0,"imm_ext",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+9,0,"op",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+10,0,"rs1_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+64,0,"rs2_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+11,0,"wen",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+12,0,"is_ebreak",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+13,0,"instr_type",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+14,0,"jal_target",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+15,0,"next_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+16,0,"is_jal",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+17,0,"is_jalr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+18,0,"is_branch",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+19,0,"branch_taken",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+20,0,"branch_target",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("alu", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+59,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+10,0,"rs1_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+8,0,"imm_ext",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+7,0,"func3",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+9,0,"op",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+1,0,"pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+2,0,"result",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+11,0,"wen",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+14,0,"jal_target",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+21,0,"alu_in1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+8,0,"alu_in2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+22,0,"alu_sum",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->popPrefix();
    tracep->pushPrefix("idu", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+3,0,"instruction",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+4,0,"rs1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+6,0,"rs2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+5,0,"rd",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+7,0,"func3",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+8,0,"imm_ext",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+9,0,"op",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBit(c+12,0,"is_ebreak",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+13,0,"instr_type",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBit(c+23,0,"is_r_type",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+24,0,"is_i_type",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+25,0,"is_s_type",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+18,0,"is_b_type",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+26,0,"is_u_type",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+16,0,"is_j_type",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+8,0,"imm",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->popPrefix();
    tracep->pushPrefix("ifu", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+59,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+60,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+1,0,"pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+3,0,"instruction",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->popPrefix();
    tracep->pushPrefix("regfile", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+59,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+11,0,"wen",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+4,0,"raddr1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+65,0,"raddr2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+5,0,"waddr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+2,0,"wdata",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+10,0,"rdata1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+64,0,"rdata2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("rf", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 32; ++i) {
        tracep->declBus(c+27+i*1,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, true,(i+0), 31,0);
    }
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void Vysyx_22040080_cpu___024root__trace_init_top(Vysyx_22040080_cpu___024root* vlSelf, VerilatedVcd* tracep) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root__trace_init_top\n"); );
    // Body
    Vysyx_22040080_cpu___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vysyx_22040080_cpu___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vysyx_22040080_cpu___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vysyx_22040080_cpu___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vysyx_22040080_cpu___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vysyx_22040080_cpu___024root__trace_register(Vysyx_22040080_cpu___024root* vlSelf, VerilatedVcd* tracep) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root__trace_register\n"); );
    // Body
    tracep->addConstCb(&Vysyx_22040080_cpu___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&Vysyx_22040080_cpu___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&Vysyx_22040080_cpu___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vysyx_22040080_cpu___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vysyx_22040080_cpu___024root__trace_const_0_sub_0(Vysyx_22040080_cpu___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vysyx_22040080_cpu___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root__trace_const_0\n"); );
    // Init
    Vysyx_22040080_cpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vysyx_22040080_cpu___024root*>(voidSelf);
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vysyx_22040080_cpu___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vysyx_22040080_cpu___024root__trace_const_0_sub_0(Vysyx_22040080_cpu___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root__trace_const_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+64,(0U),32);
    bufp->fullCData(oldp+65,(0U),5);
}

VL_ATTR_COLD void Vysyx_22040080_cpu___024root__trace_full_0_sub_0(Vysyx_22040080_cpu___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vysyx_22040080_cpu___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root__trace_full_0\n"); );
    // Init
    Vysyx_22040080_cpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vysyx_22040080_cpu___024root*>(voidSelf);
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vysyx_22040080_cpu___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vysyx_22040080_cpu___024root__trace_full_0_sub_0(Vysyx_22040080_cpu___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    (void)vlSelf;  // Prevent unused variable warning
    Vysyx_22040080_cpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_22040080_cpu___024root__trace_full_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+1,(vlSelf->ysyx_22040080_cpu__DOT__pc),32);
    bufp->fullIData(oldp+2,(vlSelf->ysyx_22040080_cpu__DOT__alu_result),32);
    bufp->fullIData(oldp+3,(vlSelf->ysyx_22040080_cpu__DOT__instruction),32);
    bufp->fullCData(oldp+4,((0x1fU & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                      >> 0xfU))),5);
    bufp->fullCData(oldp+5,((0x1fU & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                      >> 7U))),5);
    bufp->fullCData(oldp+6,((0x1fU & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                      >> 0x14U))),5);
    bufp->fullCData(oldp+7,((7U & (vlSelf->ysyx_22040080_cpu__DOT__instruction 
                                   >> 0xcU))),3);
    bufp->fullIData(oldp+8,(vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm),32);
    bufp->fullCData(oldp+9,((0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction)),7);
    bufp->fullIData(oldp+10,(vlSelf->ysyx_22040080_cpu__DOT__rs1_data),32);
    bufp->fullBit(oldp+11,(vlSelf->ysyx_22040080_cpu__DOT__wen));
    bufp->fullBit(oldp+12,((IData)((0x100073U == (0xfff0707fU 
                                                  & vlSelf->ysyx_22040080_cpu__DOT__instruction)))));
    bufp->fullCData(oldp+13,(vlSelf->ysyx_22040080_cpu__DOT__instr_type),3);
    bufp->fullIData(oldp+14,(vlSelf->ysyx_22040080_cpu__DOT__jal_target),32);
    bufp->fullIData(oldp+15,((((0x63U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
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
                                                   & VL_LTES_III(32, 0U, vlSelf->ysyx_22040080_cpu__DOT__rs1_data)))))))
                               ? (vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm 
                                  + vlSelf->ysyx_22040080_cpu__DOT__pc)
                               : (((0x6fU == (0x7fU 
                                              & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                   | (0x67U == (0x7fU 
                                                & vlSelf->ysyx_22040080_cpu__DOT__instruction)))
                                   ? vlSelf->ysyx_22040080_cpu__DOT__jal_target
                                   : ((IData)(4U) + vlSelf->ysyx_22040080_cpu__DOT__pc)))),32);
    bufp->fullBit(oldp+16,((0x6fU == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
    bufp->fullBit(oldp+17,((0x67U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
    bufp->fullBit(oldp+18,((0x63U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
    bufp->fullBit(oldp+19,(((0x63U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                            & ((IData)(((0U == (0x7000U 
                                                & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                        & (0U == vlSelf->ysyx_22040080_cpu__DOT__rs1_data))) 
                               | ((IData)(((0x1000U 
                                            == (0x7000U 
                                                & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                           & (0U != vlSelf->ysyx_22040080_cpu__DOT__rs1_data))) 
                                  | ((IData)(((0x4000U 
                                               == (0x7000U 
                                                   & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                              & VL_GTS_III(32, 0U, vlSelf->ysyx_22040080_cpu__DOT__rs1_data))) 
                                     | (IData)(((0x5000U 
                                                 == 
                                                 (0x7000U 
                                                  & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                                                & VL_LTES_III(32, 0U, vlSelf->ysyx_22040080_cpu__DOT__rs1_data)))))))));
    bufp->fullIData(oldp+20,((vlSelf->ysyx_22040080_cpu__DOT__idu__DOT__imm 
                              + vlSelf->ysyx_22040080_cpu__DOT__pc)),32);
    bufp->fullIData(oldp+21,(((0x13U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                               ? vlSelf->ysyx_22040080_cpu__DOT__rs1_data
                               : ((0x17U == (0x7fU 
                                             & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                   ? vlSelf->ysyx_22040080_cpu__DOT__pc
                                   : ((0x67U == (0x7fU 
                                                 & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                       ? vlSelf->ysyx_22040080_cpu__DOT__rs1_data
                                       : ((0x6fU == 
                                           (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))
                                           ? vlSelf->ysyx_22040080_cpu__DOT__pc
                                           : 0U))))),32);
    bufp->fullIData(oldp+22,(vlSelf->ysyx_22040080_cpu__DOT__alu__DOT__alu_sum),32);
    bufp->fullBit(oldp+23,((0x33U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
    bufp->fullBit(oldp+24,(((0x13U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction)) 
                            | (3U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction)))));
    bufp->fullBit(oldp+25,((0x23U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
    bufp->fullBit(oldp+26,((0x37U == (0x7fU & vlSelf->ysyx_22040080_cpu__DOT__instruction))));
    bufp->fullIData(oldp+27,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[0]),32);
    bufp->fullIData(oldp+28,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[1]),32);
    bufp->fullIData(oldp+29,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[2]),32);
    bufp->fullIData(oldp+30,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[3]),32);
    bufp->fullIData(oldp+31,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[4]),32);
    bufp->fullIData(oldp+32,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[5]),32);
    bufp->fullIData(oldp+33,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[6]),32);
    bufp->fullIData(oldp+34,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[7]),32);
    bufp->fullIData(oldp+35,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[8]),32);
    bufp->fullIData(oldp+36,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[9]),32);
    bufp->fullIData(oldp+37,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[10]),32);
    bufp->fullIData(oldp+38,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[11]),32);
    bufp->fullIData(oldp+39,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[12]),32);
    bufp->fullIData(oldp+40,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[13]),32);
    bufp->fullIData(oldp+41,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[14]),32);
    bufp->fullIData(oldp+42,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[15]),32);
    bufp->fullIData(oldp+43,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[16]),32);
    bufp->fullIData(oldp+44,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[17]),32);
    bufp->fullIData(oldp+45,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[18]),32);
    bufp->fullIData(oldp+46,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[19]),32);
    bufp->fullIData(oldp+47,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[20]),32);
    bufp->fullIData(oldp+48,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[21]),32);
    bufp->fullIData(oldp+49,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[22]),32);
    bufp->fullIData(oldp+50,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[23]),32);
    bufp->fullIData(oldp+51,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[24]),32);
    bufp->fullIData(oldp+52,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[25]),32);
    bufp->fullIData(oldp+53,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[26]),32);
    bufp->fullIData(oldp+54,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[27]),32);
    bufp->fullIData(oldp+55,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[28]),32);
    bufp->fullIData(oldp+56,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[29]),32);
    bufp->fullIData(oldp+57,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[30]),32);
    bufp->fullIData(oldp+58,(vlSelf->ysyx_22040080_cpu__DOT__regfile__DOT__rf[31]),32);
    bufp->fullBit(oldp+59,(vlSelf->clk));
    bufp->fullBit(oldp+60,(vlSelf->rst));
    bufp->fullIData(oldp+61,(vlSelf->trace_pc),32);
    bufp->fullIData(oldp+62,(vlSelf->trace_instr),32);
    bufp->fullIData(oldp+63,(vlSelf->dnpc),32);
}
