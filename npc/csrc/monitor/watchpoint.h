#ifndef WATCHPOINT_H
#define WATCHPOINT_H

#include <stdint.h>
#include <stdbool.h>

typedef struct watchpoint {
  int NO;
  struct watchpoint *next;

  //TODO: Add more members if necessary
   uint32_t old_value;
   char expr[100];   

} WP; 
WP *new_wp();    //创建新的监视点

void init_wp_pool(); //初始化监视点池

void free_wp(WP *wp); //释放监视点

void display_watchpoint(void); //展示监视点

void wp_watch(char *args, uint32_t res);  //设置监视点

void wp_remove(int no);

bool scan_all_wp(); //扫描所有的监视点

int wp_get_count(); //获取当前监视点数量

#endif // WATCHPOINT_H