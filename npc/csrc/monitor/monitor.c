#include <getopt.h>
#include <stdlib.h>
#include <stdio.h>
#include "../utils/autoconf.h"
#include "../utils/ftrace.h"
#include "../Memory/memory.h"
#include "assert.h"
#include "../../include/cpu/difftest.h"
#include "../cpu/cpu.h"

static char *log_file = NULL;
static char *diff_so_file = NULL;
static char *img_file = NULL;
static int difftest_port = 1234;
static char *file_elf = NULL; // new add elf

void sdb_set_batch_mode();
void init_isa();
void init_device();

// 加载镜像
static long load_img() {
  printf("img_file: %s\n", img_file);
  if (img_file == NULL) {
    // printf("No image is given. Use the default build-in image.\n");
    // return 4096; // built-in image size
    printf("No image is given.\n");
    return 0;
  }
 /*  FILE *fp = fopen(img_file, "rb");
  // Assert(fp, "Can not open '%s'", img_file);
  assert(fp);
  
  fseek(fp, 0, SEEK_END);
  long size = ftell(fp);

  printf("The image is %s, size = %ld\n", img_file, size);

  fseek(fp, 0, SEEK_SET);
  // int ret = fread(guest_to_host(RESET_VECTOR), size, 1, fp);
  int ret = fread(guest_to_host(CONFIG_MBASE), size, 1, fp);
  assert(ret == 1);

  fclose(fp); */
  printf("Loading MROM image: %s\n", img_file);
  long size = load_mrom(img_file);
  assert(size > 0);
  printf("MROM image loaded, size = %ld\n", size);
  return size;
}

// 参数解析
int parse_args(int argc, char *argv[]) {
  const struct option table[] = {
    {"batch"    , no_argument      , NULL, 'b'},
    {"log"      , required_argument, NULL, 'l'},
    {"diff"     , required_argument, NULL, 'd'},
    {"port"     , required_argument, NULL, 'p'},
    {"help"     , no_argument      , NULL, 'h'},
    {"elf"      , required_argument, NULL, 'e'}, // new add
    {0          , 0                , NULL,  0 },
  };
  int o;
  while ( (o = getopt_long(argc, argv, "-bhl:d:p:e:", table, NULL)) != -1) {
    switch (o) {
      case 'b': sdb_set_batch_mode(); break;
      case 'p': sscanf(optarg, "%d", &difftest_port); break;
      case 'l': log_file = optarg; break;
      case 'd': diff_so_file = optarg; break;
      case 'e': file_elf = optarg;  printf("Debug: ELF file set to %s\n", file_elf);  break;  // new add  将用户输入的 ELF 文件路径存入file_elf
      case 1: img_file = optarg; return 0; // make run ARGS="txxx.bin" 处理无选项的参数
      default:
        printf("Usage: %s [OPTION...] IMAGE [args]\n\n", argv[0]);
        printf("\t-b,--batch              run with batch mode\n");
        printf("\t-l,--log=FILE           output log to FILE\n");
        printf("\t-d,--diff=REF_SO        run DiffTest with reference REF_SO\n");
        printf("\t-p,--port=PORT          run DiffTest with port PORT\n");
        printf("\t-e,--file_elf=FILE      elf file to be parsed\n"); //new add
        printf("\n");
        exit(0);
    }
  }
  return 0;
}

void init_monitor(int argc, char *argv[]){

  /*参数解析*/
  parse_args(argc, argv);

  /* Initialize memory. */
  init_mem();

  /* Initialize devices*/
  init_device();

  /* Perform ISA dependent initialization. */
  init_isa();

  /* Initialize elf */
  parse_elf(file_elf);

  /* Load the image to memory. This will overwrite the built-in image. */
  long img_size = load_img();

  /* Initialize differential testing. */
  // difftest_init_nemu();

  /*将镜像同步到REF(nemu) 的内存 需要把镜像文件（image）load到NPC的物理内存区域（或者RESET_VECTOR）中*/ 
  // difftest_memcpy(CONFIG_MBASE, pmem, img_size, DIFFTEST_TO_REF);

  // 检查内存是否一致
  // check_difftest_memcpy(CONFIG_MBASE, pmem, img_size);

  // 执行5个周期的复位
  reset(10);
  
  // 同步仿真寄存器的值
  // update_register(&cpu);

  // 检查寄存器是否一致
  // check_register(&cpu);

  // 将寄存器状态同步到 REF
  // difftest_regcpy(&cpu, DIFFTEST_TO_REF);
 
  // 初始化系统时间
  // init_clock();
}
