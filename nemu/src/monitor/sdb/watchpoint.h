#ifndef WATCHPOINT_H
#define WATCHPOINT_H
 
typedef struct watchpoint {
    // 定义 watchpoint 结构体
  int NO;
  struct watchpoint *next;
  char expr[100];
  unsigned long val;
  /* TODO: Add more members if necessary */
} WP;
 
void display_watchpoint(void);
//void wp_watch(char *args, word_t res);
//void wp_remove(int no);
void new_wp(char *args);
void free_wp(int n);
 
#endif // WATCHPOINT_H