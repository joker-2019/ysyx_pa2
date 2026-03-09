#include "verilated.h"
#include "verilated_vcd_c.h"
// #include "Vysyx_22040080_cpu.h"
// #include "Vysyx_22040080_cpu___024root.h"
// #include "VysyxSoCFull.h"
// #include "VysyxSoCFull___024root.h"

void sdb_mainloop(int, char *[]);

int main(int argc, char *argv[]) {
// 解决运行时plusargs功能报错的问题
Verilated::commandArgs(argc, argv);
sdb_mainloop(argc, argv);
return 0;
}

