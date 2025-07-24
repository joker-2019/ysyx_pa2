#include <stdint.h>

// disassembler.h
#ifdef __cplusplus
extern "C" {
#endif

 extern void init_disasm(const char *triple);

 // 统一的 C 风格函数声明
 extern void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);

#ifdef __cplusplus
}
#endif