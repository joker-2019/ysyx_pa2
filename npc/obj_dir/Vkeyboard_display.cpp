// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vkeyboard_display__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vkeyboard_display::Vkeyboard_display(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vkeyboard_display__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , reset{vlSymsp->TOP.reset}
    , ps2_clk{vlSymsp->TOP.ps2_clk}
    , ps2_data{vlSymsp->TOP.ps2_data}
    , keycode{vlSymsp->TOP.keycode}
    , ascii_code{vlSymsp->TOP.ascii_code}
    , key_count{vlSymsp->TOP.key_count}
    , seg_key{vlSymsp->TOP.seg_key}
    , seg_ascii{vlSymsp->TOP.seg_ascii}
    , seg_count{vlSymsp->TOP.seg_count}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vkeyboard_display::Vkeyboard_display(const char* _vcname__)
    : Vkeyboard_display(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vkeyboard_display::~Vkeyboard_display() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vkeyboard_display___024root___eval_debug_assertions(Vkeyboard_display___024root* vlSelf);
#endif  // VL_DEBUG
void Vkeyboard_display___024root___eval_static(Vkeyboard_display___024root* vlSelf);
void Vkeyboard_display___024root___eval_initial(Vkeyboard_display___024root* vlSelf);
void Vkeyboard_display___024root___eval_settle(Vkeyboard_display___024root* vlSelf);
void Vkeyboard_display___024root___eval(Vkeyboard_display___024root* vlSelf);

void Vkeyboard_display::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vkeyboard_display::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vkeyboard_display___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vkeyboard_display___024root___eval_static(&(vlSymsp->TOP));
        Vkeyboard_display___024root___eval_initial(&(vlSymsp->TOP));
        Vkeyboard_display___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vkeyboard_display___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vkeyboard_display::eventsPending() { return false; }

uint64_t Vkeyboard_display::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vkeyboard_display::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vkeyboard_display___024root___eval_final(Vkeyboard_display___024root* vlSelf);

VL_ATTR_COLD void Vkeyboard_display::final() {
    Vkeyboard_display___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vkeyboard_display::hierName() const { return vlSymsp->name(); }
const char* Vkeyboard_display::modelName() const { return "Vkeyboard_display"; }
unsigned Vkeyboard_display::threads() const { return 1; }
void Vkeyboard_display::prepareClone() const { contextp()->prepareClone(); }
void Vkeyboard_display::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vkeyboard_display::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vkeyboard_display___024root__trace_decl_types(VerilatedVcd* tracep);

void Vkeyboard_display___024root__trace_init_top(Vkeyboard_display___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vkeyboard_display___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vkeyboard_display___024root*>(voidSelf);
    Vkeyboard_display__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(std::string{vlSymsp->name()}, VerilatedTracePrefixType::SCOPE_MODULE);
    Vkeyboard_display___024root__trace_decl_types(tracep);
    Vkeyboard_display___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vkeyboard_display___024root__trace_register(Vkeyboard_display___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vkeyboard_display::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vkeyboard_display::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vkeyboard_display___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
