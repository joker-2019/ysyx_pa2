#ifndef __DIFFTEST_H__
#define __DIFFTEST_H__

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

typedef uint32_t paddr_t;
typedef uint32_t word_t;

enum { DIFFTEST_TO_DUT, DIFFTEST_TO_REF };

// 动态链接函数声明
void difftest_memcpy(paddr_t addr, void *buf, size_t n, bool direction);
void difftest_regcpy(void *dut, bool direction);
void difftest_exec(uint64_t n);
void difftest_raise_intr(word_t NO);
void difftest_init_nemu(int difftest_port);

#endif // __DIFFTEST_H__