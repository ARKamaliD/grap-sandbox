#include <stdio.h>
#include <stdint.h>

uint64_t collatz_orbit(uint64_t n, uint64_t k) {
    uint64_t i;
    for (i = 0; i < k; ++i) {
//        printf("k=  %lu    ,   n= %lu\n", i, n);
        if (n % 2 == 0) {
            n = n / 2;
        } else {
            if (n > (UINT64_MAX - 1) / 3) return 0;
            else n = 3 * n + 1;
        }
        if (i + 1 < k && n == 1)
            break;
    }
    if (i + 1 < k) {
        switch ((k - (i + 1)) % 3) {
            case 0:
                return 1;
            case 1:
                return 4;
            case 2:
                return 2;
        }
    }
    return n; // FIXED!
}

int main(void) {
    uint64_t n = 9223372036854775808U;
    uint64_t k = 9223372036854775808U;
    printf("k=  %lu    ,   result= %lu\n", k, collatz_orbit(n, k));
    return 0;
}
