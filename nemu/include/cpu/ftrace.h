#ifndef __FTRACE_H__
#define __FTRACE_H__

#include <common.h>
#include <isa.h>
#include <elf.h>

typedef struct {
 Elf32_Sym* symtab;  // 符号表指针（32位ELF）
 int symtab_size; // 符号表项数量
 char* strtab;  // 字符串表指针（符号名存储）
} FTraceELFInfo;

typedef struct {
 FTraceELFInfo elf_info; // ELF符号信息
 int call_depth;         // 当前调用深度
 char indent[64];        // 缩进字符串
 vaddr_t call_stack[16]; // 调用栈（存储每次调用的目标地址）
 int stack_top;          // 栈顶指针（-1表示空栈）
} FTraceContext;

// 初始化追踪模块（解析ELF文件并初始化上下文，新增）
void ftrace_init(const char* elf_path);

// 函数调用追踪（参数改为虚拟地址，新增缩进支持）
void ftrace_func_call(paddr_t pc, paddr_t target);

// 函数返回追踪（参数改为虚拟地址，新增缩进支持）
void ftrace_func_ret(paddr_t pc, paddr_t ret_addr);

// 根据虚拟地址查找函数名（未找到返回"???"，注释明确）
const char* ftrace_find_function_name(FTraceELFInfo* info, vaddr_t addr);

//解析elf文件
bool parse_elf(const char* elf_path, FTraceELFInfo* info);

#endif // __FTRACE_H__