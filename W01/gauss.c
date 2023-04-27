#include  <stdio.h>

int main(int argc, char **argv) {
    int sum = 0;
    for (int i = 1; i <= 100; i++) {
        sum += i;
    }
    printf("Die  Summe  aller  natürlichen  Zahlen" \
"von 1 bis 100  beträgt %d.\n", sum);
    return 0;
}
