#ifndef fp_H
#define fp_H

#include <bbc/types.h>

typedef struct floating_point {
    byte    exponent;
    byte    mantissa_1;
    byte    mantissa_2;
    byte    mantissa_3;
    byte    mantissa_4;
} fp;

extern long rnd(long var);


void fp_init(fp var, char str[]){
    fp v;
    char s[10];
    
    v = var;
    // s = str;

};


extern void fp_get(fp var);
extern void fp_let(fp var);
extern void fp_div(fp var);
extern void fp_mult(fp var);
extern void fp_minus(fp var);
extern void fp_plus(fp var);

#endif

