#include <stdbool.h>
#include <stdint.h>

enum RoundMode {
    RM_FLOOR = 1, // Round towards -Infinity
    RM_CEIL,      // Round towards +Infinity
};

typedef struct fix3232 {
    uint32_t fracp;
    int32_t intp;
} fix3232;

// if  isflt==true  num is a floating point number, otherwise it is a fixed point number
typedef struct num {
    bool isflt;
    union {
        struct fix3232 fix;
        double flt;
    };
} num;

union DoubleToInt64 {
    double d;
    unsigned long long i;
};

struct num num_round(struct num num, enum RoundMode rm) {
    // DONE: round  num  according to  rm.

    if (!num.isflt) { // Fixed-point number
        if (num.fix.fracp != 0) {
            if (rm == RM_CEIL) {
                num.fix.intp++;
            }
            num.fix.fracp = 0;
        }
    } else { // Floating-point number
        union DoubleToInt64 converter;
        converter.d = num.flt;
        uint64_t integerValue = converter.i;

        uint64_t signMask = 0x8000000000000000;
        uint64_t exponentMask = 0x7FF0000000000000;
        uint64_t mantissaMask = 0xFFFFFFFFFFFFF;

        uint64_t sign = (integerValue & signMask);
        uint64_t exponent = ((integerValue & exponentMask) >> 52);
        uint64_t mantissa = (integerValue & mantissaMask);

        if (exponent != 0x7FF) { //Ignore infinity and NaN
            if (exponent < 1023) { // Handle case where exponent is less than 0
                if (sign == 0) {
                    if (rm == RM_CEIL && num.flt != 0.0) {
                        num.flt = 1.0;
                    } else {
                        num.flt = 0.0;
                    }
                } else {
                    if (rm == RM_CEIL) {
                        num.flt = -0.0;
                    } else {
                        num.flt = -1.0;
                    }
                }
            } else { // Handle case where exponent is greater than or equal to 0
                uint64_t fractionMask = (1ULL << 52) - 1;
                uint64_t roundBitMask = 1ULL << (51 - (exponent - 1023));

                if (((mantissa & roundBitMask) && rm == RM_FLOOR && sign)) {
                    mantissa += roundBitMask;
                    while (mantissa > 0xFFFFFFFFFFFFF) {
                        mantissa = mantissa >> 1;
                        exponent++;
                    }

                } else if
                        (((mantissa & roundBitMask) && rm == RM_CEIL && !sign)) {
                    mantissa -= roundBitMask;
                    while (mantissa > 0xFFFFFFFFFFFFF) {
                        mantissa = mantissa >> 1;
                        exponent++;
                    }
                }

                mantissa >>= (52 - (exponent - 1023));
                mantissa &= fractionMask;

                uint64_t result = sign | ((exponent) << 52) | mantissa;

                converter.i = result;
                num.flt = converter.d;
            }
        }
    }
    return num;
}

#include <math.h>
#include <stdio.h>

int main() {
    num a;
    a.isflt = true;
    a.flt = 1.25;
//    fix3232 aFix;
//    aFix.intp = -2;
//    aFix.fracp = 0x80000000;
    num aRound = num_round(a, RM_FLOOR);
    printf("Round a =%f", aRound.flt);
//    printf("Round a =%x%x", aRound.fix.intp, aRound.fix.fracp);
//    printf("Round a %x", a.fix.intp);
//    printf("Round a %x", aRound.fix.intp);
    return 0;
}

/*
            uint64_t fractionalMask = (1ULL << (52 + exponent)) - 1;
            uint64_t roundBitMask = 1ULL << (51 + exponent);
            if (roundBitMask > (1ULL << 52)) {
                roundBitMask = 1ULL << 52;
            }
            if (sign) {
                integerValue |= fractionalMask;
                if (rm == RM_CEIL) {
                    integerValue += roundBitMask;
                }
                integerValue &= ~(fractionalMask - 1);
            } else {
                uint64_t minValue = fractionalMask + 1;
                if (rm == RM_CEIL) {
                    if (integerValue >= minValue) {
                        integerValue += roundBitMask;
                    } else {
                        integerValue = minValue;
                    }
                } else {
                    if (integerValue > minValue) {
                        integerValue -= roundBitMask;
                    } else {
                        integerValue = 0;
                    }
                }
                integerValue &= ~(fractionalMask - 1);
            }
            converter.i = integerValue;
            num.flt = converter.d;
*/
