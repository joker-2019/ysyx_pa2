#include <am.h>
#include <riscv/riscv.h>
#include <klib.h>

static Context* (*user_handler)(Event, Context*) = NULL;
#define CONTEXT_SIZE ((32 + 3 + 1) * sizeof(uintptr_t))
Context* __am_irq_handle(Context *c) {
  if (user_handler)
  {
    Event ev = {0};
    switch (c->mcause) {
      case 11:
        // printf("c->mcause: %d\n", c->mcause);
        ev.event = EVENT_YIELD;
        // printf("entry c->mepc: %0x\n", c->mepc);
        // printf("args c->gpr[10]: %d\n", c->gpr[10]);
        // printf("size c.size: %d\n", sizeof(c));
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
  // printf("cte_init booting!\n");
  // initialize exception entry
  asm volatile("csrw mtvec, %0" : : "r"(__am_asm_trap));
  
  // register event handler
  user_handler = handler;

  return true;
}

Context *kcontext(Area kstack, void (*entry)(void *), void *arg) {
  // printf("Context boosting!\n"); 
  // printf("Context Size: %d\n", CONTEXT_SIZE);
  if (kstack.end - kstack.start < CONTEXT_SIZE) {
    // 使用%u打印无符号整数，避免地址计算的符号问题
    printf("Stack too small! Need %u bytes, got %u bytes\n", 
           (unsigned int)CONTEXT_SIZE, 
           (unsigned int)(kstack.end - kstack.start));
    // 添加更详细的调试信息，帮助定位问题
    printf("Stack range: [0x%08x, 0x%08x]\n",
           (unsigned int)kstack.start,
           (unsigned int)kstack.end);
    assert(0);
  }
  Context *ctx = (Context *)(kstack.end - CONTEXT_SIZE); //定义上下文结构体的大小
  ctx->mstatus = 0x1800;
  ctx->mepc = (uintptr_t)entry; // 异常入口地址
  // printf("ctx->mepc : %0x\n", ctx->mepc);
  ctx->gpr[10] = (uintptr_t)arg; // a0寄存器（x10）用于传递函数参数arg（符合RISC-V调用约定）
  // printf("ctx->gpr[10] : %0x\n", ctx->gpr[10]);
  ctx->gpr[2] = (uintptr_t)ctx;//sp 在汇编代码中被单独定义  addi sp, sp, -CONTEXT_SIZE  ; 将栈指针向下移动，预留保存上下文的空间
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
