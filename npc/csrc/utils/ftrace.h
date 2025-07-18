#ifndef __FTRACE_H__
#define __FTRACE_H__

#include <elf.h>

struct FuncSym{
 char* name;    // 函数名
 uint32_t addr;       // 函数起始地址
 uint32_t size;       // 函数大小
 struct FuncSym *next; //next指针
};

//检查当前是调用还是返回
void check_call_or_ret(uint32_t pc);

//解析elf文件
void parse_elf(const char* elf_path);

#endif // __FTRACE_H__