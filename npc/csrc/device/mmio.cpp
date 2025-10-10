#include "mmio.h"

static std::vector<IOMap> mmio_maps;

// 添加mmio映射
void add_mmio_map(const char *name, uint32_t addr, uint32_t len, uint8_t *space, io_callback_t callback) {
    for (auto &m : mmio_maps) {
        if (!(addr + len - 1 < m.low || addr > m.high)) {
            fprintf(stderr, "[MMIO ERROR] Overlap between %s and %s\n",
                    name, m.name.c_str());
            assert(0);
        }
    }
    IOMap map;
    map.name = name;
    map.low = addr;
    map.high = addr + len - 1;
    map.space = space;
    map.callback = callback;
    mmio_maps.push_back(map);

    printf("[MMIO] Add device '%s' mapped at [0x%08x, 0x%08x]\n",
           name, map.low, map.high);
}

IOMap* fetch_mmio_map(uint32_t addr) {
    for (auto &m : mmio_maps) {
        if (addr >= m.low && addr <= m.high){
            printf("[MMIO HIT] addr=0x%08x -> %s [0x%08x,0x%08x]\n", addr, m.name.c_str(), m.low, m.high);
            fflush(stdout);
            return &m;
        }
    }
    return nullptr;
}