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

#include <isa.h>
#include <cpu/difftest.h>
#include "../local-include/reg.h"

//void difftest_regcpy(void *dut, bool direction);

bool isa_difftest_checkregs(CPU_state *ref_r, vaddr_t pc) {
  //CPU_state dut;
  //get ref states copy to the dut
  //difftest_regcpy(&dut, DIFFTEST_TO_DUT);
  //比较通用寄存器
  for (int i = 0; i < ARRLEN(cpu.gpr); i++){
    if(ref_r->gpr[i] != cpu.gpr[i]){
      printf("[DiffTest Error] At PC = 0x%08x: Register x%d mismatch\n", pc, i);
      printf("  REF: 0x%08x\tDUT: 0x%08x\n", ref_r->gpr[i], cpu.gpr[i]);
      return false;
    }
  }
  //比较PC
  if(ref_r->pc != cpu.pc){
    printf("[DiffTest Error] At PC = 0x%08x: PC mismatch\n", pc);
    printf("  REF: 0x%08x\tDUT: 0x%08x\n", ref_r->pc, cpu.pc);
    return false;
  }
  
  
  return true;
}

void isa_difftest_attach() {
}
