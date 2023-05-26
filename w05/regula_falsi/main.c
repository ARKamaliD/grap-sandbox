#include <unistd.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <tgmath.h>

#include "regula_falsi.h"


const char *usage_msg =
        "Usage: %s [options] fn   Approximate fn's zero in a given interval\n"
        "   or: %s -t             Run tests and exit\n"
        "   or: %s -h             Show help message and exit\n";

const char *help_msg =
        "Positional arguments:\n"
        "  fn   The function to approxiate zero of. One of {fn_1,fn_x,fn_x2}.\n"
        "\n"
        "Optional arguments:\n"
        "  -a X   The start of the interval (default: X = 0.0)\n"
        "  -b X   The end of the interval (default: X = 1.0)\n"
        "  -n N   The number of maximum steps (default: N = 2)\n"
        "  -t     Run tests and exit\n"
        "  -h     Show help message (this text) and exit\n";

void print_usage(const char *progname) {
    fprintf(stderr, usage_msg, progname, progname, progname);
}

void print_help(const char *progname) {
    print_usage(progname);
    fprintf(stderr, "\n%s", help_msg);
}


static double fn_1(double x) {
    (void) x;
    return 1.0;
}

static double fn_x(double x) {
    return x;
}


#define check(stmt, exp) check_impl(#stmt, stmt, exp)

// Returns true when val is approx. equal to exp.
static bool check_impl(const char *name, double val, double exp) {
    bool ok = fabs(val - exp) < 0.0000001;
    printf("%s: %s (%f) == %f\n", "not ok" + (4 * ok), name, val, (double) exp);
    return ok;
}

unsigned tests(void) {
    unsigned failed = 0;
    failed += !check(regula_falsi(fn_1, -10, 15, 0), -10);
    failed += !check(regula_falsi(fn_x, -10, 15, 5), 0);
    failed += !check(regula_falsi(fn_x, 0, 1, 2), 0);
    failed += !check(regula_falsi(fn_x, 0, 1, 200), 0);
    failed += !check(regula_falsi(fn_x2, -3, 5, 1), -7.5);
    failed += !check(regula_falsi(fn_x2, -0.1, 0.01, 300), 0.00091743);
    failed += !check(regula_falsi(fn_x2, -3, 4, 4), 1.5);
    failed += !check(regula_falsi(fn_x2, 0, 3, 13), 0);

    if (failed)
        printf("%u tests FAILED\n", failed);
    else
        printf("All tests PASSED\n");

    return failed;
}


typedef double(*Func)(double);

struct FnOption {
    const char *name;
    Func fn;
};

const struct FnOption fn_options[] = {
        {"fn_1",  fn_1},
        {"fn_x",  fn_x},
        {"fn_x2", fn_x2},
        // feel free to add more options here
};

Func get_fn(const char *fn_name) {
    for (size_t i = 0; i < (sizeof fn_options) / (sizeof *fn_options); i++) {
        const struct FnOption *fn_option = &fn_options[i];
        if (!strcmp(fn_option->name, fn_name)) {
            return fn_option->fn;
        }
    }

    return NULL;
}


int main(int argc, char **argv) {
    /* Uncomment the following line if you just want to run tests */
    // return tests() ? EXIT_FAILURE : EXIT_SUCCESS;

    const char *progname = argv[0];

    if (argc == 1) {
        print_usage(progname);
        return EXIT_FAILURE;
    }

    double a = 0.0, b = 1.0;
    size_t n = 2;

    int opt;
    while ((opt = getopt(argc, argv, "tha:b:n:")) != -1) {
        switch (opt) {
            case 't':
                return tests() ? EXIT_FAILURE : EXIT_SUCCESS;
                break;
            case 'h':
                print_help(progname);
                return EXIT_SUCCESS;
                break;
            case 'a':
                a = atof(optarg);
                break;
            case 'b':
                b = atof(optarg);
                break;
            case 'n':
                n = atol(optarg);
                break;
            default:
                print_usage(progname);
                return EXIT_FAILURE;
                break;
        }
    }

    if (optind >= argc) {
        printf("%s: Missing posintional argument -- 'fn'\n", progname);
        print_usage(progname);
        return EXIT_FAILURE;
    }

    const char *fn_name = "fn_x";
    Func fn = get_fn(fn_name);
    if (!fn) {
        fprintf(stderr, "%s: Invalid value for 'fn' -- %s\n", progname,
                fn_name);
        print_usage(progname);
        return EXIT_FAILURE;
    }

    printf("regula_falsi(%s, %f, %f, %zu) = %f\n", fn_name, a, b, n,
           regula_falsi(fn, a, b, n));

    return EXIT_SUCCESS;
}
