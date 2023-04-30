#include <stdio.h>
#include <stdint.h>

int check_isbn10(uint64_t isbn10) {
    // FIXED
    uint64_t parity = isbn10 % 11;
    isbn10 /= 11;
    uint64_t temp = 0;

    for (int i = 2; i <= 10; ++i) {
        uint64_t last_dig = isbn10 % 10;
        isbn10 /= 10;
        temp += i * last_dig;
    }
    if (isbn10 != 0) return 0;

    return ((temp + parity) % 11) == 0;
}

int main(void) {
    uint64_t input = 24621778031;
    int result = check_isbn10(input);
    printf("result  =   %d\n", result);
    return 0;
}
