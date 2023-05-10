#include <stdio.h>
#include <stdlib.h>

void xor_cipher(char* str, int key);

int main(int argc, char** argv) {
    if (argc != 3) {
        fprintf(stderr, "usage: %s <string> <key>\n", argv[0]);
        return 1;
    }

    int key = atoi(argv[2]);
    xor_cipher(argv[1], key);

    // Why would "printf(argv[1]);" be a VERY BAD idea?
    printf("%s\n", argv[1]);

    return 0;
}

