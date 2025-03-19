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
/*
typedef struct watchpoint {
  int NO;
  struct watchpoint *next;

  //TODO: Add more members if necessary

} WP; */

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


//构建单个监视点
/*
static WP* new_wp() {
  assert(free_);
  WP* ret = free_;
  free_ = free_->next;
  ret->next = head;
  head = ret;
  return ret;
}

//释放监视点
static void free_wp(WP *wp) {
  WP* h = head;
  if (h == wp) head = NULL;
  else {
    while (h && h->next != wp) h = h->next;
    assert(h);
    h->next = wp->next;
  }
  //头插法
  wp->next = free_;
  free_ = wp;
}
*/

void new_wp(char *args){
  if(free_ == NULL)
  {
    panic("The number of watchpoints has been Max = %d\r\n",NR_WP);
  }
 
  WP* new_wp = free_;
  free_ = free_->next;
  new_wp->next = NULL;
  //new_wp->str = args;
  strcpy(new_wp->expr, args);
  bool success = false;
  uint32_t val = expr(new_wp->expr,&success);
  if(success){
    new_wp->val = val;
    printf("Watchpoint %d: %s initial value is Decimal: %lu Hexadecimal: 0x%lx\r\n",new_wp->NO,new_wp->expr,new_wp->val,new_wp->val);

    if(head == NULL){
    head = new_wp;
    }
    else{
      new_wp->next = head; //头插
      head = new_wp;
    }
  }
  else{
    printf("You set the watpoint's expression is invalid\r\n");
    //free_wp(new_wp->NO);
  }
  

}

void free_wp(int n){
  if(head == NULL){
    printf("Current don't have watchpoint can delete\r\n");
    return;
  }
  WP *free_wp = NULL;
  if(head->NO == n){
    free_wp = head;
    head = head->next;
    free_wp->next = NULL;
  }
  else{
    WP * itr = head;
    while (itr->next != NULL)
    {
      if(itr->next->NO == n){
        free_wp = itr->next;
        itr->next = itr->next->next;
        free_wp->next = NULL;
        break;
      }
      itr = itr->next;
    }
    printf("No match the %d watchpoint\n",n);
    return;
  }
  free_wp->next = free_;
  free_ = free_wp; //头插
}


void display_watchpoint(void){
  WP *wp = head;
  if(wp==NULL){
    printf("Current don't have watchpoints\n");
  }
  while(wp != NULL){
    printf("%d watchpoint expression: %s now value is: %lu 0x%lx\n",wp->NO,wp->expr,wp->val,wp->val);
    wp = wp->next;
  }
}
/*
void wp_watch(char *expr, word_t res) {
  WP* wp = new_wp();
  strcpy(wp->expr, expr);
  wp->old = res;
  printf("Watchpoint %d: %s\n", wp->NO, expr);
}

void wp_remove(int no) {
  assert(no < NR_WP);
  WP* wp = &wp_pool[no];
  free_wp(wp);
  printf("Delete watchpoint %d: %s\n", wp->NO, wp->expr);
}
*/

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
