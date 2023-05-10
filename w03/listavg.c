#include <stdio.h>

typedef struct node {
    struct node *next;
    double val;
} t_node;

double listavgrec(const struct node *list, int size, double acc) {
    acc += list->val;
    size++;
    return list->next ? listavgrec(list->next, size, acc) : acc / size;
}

double listavg(const struct node *list) {
    // DONE: your implementation :)
    return list ? listavgrec(list, 0, 0.0) : 0.0;
}

// My first solution
/*
double listavg(const struct node *list) {
    // DONE: your implementation :)
    if (!list) return 0;
    else {
        int size = 0;
        double sum = 0.0;
        for (; list; ++size) {
            sum += list->val;
            list = list->next;
        }
        return sum / size;
    }
}
*/

// Musterlösung
/*
struct node {
    struct node *next;
    double val;
};

double listavg(const struct node *list) {
    if (!list) {
        return 0.0;
    }
    double sum = 0;
    unsigned long n = 0;
    do {
        sum += list->val;
    } while (++n, list = list->next);
    return sum / n;
}
*/

int main(void) {
    t_node input[10];

    for (int i = 0; i < sizeof(input) / sizeof(input[0]); ++i) {
        input[i].val = i;
        if (i > 0)input[i].next = &input[i - 1];
    }
    printf("result = %f", listavg(&input[sizeof(input) / sizeof(input[0])] - 1));
    return 0;
}
