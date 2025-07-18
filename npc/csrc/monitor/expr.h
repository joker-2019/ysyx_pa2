#ifndef __EXPR_H
#define __EXPR_H

#include <stdint.h>
#include <stdbool.h>

// 初始化表达式正则（通常在主程序启动时调用一次）
void init_regex(void);

uint32_t expr(char *e);

#endif