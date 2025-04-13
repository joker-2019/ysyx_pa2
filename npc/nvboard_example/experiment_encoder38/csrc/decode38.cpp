#include "verilated.h"
#include "Vdecode38.h"
#include <stdio.h>
#include "nvboard.h"
#include <stdlib.h>

static Vdecode38 dut;
void nvboard_bind_all_pins(Vdecode38* top);


int main() {
  nvboard_bind_all_pins(&dut);
  nvboard_init();
   
  while(1){
   nvboard_update();
   dut.eval();
   }

  nvboard_quit();
  return 0;
}
