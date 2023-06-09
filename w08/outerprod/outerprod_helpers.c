#include <stdio.h>
#include <stdlib.h>

#include "outerprod_helpers.h"

void fill_vector(double* v, unsigned n) {
    for(unsigned i = 0; i < n; i++) {
        v[i] = (double)(0x1F - rand() % 0x40) / 4.0;
    }
}

void print_vector(double* v, unsigned n) {
    printf("{ ");

    for (unsigned i = 0; i < n; i++) {
        if (i == 2 && n > 3) {
            printf("..., ");
            i = n - 2;
            continue;
        }

        printf("% .2f%s", v[i], i == n - 1 ? "" : ", ");
    }

    printf(" } in R^%u\n", n);
}

void print_matrix(double* mat, unsigned m, unsigned n) {
    printf("  { ");

    for (unsigned i = 0; i < m; i++) {
        if (i == 2 && m > 3) {
            printf("  ...\n    ");
            i = m - 2;
            continue;
        }

        const unsigned k = i*n;
        for (unsigned j = 0; j < n; j++) {
            if (j == 2 && n > 3) {
                printf("..., ");
                j = n - 2;
                continue;
            }

            printf("% 8.4f%s", mat[k + j], j == n - 1 ? "" : ", ");
        }

        printf("%s", i == m - 1 ? "" : ",\n    ");
    }

    printf(" } in R^[%ux%d]\n", m, n);
}
