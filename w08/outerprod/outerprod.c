#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "outerprod_helpers.h"

/*
 * Given two vectors
 *   u = { u_1, u_2, ..., u_m }
 * and
 *   v = { v_1, v_2, ..., v_n }
 * outerprod() returns the m x n outer product[1] matrix
 *   u (×) v = { u_1 * v_1, u_1 * v_2, ..., u_1 * v_n,
 *               u_2 * v_1, u_2 * v_2, ..., u_2 * v_n,
 *               ...
 *               u_m * v_1, u_m * v_2, ..., u_m * v_n}
 *
 * If not enough memory for the resulting matrix can be allocated, outerprod()
 * returns NULL.
 *
 * [1]: https://en.wikipedia.org/wiki/Outer_product
 */
double *outerprod(double *u, unsigned m, double *v, unsigned n) {
    unsigned mn;
    if (__builtin_umul_overflow(m, n, &mn)) return NULL;
    double *mat = malloc(mn * sizeof *mat);

    if (!mat)
        return NULL;

    for (unsigned i = 0; i < m; i++) {
        const unsigned k = i * n;
        for (unsigned j = 0; j < n; j++) {
            mat[k + j] = u[i] * v[j];
        }
    }

    return mat;
}

void test(unsigned m, unsigned n) {
    double *u = malloc(m * sizeof *u);
    double *v = malloc(n * sizeof *v);
    double *mat = NULL;

    if (!u || !v) {
        printf("Could not allocate both u and v.\n");
        goto free_memory;
    }

    fill_vector(u, m);
    fill_vector(v, n);

    printf("u = ");
    print_vector(u, m);

    printf("v = ");
    print_vector(v, n);

    mat = outerprod(u, m, v, n);

    if (!mat) {
        printf("Could not allocate %ux%u outer product matrix.\n", m, n);
        goto free_memory;
    }

    printf("u (x) v =\n");
    print_matrix(mat, m, n);
    printf("\n");

    free_memory:
    free(u);
    free(v);
    free(mat);
}


int main(void) {
    test(2, 2);
    test(3, 2);
    test(3, 4);
    test(5, 5);
    test(0x202, 0x80);
    test(0x2002, 0x800);
    test(0x20002, 0x8000);

    return 0;
}
