#include <stdio.h>
#include "cpu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
// #include "Vysyx_22040080_cpu.h"
// #include "Vysyx_22040080_cpu___024root.h"
#include "VysyxSoCFull.h"
#include "VysyxSoCFull___024root.h"
#include "../utils/ftrace.h"
#include "../utils/utils.h"
#include "../utils/iringbuf.h"
#include "../config/config.h"
#include "../isa/riscv32/isa-def.h"
#include "../../include/cpu/difftest.h"
#include "../Memory/memory.h"
#include <svdpi.h>

// 外部函数
extern "C" void init_disasm(const char *triple);
extern "C" void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);

#define OPCODE_JAL   0x6F
#define OPCODE_JALR  0x67

CPU_state cpu = {};
// 全局状态
bool sim_finished = false;
VerilatedContext *contextp = NULL;
static VerilatedVcdC* tfp = NULL;
// static Vysyx_22040080_cpu* top = NULL;
// static Vysyx_22040080_cpu___024root* rootp = NULL;
static VysyxSoCFull* top = NULL;
static VysyxSoCFull___024root* rootp = NULL;

extern "C" void get_reg_info(uint32_t regs[32]);
extern "C" void get_instr_pc(uint32_t *out_pc, uint32_t *out_instr, svBit *out_done);

static svScope regfile_scope  = NULL;
static svScope csr_scope      = NULL;
static svScope instr_pc_scope = NULL;
static uint32_t regs[32];

// 初始化dpi-scope的名称
#define SCOPE_PREFIX "TOP.ysyxSoCFull.asic.cpu.cpu."

static void init_dpi_scopes() {
  if (!regfile_scope) {
    regfile_scope = svGetScopeFromName(SCOPE_PREFIX "regfile.getRegInfo");
    assert(regfile_scope);
  }
  if (!csr_scope) {
    csr_scope = svGetScopeFromName(SCOPE_PREFIX "csr.getCsrInfo");
    assert(csr_scope);
  }
  if (!instr_pc_scope) {
    instr_pc_scope = svGetScopeFromName(SCOPE_PREFIX "pc_mod.getInstrPc");
    assert(instr_pc_scope);
  }
}

static void dpi_get_regs(uint32_t out[32]) {
  init_dpi_scopes();
  svScope prev = svSetScope(regfile_scope);
  get_reg_info(out);
  svSetScope(prev);
  out[0] = 0;
}

const char* reg_names[] = {
  "$0","ra","sp","gp","tp","t0","t1","t2",
  "s0","s1","a0","a1","a2","a3","a4","a5",
  "a6","a7","s2","s3","s4","s5","s6","s7",
  "s8","s9","s10","s11","t3","t4","t5","t6"
};

extern "C" void get_csr_info(
  uint32_t *mstatus,
  uint32_t *mepc,
  uint32_t *mcause,
  uint32_t *mtvec,
  uint32_t *mvendorid,
  uint32_t *marchid
);

void step_and_dump_wave() {
  // top->eval();
  // tfp->dump(contextp->time());
  contextp->timeInc(1);
}

void sim_init() {
  contextp = new VerilatedContext;
  // tfp = new VerilatedVcdC;
  // top = new Vysyx_22040080_cpu;
  top = new VysyxSoCFull;
  rootp = top->rootp;

  init_disasm("riscv32-pc-linux-gnu"); // 初始化反汇编器
  contextp->traceEverOn(false); // 关闭波形器可以运行红白机模拟器 make ARCH=native run mainargs=mario
  // top->trace(tfp, 0);
  // tfp->open("dump.vcd");
}

void sim_exit() {
  step_and_dump_wave();
  // if(tfp) tfp->close();
}

void reset(int n) {
  top->reset = 1; 
  while (n-- > 0)
    single_cycyle(); // exec_once();
  top->reset = 0;
}


bool is_jal(uint32_t inst) {
  uint32_t opcode = inst & 0x7F;
  return opcode == OPCODE_JAL;
}

bool is_jalr(uint32_t inst) {
  uint32_t opcode = inst & 0x7F;
  return opcode == OPCODE_JALR;
}


