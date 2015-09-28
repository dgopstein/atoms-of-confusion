#include <stdio.h>

// This isn't an example of simplification, it's confusing exponentiation for xor
//int main() { int v1 = 3; int v2 = 2*v2^2; printf("%d\n", v2); }

// This uses bitwise operators which aren't strictly arithmetic
int main() { int v1 = 3; int v2 = 2-3*4+5/v1*6-7+v1/8*-9*v1; printf("%d\n", v2); }
