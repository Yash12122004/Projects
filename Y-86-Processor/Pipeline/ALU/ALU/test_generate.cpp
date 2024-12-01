#include <iostream>
#include <bitset>
#include <cstdint>

int main() {
    int64_t num = -5;
    std::bitset<64> binary(num);
    std::cout << binary << std::endl;
    return 0;
}
