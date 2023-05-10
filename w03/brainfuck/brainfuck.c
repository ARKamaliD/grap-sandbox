#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void print_array(uint8_t *array, size_t array_len) {
    for (int i = 0; i < array_len; i++) {
        printf("%x", array[i]);
    }
    printf("\n");
}

void print_array_pointer(uint8_t *array, size_t array_len, const uint8_t *cur) {
    for (int i = 0; i < array_len; i++) {
        if (i == (cur - array)) {
            printf("\"%x\"", array[i]);
        } else
            printf("%x", array[i]);
    }
    printf("\n\n");
}

void print_program(const char *program, int pc) {
    for (int i = 0; i < strlen(program); i++) {
        if (i == (pc)) {
            printf("\"%c\"", program[i]);
        } else
            printf("%c", program[i]);
    }
    printf("\n");
}

// Interpreter state
struct BFState {
    // The array and the size of the array.
    size_t array_len;
    uint8_t *array;

    // Pointer to the current position in the array; array <= cur < (array+array_len)
    uint8_t *cur;
};

// Return 0 on success, and -1 in case of an error (e.g., an out-of-bounds access).
int brainfuck(struct BFState *state, const char *program) {
    // DONE: your implementation. :)

    // Prevent warnings about unused parameters.
    (void) state, (void) program;

    int pc = 0;
    int is_finished = 0;
    int is_interrupted = 0;

    while (!is_finished && !is_interrupted) {
//        printf("%c\n", program[pc]);
        print_program(program, pc);
        switch (program[pc]) {
            case '.':
//                putchar(*state->cur);
//                putchar('\n'); // for nicer output
                pc++;
                break;
            case ',':
//                (*state->cur) = getchar();
//                getchar(); // to avoid '\n' after pressing enter
                pc++;
                break;
            case '+':
                (*state->cur)++;
                pc++;
                break;
            case '-':
                (*state->cur)--;
                pc++;
                break;
            case '>':
                if (state->cur >= state->array + state->array_len - 1) {
                    is_interrupted = 1;
                    break;
                } else {
                    state->cur++;
                    pc++;
                    break;
                }
            case '<':
                if (state->cur <= state->array) {
                    is_interrupted = 1;
                    break;
                } else {
                    state->cur--;
                    pc++;
                    break;
                }
            case '[':
                if (*(state->cur) == 0) {
                    int diff = 1;
                    while (diff != 0 && program[pc] != 0) {
                        pc++;
                        switch (program[pc]) {
                            case '[':
                                diff++;
                                break;
                            case ']':
                                diff--;
                                break;
                            default:
                                break;
                        }
                    }
                    if (program[pc] == 0)
                        is_interrupted = 1;
                } else pc++;
                break;
            case ']':
                if (*(state->cur) != 0) {
                    int diff = -1;
                    while (diff != 0 && pc > 0) {
                        pc--;
                        switch (program[pc]) {
                            case '[':
                                diff++;
                                break;
                            case ']':
                                diff--;
                                break;
                            default:
                                break;
                        }
                    }
                    if (pc < 0 || (pc == 0 && program[pc] != '['))
                        is_interrupted = 1;
                } else pc++;
                break;
            case 0:
                is_finished = 1;
                break;
            default:
                pc++;
                break;
        }
//        print_array_pointer(state->array, state->array_len, state->cur);
    }

    return -is_interrupted;
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s <bfprog>\n", argv[0]);
        return EXIT_FAILURE;
    }

    size_t array_len = 12;
    uint8_t *array = calloc(array_len, sizeof(uint8_t));
    if (!array) {
        fprintf(stderr, "could not allocate memory\n");
        return EXIT_FAILURE;
    }

    print_array(array, array_len);


    uint8_t barray[] = {0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x0};
    print_array(barray, array_len);

    struct BFState state = {
            .array_len = array_len,
            .array = barray,
            .cur = &barray[3],
    };
    int res = brainfuck(&state, argv[1]);
    if (res) {
        puts("an error occured");
        return EXIT_FAILURE;
    }

    print_array(array, array_len);

    return EXIT_SUCCESS;
}

