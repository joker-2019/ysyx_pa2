#ifndef __IRINGBUF_H__
#define __IRINGBUF_H__

#include <common.h>
#include <isa.h>

#define IRINGBUF_SIZE 64  // 环形缓冲区大小

typedef struct {
    vaddr_t pc;             // 指令地址
    uint32_t inst;          // 指令二进制（32位）
    char disasm[64];        // 反汇编字符串
} IRingBufEntry;

// 环形缓冲区变量声明（需要在 .c 文件中定义）
extern IRingBufEntry iringBuf[IRINGBUF_SIZE];
extern int head;
extern int count;

// 添加一条指令
void iringbuf_add(vaddr_t pc, uint32_t inst, const char *disasm);

// 打印所有指令并标记错误地址（出错PC）
void printf_inst_error(vaddr_t err_pc);

// 对访存的结果进行追踪
void display_mread(paddr_t addr, int len);

void display_mwrite(paddr_t addr, int len, word_t data);

#endif // __IRINGBUF_H__