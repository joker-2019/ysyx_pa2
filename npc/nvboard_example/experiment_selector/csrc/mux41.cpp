#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vmux41.h"
#include <stdio.h>
#include "nvboard.h"
#include <stdlib.h>

static Vmux41 dut;
void nvboard_bind_all_pins(Vmux41* top);
/*static void single_cycle(){
    dut.eval();
}
*/
int main(int argc, char** argv){
  nvboard_bind_all_pins(&dut);
  nvboard_init();
  while(1){
  nvboard_update();
  //single_cycle();
  dut.eval();
  }
  nvboard_quit();
  return 0;
 }
