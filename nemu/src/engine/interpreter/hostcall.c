/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <utils.h>
#include <cpu/ifetch.h>
#include <isa.h>
#include <cpu/difftest.h>
#include <cpu/decode.h>

void set_nemu_state(int state, vaddr_t pc, int halt_ret) {
  difftest_skip_ref();
  nemu_state.state = state;
  nemu_state.halt_pc = pc;
  nemu_state.halt_ret = halt_ret;
}

__attribute__((noinline))
void invalid_inst(vaddr_t thispc) {
  uint32_t temp[2];
  vaddr_t pc = thispc;
  temp[0] = inst_fetch(&pc, 4);
  temp[1] = inst_fetch(&pc, 4);

  uint8_t *p = (uint8_t *)temp;
  printf("invalid opcode(PC = " FMT_WORD "):\n"
      "\t%02x %02x %02x %02x %02x %02x %02x %02x ...\n"
      "\t%08x %08x...\n",
      thispc, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], temp[0], temp[1]);

  printf("There are two cases which will trigger this unexpected exception:\n"
      "1. The instruction at PC = " FMT_WORD " is not implemented.\n"
      "2. Something is implemented incorrectly.\n", thispc);
  printf("Find this PC(" FMT_WORD ") in the disassembling result to distinguish which case it is.\n\n", thispc);
  printf(ANSI_FMT("If it is the first case, see\n%s\nfor more details.\n\n"
        "If it is the second case, remember:\n"
        "* The machine is always right!\n"
        "* Every line of untested code is always wrong!\n\n", ANSI_FG_RED), isa_logo);

  set_nemu_state(NEMU_ABORT, thispc, -1);
}

// 读取 CSR 寄存器
word_t csr_read(uint32_t csr_addr) {
  switch (csr_addr) {
    // case 0xc: return cpu.sr.mtvec;
    case 0x305: return cpu.sr.mtvec;   // mtvec 地址 0x305（异常向量表基地址）
    case 0x300:
      printf("Reading mstatus CSR (0x300): 0x%x\n", cpu.sr.mstatus);
      return cpu.sr.mstatus;          // 机器态状态寄存器
    case 0x341: return cpu.sr.mepc;   // mepc 的 CSR 地址为 0x341 保存异常发生时的 PC
    case 0x342: return cpu.sr.mcause; // mcause 的 CSR 地址为 0x342 异常原因码
    case 0x343: return cpu.sr.mtval;  // 异常附加信息
    // 其他 CSR 寄存器...
    default: panic("Unsupported CSR read: 0x%x", csr_addr);
  }
}

// 写入 CSR 寄存器
void csr_write(uint32_t csr_addr, word_t value) {
  switch (csr_addr) {
    // case 0xc: cpu.sr.mtvec = value; break;
    case 0x305: cpu.sr.mtvec = value; break;   // mtvec 地址 0x305（补充常用 CSR）
    case 0x300: cpu.sr.mstatus =value; break;
    case 0x341: cpu.sr.mepc = value; break;
    case 0x342: cpu.sr.mcause = value; break;
    case 0x343: cpu.sr.mtval = value; break;
   
    // 其他 CSR 寄存器...
    default: panic("Unsupported CSR write: 0x%x", csr_addr);
  }
}

  //返回中断现场
word_t do_mret(Decode *s, vaddr_t MEPC){
  // 1. 取出mstatus相关位
  // word_t mstatus = csr_read(MSTATUS);
  word_t mepc   = csr_read(MEPC);
/*   // 2. 修改中断位
  word_t mpie = (mstatus >> 7) & 1;  // 原MPIE（bit7）
   word_t old_mie = (mstatus >> 3) & 1;  // 原MIE（bit3）—— 新增：保存中断前的MIE
  // word_t mpp  = (mstatus >> 11) & 0x3;
  // 3. MIE = MPIE
  if (mpie)
    mstatus |=  (1 << 3);
  else
    mstatus &= ~(1 << 3);

  // 4. 关键修正：MPIE = 原MIE（而非固定为1）
  if (old_mie) {
    mstatus |= (1 << 7);
  } else {
    mstatus &= ~(1 << 7);
  }

  // MPP = 0 (回到 U 模式，如果实现了用户态)
  mstatus &= ~(3 << 11);
  csr_write(MSTATUS, mstatus);

   // 7. 切换特权级为MPP的值
  //  s->priv = mpp; */
  return mepc; // return exception occurred pc address
  }
