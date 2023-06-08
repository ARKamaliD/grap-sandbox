#include <stdint.h>

struct grasm_state {
    uint64_t ip, acc, r0, r1, r2, r3, r4, r5, r6, r7;
};

uint64_t grasm_interpreter(struct grasm_state *state, size_t len, uint8_t prog[len]);

int main(int argc, char **argv) {
    struct grasm_state state;
    uint8_t prog[0];
    grasm_interpreter(&state, 0, prog);
    return 0;
}
