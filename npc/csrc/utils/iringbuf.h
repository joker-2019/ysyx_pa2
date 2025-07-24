#ifndef __IRINGBUF_H__
#define __IRINGBUF_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define IRINGBUF_SIZE 64  // 环形缓冲区大小

typedef struct {
    uint32_t pc;             // 指令地址
    uint32_t inst;          // 指令二进制（32位）
    char disasm[64];        // 反汇编字符串
} IRingBufEntry;

// 环形缓冲区变量声明（需要在 .c 文件中定义）
extern IRingBufEntry iringBuf[IRINGBUF_SIZE];
extern int head;
extern int count;

// 添加一条指令
void iringbuf_add(uint32_t pc, uint32_t inst, const char *disasm);

// 打印所有指令并标记错误地址（出错PC）
void printf_inst_error(uint32_t err_pc);

// itrace 执行
void itrace_exec(uint32_t pc, uint32_t inst);

// mtrace
void display_mread(uint32_t addr, int len);

#endif // __IRINGBUF_H__