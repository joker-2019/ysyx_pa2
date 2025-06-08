#ifndef __FTRACE_H__
#define __FTRACE_H__

#include <common.h>
#include <isa.h>
#include <elf.h>

struct FuncSym{
 char* name;    // 函数名
 uint32_t addr;       // 函数起始地址
 uint32_t size;       // 函数大小
 struct FuncSym *next; //next指针
};


void check_call_or_ret(uint32_t pc);

/* // 函数调用追踪（参数改为虚拟地址，新增缩进支持）
void ftrace_func_call(uint32_t pc, uint32_t target);

// 函数返回追踪（参数改为虚拟地址，新增缩进支持）
void ftrace_func_ret(uint32_t pc);

// 根据虚拟地址查找函数名（未找到返回"???"，注释明确）
const char* func_name(uint32_t addr); */

//解析elf文件
void parse_elf(const char* elf_path);

#endif // __FTRACE_H__