extern "C" void update_register(CPU_state *cpu){
  printf("update_register start!!!\n");
  init_dpi_scopes();

  uint32_t regs[32];
  dpi_get_regs(regs);
  for (int i = 0; i < 32; i++) {
    cpu->gpr[i] = regs[i]; 
  }
  // cpu->pc = CONFIG_MBASE;
  cpu->pc = RESET_VECTOR;
  
  uint32_t mstatus, mepc, mcause, mtvec, mvendorid, marchid;
  svScope prev = svSetScope(csr_scope);
  get_csr_info(&mstatus, &mepc, &mcause, &mtvec, &mvendorid, &marchid);
  svSetScope(prev);

  cpu->sr.mstatus   = mstatus;
  cpu->sr.mepc      = mepc;
  cpu->sr.mcause    = mcause;
  cpu->sr.mtvec     = mtvec;
  cpu->sr.mvendorid = mvendorid;
  cpu->sr.marchid   = marchid;
  printf("[NPC CSR] mstatus=0x%x, mepc= 0x%x, mcause=0x%x, mtvec=0x%x\n",cpu->sr.mstatus, cpu->sr.mepc, cpu->sr.mcause,cpu->sr.mtvec);
  printf("[NPC] cpu->sr.mvendorid=0x%x, cpu->sr.marchid=0x%x\n", cpu->sr.mvendorid, cpu->sr.marchid);
  printf("[DiffTest Init] Registers fully synchronized from RTL.\n");
  printf("update_register end!!!\n");
}

void print_cpu_regs(const CPU_state *cpu) {
    for (int i = 0; i < 32; i++) {
        printf("x%-2d = 0x%08x\n", i, cpu->gpr[i]);
    }
    printf("pc = 0x%08x\n", cpu->pc);
}

void exec_once() {
  bool instr_finish = false;
  int timeout_cnt = 0;
  const int MAX_TIMEOUT = 5000000;
  uint32_t latched_pc = 0;
  uint32_t latched_inst = 0;
  bool has_latched_trace = false;

  init_dpi_scopes();

  while (!instr_finish && timeout_cnt < MAX_TIMEOUT)
  {
    // 一个周期 = clk 拉低 -> clk 拉高 -> eval 两次
    top->clock = 0; top->eval(); step_and_dump_wave();
    top->clock = 1; top->eval(); step_and_dump_wave();

    uint32_t dpi_pc, dpi_instr;
    svBit dpi_done;
    svScope prev = svSetScope(instr_pc_scope);
    get_instr_pc(&dpi_pc, &dpi_instr, &dpi_done);
    svSetScope(prev);

    if (dpi_done) {
      // 仅锁存“本条指令完成”对应的 trace，避免采到无效拍的 0/0
      latched_pc = dpi_pc;
      latched_inst = dpi_instr;
      has_latched_trace = true;
    }

    if (dpi_done || contextp->gotFinish()) {
      instr_finish = true;
    }
    timeout_cnt++;
  }
  // 检测到ebreak指令
  if (contextp->gotFinish()) {
    return;
  }
  // 超时判断（防止CPU卡死）
  if (!instr_finish) {
    /* 尝试从 DPI 读取当前 PC，辅助定位卡死位置 */
    uint32_t cur_pc = 0, cur_inst = 0;
    svBit cur_done = 0;
    svScope prev2 = svSetScope(instr_pc_scope);
    get_instr_pc(&cur_pc, &cur_inst, &cur_done);
    svSetScope(prev2);
    printf("Error: Instruction execution timeout (max %d cycles) at PC=0x%08x inst=0x%08x (last committed PC=0x%08x)\n",
           MAX_TIMEOUT, cur_pc, cur_inst, cpu.pc);
    contextp->gotFinish(true);
    return;
  }
  
  // 使用 done 拍锁存的 trace，避免循环退出后再次采样到无效值
  if (!has_latched_trace) {
    printf("Error: Missing valid trace when instruction finished\n");
    contextp->gotFinish(true);
    return;
  }
  cpu.pc = latched_pc;
  uint32_t inst = latched_inst;
  // Itrace 显示修正：当 PC 在硬件 SRAM 范围且 latched_inst 为 0 时，
  // 直接从 Verilog SRAM 读回当前指令，避免显示 c.unimp 的假象。
  if (inst == 0 &&
      cpu.pc >= SRAM_BASE &&
      cpu.pc < (SRAM_BASE + SRAM_SIZE)) {
    uint32_t idx = (cpu.pc - SRAM_BASE) >> 2;
    inst = rootp->ysyxSoCFull__DOT__asic__DOT__axi4ram__DOT__mem_ext__DOT__Memory[idx];
  }
  // NPC执行一条指令后，让REF(NEMU)执行一条

  // 多个 trace 可以 hook 在这里
  #if ENABLE_ITRACE
  itrace_exec(cpu.pc, inst);     // 反汇编 + iringbuf + 打印
  #endif

  #if ENABLE_FTRACE
  if(is_jal(inst) || is_jalr(inst)){
    check_call_or_ret(cpu.pc);    // 函数调用跟踪
  }
  #endif
  
  #if ENABLE_DIFFTEST
  difftest_exec(1);
  // ref_count++;
  // printf("exec count = %d\n", ref_count);
  CPU_state ref_cpu;
  // 把 REF 的寄存器同步回来
  difftest_regcpy(&ref_cpu, DIFFTEST_TO_DUT);  // memcpy(&cpu, dut, sizeof(CPU_state));
  
  // 比对寄存器
  if (check_regs(&cpu, &ref_cpu)) {
    printf("Difftest mismatch at pc = 0x%08x\n", cpu.pc);
    printf_inst_error(cpu.pc);
    contextp->gotFinish(true);
    // sim_finished = true;
  }else{
    // printf("Difftest PASS\n");
  }
  #endif

  // 每条指令执行完后更新设备
  device_update();
}

