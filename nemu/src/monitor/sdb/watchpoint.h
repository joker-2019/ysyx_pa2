#ifndef WATCHPOINT_H
#define WATCHPOINT_H

typedef struct watchpoint {
  int NO;
  struct watchpoint *next;

  //TODO: Add more members if necessary
   word_t old_value;
   char expr[100];   

} WP; 
WP *new_wp();    //创建新的监视点
void free_wp(WP *wp); //释放监视点

void display_watchpoint(void); //展示监视点
void wp_watch(char *args, word_t res);  //设置监视点
void wp_remove(int no);
bool scan_all_wp(); //扫描所有的监视点
 
#endif // WATCHPOINT_H