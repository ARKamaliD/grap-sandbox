#include <stdint.h>
#include  <stdio.h>

uint64_t collatz_orbit(uint64_t n, uint64_t k) {
    return 0; // FIXME!
}

int main(int argc, char **argv) {
    int sum = 0;
    for (int i = 1; i <= 500; i++) {
        sum += i;
    }
    printf("Die  Summe  aller  natürlichen  Zahlen" \
"von 1 bis 100  beträgt %lu.\n", collatz_orbit(0,0));
    return 0;
}