bool check_regs(CPU_state *dut, CPU_state *ref) {
    for (int i = 0; i < 32; i++) {
        if (dut->gpr[i] != ref->gpr[i]) {
            printf("Reg Mismatch at x%-2d (%3s): DUT = 0x%08x, REF = 0x%08x\n",
                   i, reg_names[i], dut->gpr[i], ref->gpr[i]);
            return true;
        }
    }
    if (dut->pc != ref->pc) {
        printf("PC Mismatch: DUT = 0x%08x, REF = 0x%08x\n", dut->pc, ref->pc);
        return true;
    }
    /*  // 新增：对比 CSR 寄存器
    if (dut->sr.mepc != ref->sr.mepc) {
        printf("CSR Mismatch: mepc | DUT=0x%08x, REF=0x%08x\n", dut->sr.mepc, ref->sr.mepc);
        return true;
    }
    if (dut->sr.mcause != ref->sr.mcause) {
        printf("CSR Mismatch: mcause | DUT=0x%08x, REF=0x%08x\n", dut->sr.mcause, ref->sr.mcause);
        return true;
    }
    if (dut->sr.mstatus != ref->sr.mstatus) {
        printf("CSR Mismatch: mstatus | DUT=0x%08x, REF=0x%08x\n", dut->sr.mstatus, ref->sr.mstatus);
        return true;
    }
    if (dut->sr.mtvec != ref->sr.mtvec) {
        printf("CSR Mismatch: mtvec | DUT=0x%08x, REF=0x%08x\n", dut->sr.mtvec, ref->sr.mtvec);
        return true;
    }
    if (dut->sr.mvendorid != ref->sr.mvendorid) {
        printf("CSR Mismatch: mvendorid | DUT=0x%08x, REF=0x%08x\n", dut->sr.mvendorid, ref->sr.mvendorid);
        return true;
    }
    if (dut->sr.marchid != ref->sr.marchid) {
        printf("CSR Mismatch: marchid | DUT=0x%08x, REF=0x%08x\n", dut->sr.marchid, ref->sr.marchid);
        return true;
    } */
    return false;
}

