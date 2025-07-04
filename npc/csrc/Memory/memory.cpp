#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cassert>
#include <stdint.h>

#define MEM_SIZE (1024 * 32)


uint32_t instr_mem[MEM_SIZE] = {
    // 地址 0x80000000（按小端存储）
    0x12300093,  // addi x1, x0, 0x123 000100100011 00000 000 000 01 0010011
    0x45600113,  // addi x2, x0, 0x456
    0x78900193,  // addi x3, x0, 0x789
    0x12345097,  // auipc x1, 0x12345  // x1 = PC + (0x12345 << 12) = 0x80000000 + 0x12345000 = 0x92345000
    0x12345137,  // lui x2, 0x12345  // x2 = 0x12345 << 12 = 0x12345000            
    0x004001EF,  // jal x3, 0x004   // 跳转到PC+4（下条指令）:0x8000000C, 同时x3 = PC+4 = 0x8000000C  1 1101111
    0x00018267,  // jalr x4, x3, 0  // 跳转到x3 + 0 = 0x8000000C，形成跳转环
    0x00100073   // ebreak
}; // 指令内存
uint32_t data_mem[MEM_SIZE];  // 数据内存

//读取指令
extern "C" uint32_t imem_read(int pc) {
   // 检查地址对齐（RISC-V指令必须4字节对齐）
    assert((pc & 0x3) == 0 && "Instruction address misaligned");
    // 将字节地址转换为字地址（右移2位相当于除以4）
    //uint32_t index = pc >> 2;
    int index = (pc - 0x80000000) / 4;  // 从0x80000000开始计算
    printf("index : %d\n",index);
    printf("DEBUG: pc=0x%08x → index=%d → instr=0x%08x\n", 
           pc, index, instr_mem[index]);
    // 检查地址是否越界
    assert(index < MEM_SIZE && "Instruction memory overflow");
    // 直接返回对应位置的32位指令
    return instr_mem[index];
}

// 读取数据
// 注意：RISC-V数据访问通常是按字（4字节）对齐
extern "C" uint32_t dmem_read(int addr) {
     // 检查地址对齐（假设只支持对齐访问）
    assert((addr & 0x3) == 0 && "Data address misaligned");
    // 转换为字地址
    uint32_t word_addr = addr >> 2;
    // 检查地址范围
    assert(word_addr < MEM_SIZE && "Data memory overflow");
     // 将目标字转换为字节数组指针（便于按字节处理）
    uint8_t* byte_ptr = reinterpret_cast<uint8_t*>(&data_mem[word_addr]);

    // 按小端格式组合字节（最低有效字节在低地址）
    return (byte_ptr[3] << 24) |  // 最高字节左移24位
           (byte_ptr[2] << 16) |  // 次高字节左移16位
           (byte_ptr[1] << 8)  |  // 次低字节左移8位
            byte_ptr[0];          // 最低字节不移位
}

// 写入数据
// 注意：RISC-V数据访问通常是按字（4字节）对齐
extern "C" void dmem_write(int addr, int data) {
    // 对齐检查
    assert((addr & 0x3) == 0 && "Data address misaligned");
    // 地址转换
    uint32_t word_addr = addr >> 2;
    // 越界检查
    assert(word_addr < MEM_SIZE && "Data memory overflow");
    // 获取目标字的字节指针
    uint8_t* byte_ptr = reinterpret_cast<uint8_t*>(&data_mem[word_addr]);
    // 按小端格式分解数据到内存
    byte_ptr[0] = (data >> 0)  & 0xFF;  // 最低有效字节
    byte_ptr[1] = (data >> 8)  & 0xFF;  // 次低字节
    byte_ptr[2] = (data >> 16) & 0xFF;  // 次高字节
    byte_ptr[3] = (data >> 24) & 0xFF;  // 最高有效字节
}

/* void load_instructions(const char* file) {
    // 打开文件（二进制只读模式）
    FILE* file = fopen(filename, "rb");
    assert(file != nullptr && "Failed to open instruction file");
    // 计算最大可读取字节数（避免溢出）
    size_t max_bytes = MEM_SIZE * sizeof(uint32_t);
    // 读取整个文件内容到指令存储器
    size_t bytes_read = fread(instr_mem, 1, max_bytes, file);
    
    // 检查是否超出容量（文件大小超过存储器容量时报错）
    assert(bytes_read <= max_bytes && "Instruction file too large");
    
    // 关闭文件
    fclose(file);
} */

