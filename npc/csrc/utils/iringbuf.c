#include "iringbuf.h"
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include "disasm.h"
#include <stdbool.h>

void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);

IRingBufEntry iringBuf[IRINGBUF_SIZE];
int head = 0; //队列头
int count = 0; //指令总数

// 添加指令到环形缓冲区
void iringbuf_add(uint32_t pc, uint32_t inst, const char *disasm) {
    int idx = head;
    iringBuf[idx].pc = pc;
    iringBuf[idx].inst = inst;
    strncpy(iringBuf[idx].disasm, disasm, sizeof(iringBuf[idx].disasm) - 1);
    
    head = (idx + 1) % IRINGBUF_SIZE;
    count = (count < IRINGBUF_SIZE) ? count + 1 : IRINGBUF_SIZE;
}


// 输出所有指令，错误指令会被标记
void printf_inst_error(uint32_t err_pc) {
    if (!count) return;  // 队列为空
    
    printf("===== Instruction Ring Buffer (最近 %d 条指令) =====\n", count);
    
    // 从最新的指令开始输出
    for (int i = 0; i <count; i++) {
     int idx = (head + IRINGBUF_SIZE - count + i) % IRINGBUF_SIZE ;//(循环打印的下标位置  头+缓冲区大小-总共指令数+当前打印指令)%缓冲区大小 = 当前打印的位置
     bool is_error = (iringBuf[idx].pc == err_pc);
     if(is_error){
        printf("-->%08x: %08x  %s\n", iringBuf[idx].pc, iringBuf[idx].inst, iringBuf[idx].disasm);
     }else{
        printf("%08x: %08x  %s\n", iringBuf[idx].pc, iringBuf[idx].inst, iringBuf[idx].disasm);
     }
    }
    printf("=============================================\n");

}

/* //MTRACE 对访存的结果进行追踪
void display_mread(paddr_t addr, int len) {
    printf("MTRACE: READ  addr = 0x%08x, len = %d\n", addr, len);
    //TODO 若想将访问结果进行存取，可以采用写如日志的方式实现Log("MTRACE: READ  addr = 0x%08x, len = %d, addr, len)
}
  
void display_mwrite(paddr_t addr, int len, word_t data) {
    printf("MTRACE: WRITE addr = 0x%08x, len = %d, data = 0x%08x\n", addr, len, data);
} */

void itrace_exec(uint32_t pc, uint32_t inst){
    char asm_buf[128] = {};
    disassemble(asm_buf, sizeof(asm_buf), pc, (uint8_t *)&inst, 4);
    iringbuf_add(pc, inst, asm_buf);

    printf("itrace: pc:0x%08x:   inst:0x%08x   %s\n", pc, inst, asm_buf);
}

//MTRACE 对访存的结果进行追踪
void display_mread(uint32_t addr, int len) {
    printf("MTRACE: READ  addr = 0x%08x, len = %d\n", addr, len);
    //TODO 若想将访问结果进行存取，可以采用写如日志的方式实现Log("MTRACE: READ  addr = 0x%08x, len = %d, addr, len)
}
  
void display_mwrite(uint32_t addr, int len, uint32_t data) {
    printf("MTRACE: WRITE addr = 0x%08x, len = %d, data = 0x%08x\n", addr, len, data);
}