#include <cpu/ftrace.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

// 全局追踪上下文（静态变量，仅本文件可见）
static FTraceContext ftrace_ctx = {0};

// 初始化追踪模块（解析ELF并设置上下文）
void ftrace_init(const char* elf_path) {
    // 初始化ELF符号表信息
    memset(&ftrace_ctx.elf_info, 0, sizeof(FTraceELFInfo));

    // 解析ELF文件获取符号表和字符串表
    if (!parse_elf(elf_path, &ftrace_ctx.elf_info)) {
        fprintf(stderr, "ftrace: failed to parse ELF file\n");
        return;
    }
    // 初始化调用深度和缩进字符串（每层4空格，最大16层）
    ftrace_ctx.call_depth = 0;
    for (int i = 0; i < 16; i++) {
        for (int j = 0; j < i * 4; j++) {
            ftrace_ctx.indent[j] = ' ';
        }
        ftrace_ctx.indent[i * 4] = '\0'; // 终止符
    }
    // 初始化调用栈（最大16层）
    ftrace_ctx.stack_top = -1;
    memset(ftrace_ctx.call_stack, 0, sizeof(ftrace_ctx.call_stack));
}

// 函数调用追踪（带缩进）
void ftrace_func_call(paddr_t pc, paddr_t target) {
    // 边界检查：符号表未初始化或调用深度超过限制
    if (!ftrace_ctx.elf_info.symtab || !ftrace_ctx.elf_info.strtab){
        return;
    }
    // 压栈：保存目标地址（即被调用函数的入口地址）
    if (ftrace_ctx.stack_top < 16) {
    ftrace_ctx.stack_top++;
    ftrace_ctx.call_stack[ftrace_ctx.stack_top] = target;
    }

    // 获取函数名（允许虚拟地址与物理地址转换，假设pc/target为虚拟地址）
    //onst char* curr_func = ftrace_find_function_name(&ftrace_ctx.elf_info, called_func_addr);
    // 获取函数名（当前函数和返回目标函数）
    const char* target_func = ftrace_find_function_name(&ftrace_ctx.elf_info, target);
    printf("%s0x%08x: call [%s@0x%08x]\n", ftrace_ctx.indent, pc, target_func, target);
 
    ftrace_ctx.call_depth++; // 深度同步增加
}

// 函数返回追踪（带缩进）
void ftrace_func_ret(paddr_t pc, paddr_t ret_addr) {
    // 边界检查：符号表未初始化或调用深度为0（无调用栈）
    if (!ftrace_ctx.elf_info.symtab || !ftrace_ctx.elf_info.strtab) {
        return;
    }
     // 弹栈：获取调用时保存的目标地址（即当前函数的入口地址）
    vaddr_t called_func_addr = (ftrace_ctx.stack_top >= 0) ? 
    ftrace_ctx.call_stack[ftrace_ctx.stack_top] : 0;
    ftrace_ctx.stack_top--;
    // 获取函数名：当前返回函数（pc）和返回目标函数（ret_addr）
    const char* curr_func = ftrace_find_function_name(&ftrace_ctx.elf_info, called_func_addr);
    const char* ret_func = ftrace_find_function_name(&ftrace_ctx.elf_info, ret_addr);

    // 生成追踪输出（格式匹配示例：缩进 + ret [函数名]）
    printf("%s0x%08x:   ret  [%s] --> [%s]\n",
           ftrace_ctx.indent, pc, curr_func, ret_func);

    // 调用深度减少（返回上层调用）
    ftrace_ctx.call_depth--;
}

// 根据虚拟地址查找函数名（核心符号查找逻辑）
const char* ftrace_find_function_name(FTraceELFInfo* info, vaddr_t addr) {
    if (!info->symtab || !info->strtab) return "???"; // 未初始化时返回默认值

    for (int i = 0; i < info->symtab_size; i++) {
        Elf32_Sym* sym = &info->symtab[i];
        // 符号类型为函数（STT_FUNC）且地址在符号范围内
        if ((sym->st_info & 0x0F) == STT_FUNC) {
            vaddr_t start = sym->st_value;
            vaddr_t end = start + sym->st_size;
            if (addr >= start && addr < end) {
                return &info->strtab[sym->st_name]; // 返回符号名
            }
        }
    }
    return "???"; // 未找到匹配符号
}
    
    //解析elf文件
bool parse_elf(const char* elf_path, FTraceELFInfo* info) {
    memset(info, 0, sizeof(FTraceELFInfo)); // 初始化指针为NULL
    FILE* fp = fopen(elf_path, "rb");
    if (!fp) { perror("ftrace: failed to open ELF file"); return false; }
 
    Elf32_Ehdr ehdr;
    if (fread(&ehdr, 1, sizeof(ehdr), fp) != sizeof(ehdr)) {
        fclose(fp);
        return false;
    }
 
    if (memcmp(ehdr.e_ident, ELFMAG, 4) != 0) {
        fprintf(stderr, "ftrace: not a valid ELF file\n");
        fclose(fp);
        return false;
    }
 
    // 遍历段头，分别查找符号表和字符串表（仅处理一次）
    for (int i = 0; i < ehdr.e_shnum; i++) {
        Elf32_Shdr shdr;
        fseek(fp, ehdr.e_shoff + i * ehdr.e_shentsize, SEEK_SET);
        if (fread(&shdr, 1, sizeof(shdr), fp) != sizeof(shdr)) { continue; }
 
        // 处理符号表段（仅当未找到时处理）
        if(shdr.sh_type == SHT_SYMTAB && !info->symtab) {
            info->symtab = malloc(shdr.sh_size);
            if (!info->symtab) {
                free(info->strtab); // 释放已分配的字符串表
                fclose(fp);
                return false;
            }
            fseek(fp, shdr.sh_offset, SEEK_SET);

            if(fread(info->symtab, 1, shdr.sh_size, fp) != shdr.sh_size) {
            free(info->symtab);
            info->symtab = NULL;
            }
            info->symtab_size = shdr.sh_size / shdr.sh_entsize; // 使用sh_entsize计算
            }
            // 处理字符串表段（仅当未找到时处理）
            else if (shdr.sh_type == SHT_STRTAB && !info->strtab) {
                info->strtab = malloc(shdr.sh_size);
                if (!info->strtab) {
                    free(info->symtab); // 释放已分配的符号表
                    fclose(fp);
                    return false;
                }
            fseek(fp, shdr.sh_offset, SEEK_SET);
                if(fread(info->strtab, 1, shdr.sh_size, fp) != shdr.sh_size) {
                    free(info->strtab);
                    info->strtab = NULL;
                }
            }
        // 找到两个表后提前退出（优化）
        if(info->symtab && info->strtab){break;}
    }
    fclose(fp);
    return info->symtab && info->strtab; // 仅当两者都有效时返回成功
}

