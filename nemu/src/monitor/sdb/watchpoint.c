/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include "sdb.h"
#include "watchpoint.h"

#define NR_WP 32

static WP wp_pool[NR_WP] = {};
static WP *head = NULL, *free_ = NULL;


//初始化监视池
void init_wp_pool() {
  int i;
  for (i = 0; i < NR_WP; i ++) {
    wp_pool[i].NO = i;
    wp_pool[i].next = (i == NR_WP - 1 ? NULL : &wp_pool[i + 1]);
  }

  head = NULL;
  free_ = wp_pool;
  
}

/* TODO: Implement the functionality of watchpoint */
//打印监视点
void display_watchpoint(void){
  WP *wp = head;
  if(wp==NULL){
    printf("Current don't have watchpoints\n");
    return;
  }
  while(wp != NULL){
    printf("%d watchpoint expression: %s now value is: %u \n",wp->NO,wp->expr,wp->old_value);
    wp = wp->next;
  }
}

//新建监视点
 WP *new_wp(){
  //若free_中无空闲的监视点，则无法创建新的监视点
  if(free_ == NULL){
    printf("Failed to create a monitor. No monitor is available\n"); //表示无空闲的监视点
    assert(0);
  }
  else{
  WP * new_wp_temp = free_;  //新建节点指向空闲节点
  free_ = free_->next;  //空闲节点-1

  new_wp_temp->next = head;  //新建节点指向组织监视节点的head
  head = new_wp_temp;        //将头节点前移，头插法
  return head;
  }
}

//删除监视点
void free_wp(WP *wp){

  if(wp ==NULL){
    printf("No watchpoints are using\n");
    assert(0);
  }
  WP *wp_free = NULL;

  if(head == wp){  //存在组织监视点的头监视点，就是要删除的监视点
    wp_free = head;
    head = wp_free->next;   //删除组织监视点的头节点

    wp_free->next = free_;
    free_ = wp_free;      //将释放节点加入空闲节点
  }
  else{
    WP *temp = head;
    while (temp && temp->next!= wp) //在组织监视点寻找要删除的监视点
    {
      temp = temp->next;
    }
    temp->next = wp->next;  //找到要删除的节点，将要删除的next节点交给temp的next节点
    wp->next = free_;       //将要删除的节点指向free
    free_ = wp;             //free指向头      头插法
    
  }
  
}

//设置监视点
void wp_watch(char *expr, word_t res) {
  WP* wp = new_wp();
  wp->old_value = res;
  strcpy(wp->expr, expr);
  printf("Watchpoint %d: %s\n", wp->NO, expr);
}

//删除监视点
void wp_remove(int no) {
  WP *wp_delete = head;
  while (wp_delete && wp_delete->NO != no)
  {
    wp_delete = wp_delete->next;
  }

  if(wp_delete == NULL){
    printf("The watchpoint does't exist.\n");
    return;
  }
  free_wp(wp_delete); 
  printf("Deleted success\n"); 
}

//扫描所有的监视点，当发现表达式的值发生改变，更显表达式的值并让系统进入暂停状态
bool scan_all_wp(){
  WP *temp = head;
  bool flag = false; //当值发生变化时，触发暂停

  while (temp)
  {
    bool success;
    word_t new_value = expr(temp->expr,&success);
    //printf("new_value = 0x%08x\n", new_value);  // 32位补零显示，带0x前缀
    if(temp->old_value != new_value){
      printf("%d watchpoint expression has changed: %s\n",temp->NO, temp->expr);
      printf("%d old_value is 0x%08x\n",temp->NO, temp->old_value);
      printf("%d new_value is 0x%08x\n",temp->NO, new_value);
      temp->old_value = new_value;
      flag = true; 
      // nemu_state.state = NEMU_STOP;
      // return flag;
    }else{
      temp = temp->next;
    }
  }
  return flag;
}

//新建监视点
 WP *new_wp(){
  //若free_中无空闲的监视点，则无法创建新的监视点
  if(free_ == NULL){
    printf("Failed to create a monitor. No monitor is available\n"); //表示无空闲的监视点
    assert(0);
  }
  else{
  WP * new_wp_temp = free_;  //新建节点指向空闲节点
  free_ = free_->next;  //空闲节点-1

  new_wp_temp->next = head;  //新建节点指向组织监视节点的head
  head = new_wp_temp;        //将头节点前移，头插法
  return head;
  }
}

//删除监视点
void free_wp(WP *wp){

  if(wp ==NULL){
    printf("No watchpoints are using\n");
    assert(0);
  }
  WP *wp_free = NULL;

  if(head == wp){  //存在组织监视点的头监视点，就是要删除的监视点
    wp_free = head;
    head = wp_free->next;   //删除组织监视点的头节点

    wp_free->next = free_;
    free_ = wp_free;      //将释放节点加入空闲节点
  }
  else{
    WP *temp = head;
    while (temp && temp->next!= wp) //在组织监视点寻找要删除的监视点
    {
      temp = temp->next;
    }
    temp->next = wp->next;  //找到要删除的节点，将要删除的next节点交给temp的next节点
    wp->next = free_;       //将要删除的节点指向free
    free_ = wp;             //free指向头      头插法
    
  }
  
}

//设置监视点
void wp_watch(char *expr, word_t res) {
  WP* wp = new_wp();
  wp->old_value = res;
  strcpy(wp->expr, expr);
  printf("Watchpoint %d: %s\n", wp->NO, expr);
}

//删除监视点
void wp_remove(int no) {
  WP *wp_delete = head;
  while (wp_delete && wp_delete->NO != no)
  {
    wp_delete = wp_delete->next;
  }

  if(wp_delete == NULL){
    printf("The watchpoint does't exist.\n");
    return;
  }
  free_wp(wp_delete); 
  printf("Deleted success\n"); 
}

//扫描所有的监视点，当发现表达式的值发生改变，更显表达式的值并让系统进入暂停状态
bool scan_all_wp(){
  WP *temp = head;
  bool flag = false; //当值发生变化时，触发暂停

  while (temp)
  {
    bool success;
    word_t new_value = expr(temp->expr,&success);
    //printf("new_value = 0x%08x\n", new_value);  // 32位补零显示，带0x前缀
    if(temp->old_value != new_value){
      printf("%d watchpoint expression has changed: %s\n",temp->NO, temp->expr);
      printf("%d old_value is 0x%08x\n",temp->NO, temp->old_value);
      printf("%d new_value is 0x%08x\n",temp->NO, new_value);
      temp->old_value = new_value;
      flag = true; 
      // nemu_state.state = NEMU_STOP;
      // return flag;
    }else{
      temp = temp->next;
    }
  }
  return flag;
}

/*
void wp_difftest() {
  WP* h = head;
  while (h) {
    bool _;
    word_t new = expr(h->expr, &_);
    if (h->val != new) {
      printf("Watchpoint %d: %s\n"
        "Old value = %lu\n"
        "New value = %u\n"
        , h->NO, h->expr, h->val, new);
      h->val = new;
    }
    h = h->next;
  }
}
*/
