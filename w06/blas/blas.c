
#include <stdio.h>
#include <stdlib.h>
// immintrin.h provides SIMD intrinsics
#include <immintrin.h>

//#include "saxpy.h"

// Just some sample data, we don't have time to implement
// something more fancy... ;)
#define ARR_LENGTH 12
float x[ARR_LENGTH] = {1, 4, 2.3, 4.5, 18.2, 2, 0, -1.2, 2, 6, -2.4, 4.3};
float y[ARR_LENGTH] = {2, 3.4, 1, 5, 1.2, 13.2, 3.3, 12, -1.1, 3.3, 2, 0};

// Helper function to print a float array.
static void print_array(long n, float *array) {
    for (long i = 0; i < n && i < 12; i++) printf(" %.3f", array[i]);
    if (n > 12) printf(" ...");
    printf("\n");
}

float sdot(size_t n, const float x[n], const float y[n]) {
    __m128 temp = _mm_setzero_ps();
    for (size_t i = 0; i < (n - (n % 4)); i += 4) {
        __m128 vx = _mm_loadu_ps(x + i);
        __m128 vy = _mm_loadu_ps(y + i);

        temp = _mm_add_ps(_mm_mul_ps(vx, vy), temp);
    }

    float result[4];
    _mm_storeu_ps(result, temp);

    for (size_t i = (n - (n % 4)); i < n; i++) {
        result[i%4] += + (x[i] * y[i]);
    }

    return (result[0] + result[1]) + (result[2] + result[3]);
}

int main(int argc, char **argv) {
    long n = 12;
    if (argc > 1) {
        n = strtol(argv[1], NULL, 0);
        if (n < 0) n = 0;
        if (n > 12) n = 12;
    }

    printf("x:");
    print_array(n, x);
    printf("y:");
    print_array(n, y);

//    saxpy(n, 3, x, y);

//    printf("after y = 3*x + y\n");
//    printf("y:"); print_array(n, y);

    float dot = sdot(n, x, y);

    printf("dot: %.3f\n", dot);

    return EXIT_SUCCESS;
}
