#include <stdio.h>
#include <limits.h>

void test(int, int);

int gcd(int a, int b);

int main(int argc, char **argv) {
    test(12, 4);
    test(6, 4);
    test(1, 1);
    test(-6, 4);
    test(6, -4);
    test(-6, -4);
    test(-2, -2);
    test(-2, 2);
    test(INT_MIN, 2);
    test(INT_MAX, 7);
    return 0;
}

void test(int a, int b) {
    int gcd_r = gcd(a, b);
    int mod_a = a % gcd_r;
    int mod_b = b % gcd_r;
    printf("%s gcd(%d,%d) = %d, mod_a = %d, mod_b = %d\n",
           mod_a || mod_b ? "INCORRECT" : "correct",
           a, b, gcd_r, mod_a, mod_b);
}

int gcd(int a, int b) {
//    if (a < 0 || b < 0) return -1;
    if (a == b)
        return a;
    if (a > b)
        return gcd(a - b, b);
    else
        return gcd(a, b - a);
}
