#include <ctype.h>
#include <errno.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
    if (argc < 2 || !strcmp(argv[1], "-h")) {
        fprintf(stderr, "Usage: %s x   Compute sqrt(x)\n", argv[0]);
        return EXIT_FAILURE;
    }

    // TODO: Convert argv[1] to double and check for errors
    errno = 0;
    char *endPtr;
    double x = strtod(argv[1], &endPtr);
    if (*endPtr != '\0' || endPtr == argv[1] || errno == ERANGE) {
        printf("Invalid Number \n");
        return EXIT_FAILURE;
    }


    printf("sqrt(%f) = %f\n", x, sqrt(x));

    return EXIT_SUCCESS;
}
