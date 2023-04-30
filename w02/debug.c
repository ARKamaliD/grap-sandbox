#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void gen_factors(int* factors, int len) {
    int a = 0;
    int b = 1;
    for(int i = 0; i < len; i++) {
        factors[i] = b;

        int c = a + b;
        a = b;
        b = c;
    }
}

int fun1(int x, int y) {
    return x % y;
}

int fun2(int n, int* factors, int factors_len) {
    int sum = 0;
    for(int i = 0; i <= n; i++) {
        sum += factors[i % factors_len] * i;
    }
    return sum;
}

int main(int argc, char** argv) {
    int* factors = malloc(sizeof(*factors) * 8);
    gen_factors(factors, 8);

    int n = (argc == 0) ? 0 : (argc - 1);
    int len = strlen(argv[n]);
    int magic_number = 42;
    int answer = fun1(len, magic_number);
    printf("The answer is: %i\n", answer);

    int m = answer * len;
    int result = fun2(m, factors, 8);
    printf("The  result is: %i\n", result);

    free(factors);

    return 0;
}
