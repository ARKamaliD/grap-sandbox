
// This is an include guard.
#ifndef REGULA_FALSI_H
#define REGULA_FALSI_H

#include <stddef.h>

double regula_falsi(double(* fn)(double), double a, double b, unsigned n);

double fn_x2(double);

#endif
