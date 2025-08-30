#include <am.h>
#include <riscv/riscv.h>
#include <klib.h>

static Context* (*user_handler)(Event, Context*) = NULL;
#define CONTEXT_SIZE ((32 + 3) * 4)
Context* __am_irq_handle(Context *c) {
  printf("c->mcause: %d\n", c->mcause);
  if (user_handler)
  {
    Event ev = {0};
    switch (c->mcause) {
      case 11:
        printf("c->mcause: %d", c->mcause);
        ev.event = EVENT_YIELD;
         printf("c->mepc: %x", c->mepc);
        c->mepc += 4;
        break;
      default:
        ev.event = EVENT_ERROR;
        break;
      }

    c = user_handler(ev, c);
    assert(c != NULL);
  }

  return c;
}

extern void __am_asm_trap(void);

bool cte_init(Context*(*handler)(Event, Context*)) {
  printf("cte_init booting!\n");
  // initialize exception entry
  asm volatile("csrw mtvec, %0" : : "r"(__am_asm_trap));
  
  // register event handler
  user_handler = handler;

  return true;
}

Context *kcontext(Area kstack, void (*entry)(void *), void *arg) {
  return NULL;
  printf("Context boosting!\n");
  printf("Context Size: %d\n", CONTEXT_SIZE);
  Context *ctx = (Context *)(kstack.end - CONTEXT_SIZE);
  ctx->mepc = (uintptr_t)entry; // 异常入口地址
  printf("ctx->mepc : %0x\n", ctx->mepc);
  ctx->gpr[10] = (uintptr_t)arg; // a0寄存器（x10）用于传递函数参数arg（符合RISC-V调用约定）
  printf("ctx->gpr[10] : %0x\n", ctx->gpr[10]);
  ctx->gpr[2] = (uintptr_t)ctx; //sp 在汇编代码中被单独定义  addi sp, sp, -CONTEXT_SIZE  ; 将栈指针向下移动，预留保存上下文的空间

  return ctx;
}

void yield() {
#ifdef __riscv_e
  asm volatile("li a5, -1; ecall");
#else
  asm volatile("li a7, -1; ecall");
#endif
}

bool ienabled() {
  return false;
}

void iset(bool enable) {
}
