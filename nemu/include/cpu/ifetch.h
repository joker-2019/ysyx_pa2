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

#ifndef __CPU_IFETCH_H__

#include <memory/vaddr.h>

static inline uint32_t inst_fetch(vaddr_t *pc, int len) {
  /* uint32_t inst = vaddr_ifetch(*pc, len);
  (*pc) += len;
  return inst; */
  uint32_t inst = vaddr_ifetch(*pc, 2);   // 至少取 16 位
  uint32_t deinst = 0;

  if ((inst & 0x3) != 0x3) {
    // -------- 压缩指令 (16-bit) --------
    uint16_t cinst = inst & 0xffff;

    switch ((cinst >> 13) & 0x7) {   // funct3[15:13]
      case 0x6: { // c.sw
        // imm[5:2|7:6] from instruction
        uint32_t imm = ((cinst >> 7) & 0x38) |       // bits [5:2]
                       ((cinst >> 10) & 0x7) << 6;   // bits [7:6]

        // rs1'/rs2' are "compressed regs" (x8–x15)
        uint32_t rs1 = 8 + ((cinst >> 7) & 0x7);
        uint32_t rs2 = 8 + ((cinst >> 2) & 0x7);

        // sw rs2, imm(rs1)
        deinst = ((imm & 0xfe0) << 20) |   // imm[11:5] -> [31:25]
                 (rs2 << 20) |             // rs2 -> [24:20]
                 (rs1 << 15) |             // rs1 -> [19:15]
                 (0x2 << 12) |             // funct3 = 010
                 ((imm & 0x1f) << 7) |     // imm[4:0] -> [11:7]
                 (0x23);                   // opcode = 0100011
        break;
      }
      default:
        panic("Unsupported compressed instruction: %04x at pc=0x%08x", cinst, *pc);
    }

    (*pc) += 2;   // 压缩指令长度 2 字节
    return deinst;
  }
  else {
    // -------- 普通 32 位指令 --------
    inst = vaddr_ifetch(*pc, 4);
    (*pc) += len;
    return inst;
  }
}

#endif
