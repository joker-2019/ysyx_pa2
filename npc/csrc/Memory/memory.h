#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cassert>
#include <stdint.h>


uint32_t imem_read(int pc);

uint32_t dmem_read(int addr);

void dmem_write(int addr, int data);

//void load_instructions(const char* file);
