#include <cpu/ftrace.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdint.h> // 包含Elf32_Word定义
#include <elf.h>


static int call_depth; //调用深度
static char *current_func; //用于记录当前函数
struct FuncSym *elf_head; //函数链表头

    //解析elf文件
void parse_elf(const char* elf_path) {
     FILE *fp = fopen(elf_path, "rb");
     assert(fp != NULL);
    // 读取 ELF 头
    Elf32_Ehdr ehdr; // ELF header
    assert(fread(&ehdr, 1, sizeof(ehdr), fp) == sizeof(ehdr));

    // 分配内存并读取所有节头（section headers）
    // 节头表描述了文件中每个节的信息
    Elf32_Shdr *shdrs = malloc(sizeof(Elf32_Shdr) * ehdr.e_shnum); // Section headers
    fseek(fp, ehdr.e_shoff, SEEK_SET);  // 定位到节头表在文件中的位置
    //fread(shdrs, ehdr.e_shnum, sizeof(Elf32_Shdr), fp); // 读取整个节头表
    assert(fread(shdrs, sizeof(Elf32_Shdr), ehdr.e_shnum, fp) == ehdr.e_shnum); // fread(buf, size, count, fp)  size为读取的大小, count为个数


    // 用于存储找到的符号表和字符串表
    Elf32_Shdr *symtab_hdr = NULL;  // 符号表节头
    Elf32_Shdr *strtab_hdr = NULL;  // 关联的字符串表节头
    
    //
    for (int i = 0; i < ehdr.e_shnum; i++) {
        if (shdrs[i].sh_type == SHT_SYMTAB) {
            symtab_hdr = &shdrs[i];
            strtab_hdr = &shdrs[symtab_hdr->sh_link];
            break;
        }
    }

    assert(symtab_hdr && strtab_hdr);

    // 读取字符串表
    char *strtab = malloc(strtab_hdr->sh_size);
    fseek(fp, strtab_hdr->sh_offset, SEEK_SET);
    assert(fread(strtab, 1, strtab_hdr->sh_size, fp) == strtab_hdr->sh_size);

    // 读取符号表
    //int sym_count = symtab_hdr->sh_size / symtab_hdr->sh_entsize;
    Elf32_Sym *symtab = malloc(symtab_hdr->sh_size);
    fseek(fp, symtab_hdr->sh_offset, SEEK_SET);
    assert(fread(symtab, 1, symtab_hdr->sh_size, fp) == symtab_hdr->sh_size);

    // 计算符号数量
    int sym_count = symtab_hdr->sh_size / symtab_hdr->sh_entsize;

    // 遍历符号表，提取函数信息并构建链表
    for (int i = 0; i < sym_count; i++) {
        Elf32_Sym *sym = &symtab[i];
        if (ELF32_ST_TYPE(sym->st_info) == STT_FUNC &&sym->st_value >= 0x80000000 &&sym->st_size > 0) {
            struct FuncSym *node = malloc(sizeof(struct FuncSym));
            node->name = strdup(strtab + sym->st_name);
            node->addr = (uint32_t)sym->st_value;
            node->size = (uint32_t)sym->st_size;
            node->next = elf_head;
            elf_head = node;
        }
    }

    // 清理
    free(symtab);
    free(strtab);
    free(shdrs);
    fclose(fp);
}

void check_call_or_ret(uint32_t pc) {
    for (struct FuncSym *temp = elf_head; temp != NULL; temp = temp->next){
        if(pc >= temp->addr && pc < temp->addr + temp->size){
            if(current_func == NULL){ //init
                current_func = temp->name;
            }else if(current_func == temp->name){ //在函数内部
            }else {
                 current_func = temp->name;
                 printf("0x%08x", pc);
                 if (pc == temp->addr){ // 跳转新的函数
                     // TODO call
                     for (int i = 0; i < call_depth; ++i){
                         printf(" ");
                     }
                     printf("call [%s@0x%08x]\n", temp->name, temp->addr);
                     ++call_depth;
                 }
                 else{
                     // TODO  ret
                     --call_depth;
                     for (int i = 0; i < call_depth; ++i)
                     {
                         printf(" ");
                     }
                     printf("call [%s@0x%08x]\n", temp->name, temp->addr);
                 }
            }
            break;

        }  
    }
}

