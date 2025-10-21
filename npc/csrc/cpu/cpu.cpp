#include <stdio.h>
#include "cpu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vysyx_22040080_cpu.h"
#include "Vysyx_22040080_cpu___024root.h"
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
static Vysyx_22040080_cpu* top = NULL;
static Vysyx_22040080_cpu___024root* rootp = NULL;

extern "C" void get_reg_info(uint32_t regs[32]);
// extern "C" void get_pc(uint32_t *pc_val);
static svScope regfile_scope = NULL;
static uint32_t regs[32];

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
  tfp->dump(contextp->time());
  contextp->timeInc(1);
}

void sim_init() {
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vysyx_22040080_cpu;
  rootp = top->rootp;

  init_disasm("riscv32-pc-linux-gnu"); // 初始化反汇编器
  contextp->traceEverOn(true); // 关闭波形器可以运行红白机模拟器 make ARCH=native run mainargs=mario
  top->trace(tfp, 0);
  tfp->open("dump.vcd");
}

void sim_exit() {
  step_and_dump_wave();
  if(tfp) tfp->close();
}

void reset(int n) {
  top->rst = 1; 
  while (n-- > 0)
    single_cycyle(); // exec_once();
  top->rst = 0;
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
  // uint32_t npc_pc;
  uint32_t regs[32];
  regfile_scope = svGetScopeFromName("TOP.ysyx_22040080_cpu.regfile");
  assert(regfile_scope);
  svScope prev_scope = svSetScope(regfile_scope); // 保存当前作用域并切换到寄存器文件作用域
  get_reg_info(regs); // 获取寄存器的值
  svSetScope(prev_scope); //关闭作用域
  // printf("get reg infomation done!\n");
  regs[0] = 0; //rf[0]在初始化的时候已经赋值为0了
  for (int i = 0; i < 32; i++) {
    cpu->gpr[i] = regs[i]; 
  }
  cpu->pc = CONFIG_MBASE;

  // 读取 CSR
  uint32_t mstatus, mepc, mcause, mtvec, mvendorid, marchid;
  svScope csr_scope = svGetScopeFromName("TOP.ysyx_22040080_cpu.csr");
  assert(csr_scope);
  svScope prev_scope2 = svSetScope(csr_scope);
  get_csr_info(&mstatus, &mepc, &mcause, &mtvec, &mvendorid, &marchid);
  svSetScope(prev_scope2);

  cpu->sr.mstatus   = mstatus;
  cpu->sr.mepc      = mepc;
  cpu->sr.mcause    = mcause;
  cpu->sr.mtvec     = mtvec;
  cpu->sr.mvendorid = mvendorid;
  cpu->sr.marchid   = marchid;
  // 新增：打印 NPC 的 cpu 结构中 CSR 值
  printf("[NPC CSR] mstatus=0x%x, mepc= 0x%x, mcause=0x%x, mtvec=0x%x\n",cpu->sr.mstatus, cpu->sr.mepc, cpu->sr.mcause,cpu->sr.mtvec);
  printf("[NPC] cpu->sr.mvendorid=0x%x, cpu->sr.marchid=0x%x\n", cpu->sr.mvendorid, cpu->sr.marchid);
  printf("[DiffTest Init] Registers fully synchronized from RTL.\n");
  // 新增：将NPC的CPU_state同步到NEMU（REF）
  // difftest_regcpy(cpu, DIFFTEST_TO_REF);
}

void print_cpu_regs(const CPU_state *cpu) {
    for (int i = 0; i < 32; i++) {
        printf("x%-2d = 0x%08x\n", i, cpu->gpr[i]);
    }
    printf("pc = 0x%08x\n", cpu->pc);
}

void exec_once() {
  // 一个周期 = clk 拉低 -> clk 拉高 -> eval 两次
  top->clk = 0; top->eval(); step_and_dump_wave();
  top->clk = 1; top->eval(); step_and_dump_wave();
  
  // 跟踪 PC/指令（可选）itrace
  cpu.pc = rootp->trace_pc; // 记录的是next_pc 当前pc的内容并未写回
  uint32_t inst = rootp->trace_instr;
  // printf("Before difftest_exec: pc=0x%08x\n", cpu.pc);
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
  CPU_state ref_cpu;
  // 把 REF 的寄存器同步回来
  difftest_regcpy(&ref_cpu, DIFFTEST_TO_DUT);  // memcpy(&cpu, dut, sizeof(CPU_state));
  // printf("DUT pc=0x%08x, REF pc=0x%08x\n", cpu.pc, ref_cpu.pc);
  /* printf("DUT regs:\n");
  print_cpu_regs(&cpu);
  printf("REF regs:\n");
  print_cpu_regs(&ref_cpu); */
  
  // 比对寄存器
  if (check_regs(&cpu, &ref_cpu)) {
    printf("Difftest mismatch at pc = 0x%08x\n", cpu.pc);
    printf_inst_error(cpu.pc);
    contextp->gotFinish(true);
    // assert(0);
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
  top->clk = 0; top->eval(); step_and_dump_wave();
  top->clk = 1; top->eval(); step_and_dump_wave();
}

void print_registers() {
  for (int i = 0; i < 32; i++) {
    printf("x%-2d (%3s): 0x%08x\n", i, reg_names[i], rootp->ysyx_22040080_cpu__DOT__regfile__DOT__rf[i]);
  }
}

// DPI-C 函数
extern "C" void ebreak_trigger() {
  sim_finished = true;
  uint32_t exit_code = rootp->ysyx_22040080_cpu__DOT__regfile__DOT__rf[10];
  if ((exit_code & 0xff) == 0) {
    printf("\33[1;32mHIT GOOD TRAP\33[0m\n");
  } else {
    printf("\33[1;31mHIT BAD TRAP (code = %u)\33[0m\n", exit_code);
  }
}

extern "C" uint32_t get_reg_val(const char *regname) {
  printf("get_reg_val: %s\n", regname);
  int idx = atoi(regname + 1); // skip 'x'
  return rootp->ysyx_22040080_cpu__DOT__regfile__DOT__rf[idx];
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