void check_register(CPU_state *cpu) {
    CPU_state nemu_cpu;

    // 从NEMU获取寄存器
    difftest_regcpy(&nemu_cpu, DIFFTEST_TO_DUT);

    // 检查PC
    if (cpu->pc != nemu_cpu.pc) {
        printf("[DiffTest Reg Mismatch] PC: npc = 0x%08x, nemu = 0x%08x\n", cpu->pc, nemu_cpu.pc);
        assert(0);
    }

    // 检查GPR
    for (int i = 0; i < 32; i++) {
        if (cpu->gpr[i] != nemu_cpu.gpr[i]) {
            printf("[DiffTest Reg Mismatch] x%d: npc = 0x%08x, nemu = 0x%08x\n",
                   i, cpu->gpr[i], nemu_cpu.gpr[i]);
            assert(0);
        }
    }

     // 新增：对比 CSR 寄存器
    if (cpu->sr.mepc != nemu_cpu.sr.mepc) {
        printf("INIT CSR Mismatch: mepc | DUT=0x%08x, REF=0x%08x\n", cpu->sr.mepc, nemu_cpu.sr.mepc);
        assert(0);
    }
    if (cpu->sr.mcause != nemu_cpu.sr.mcause) {
        printf("INIT CSR Mismatch: mcause | DUT=0x%08x, REF=0x%08x\n", cpu->sr.mcause, nemu_cpu.sr.mcause);
        assert(0);
    }
    if (cpu->sr.mstatus != nemu_cpu.sr.mstatus) {
        printf("INIT CSR Mismatch: mstatus | DUT=0x%08x, REF=0x%08x\n", cpu->sr.mstatus, nemu_cpu.sr.mstatus);
        assert(0);
    }
    if (cpu->sr.mtvec != nemu_cpu.sr.mtvec) {
        printf("INIT CSR Mismatch: mtvec | DUT=0x%08x, REF=0x%08x\n", cpu->sr.mtvec, nemu_cpu.sr.mtvec);
        assert(0);
    }
    if (cpu->sr.mvendorid != nemu_cpu.sr.mvendorid) {
        printf("INIT CSR Mismatch: mvendorid | DUT=0x%08x, REF=0x%08x\n", cpu->sr.mvendorid, nemu_cpu.sr.mvendorid);
        assert(0);
    }
    if (cpu->sr.marchid != nemu_cpu.sr.marchid) {
        printf("INIT CSR Mismatch: marchid | DUT=0x%08x, REF=0x%08x\n", cpu->sr.marchid, nemu_cpu.sr.marchid);
        assert(0);
    }

    printf("[DiffTest] Register Check Passed!\n");
}

void single_cycyle() {
  // 一个周期 = clk 拉低 -> clk 拉高 -> eval 两次
  top->clock = 0; top->eval(); step_and_dump_wave();
  top->clock = 1; top->eval(); step_and_dump_wave();
}

void print_registers() {
  uint32_t regs[32];
  dpi_get_regs(regs);
  for (int i = 0; i < 32; i++) {
    printf("x%-2d (%3s): 0x%08x\n", i, reg_names[i], regs[i]);
  }
}

extern "C" void ebreak_trigger() {
  contextp->gotFinish(true);
  uint32_t regs[32];
  dpi_get_regs(regs);
  uint32_t exit_code = regs[10]; // a0：0=GOOD，非0=BAD
  if ((exit_code & 0xff) == 0) {
    printf("\33[1;32mHIT GOOD TRAP\33[0m\n");
  } else {
    printf("\33[1;31mHIT BAD TRAP (code = %u)\33[0m\n", exit_code);
  }
}

extern "C" uint32_t get_reg_val(const char *regname) {
  printf("get_reg_val: %s\n", regname);
  int idx = atoi(regname + 1); // skip 'x'
  uint32_t regs[32];
  dpi_get_regs(regs);
  return regs[idx];
}

// RTL 写回时调用，更新 CPU 寄存器状态
extern "C" void reg_write_commit(int waddr, int wdata) {
    if (waddr != 0) {  // x0 永远为 0
        cpu.gpr[waddr] = wdata;
        // printf("[SYNC] %s <= 0x%08x\n", reg_names[waddr], wdata);
    }
}

extern "C" void csr_write_commit(int waddr, int wdata) {
    if (waddr != 0) { 
      switch (waddr & 0xFFF) { // 保留低 12 位
      case 0xF11:
        cpu.sr.mvendorid= wdata;
        // printf("[CSR SYNC] mvendorid <= 0x%08x\n", wdata);
        break;
      case 0xF12:
        cpu.sr.marchid= wdata;
        // printf("[CSR SYNC] marchid <= 0x%08x\n", wdata);
        break;
      case 0x300:
        cpu.sr.mstatus= wdata;
        // printf("[CSR SYNC] mstatus <= 0x%08x\n", wdata);
        break;
      case 0x305:
        cpu.sr.mtvec= wdata;
        // printf("[CSR SYNC] mtvec <= 0x%08x\n", wdata);
        break;
      case 0x341:
        cpu.sr.mepc= wdata;
        // printf("[CSR SYNC] mepc <= 0x%08x\n", wdata);
        break;
      case 0x342:
        cpu.sr.mcause= wdata;
        // printf("[CSR SYNC] mcause <= 0x%08x\n", wdata);
        break;
      default:
        printf("[CSR SYNC] Unknown CSR write: addr=0x%x, data=0x%08x\n", waddr, wdata);
        break;
      }
    }
}
