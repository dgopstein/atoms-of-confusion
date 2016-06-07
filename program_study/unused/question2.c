#include <stdio.h>
#define TA v5 =
#define CG v6 =

#define Y(a3) \
  v1; \
  v2++; \
  if (v2 % 2) { \
    v3 = v3 * 4 + a3; \
    if (v3 && v2 % 8 > 5) { \
      f2(1, v3); \
      v3 = 0;\
    } \
  } \
  v1 =

#define C Y(1)
#define G Y(2)
#define A Y(0)

#define AT \
  int m(void) { \
  v1 =

#define T Y(3)
#define GC \
  v1; \
  return 0; \
  } \
  int (*v4)(void) = m;

int v8 = 0;
int f1() {
  if (v8 == 0) {
    v8++;
    return 99;
  } else {
    return 0;
  }
}
void f2(int a1, int a2) {
  while (a1--) {
    putchar(a2);
  }
}
int (*v4)(void) = 0, v1 = 0, v2 = 0, v3 = 0, v5 = 0, v6 = 0;
void f3() {
  if (!v1) {
    v3 = f1();
    if (v3 < 0) {
      v3 = 0;
    }
    v1 = 64;
  }
  v2++;
  v5 = v2 % 8;
  v5 =(1 + v5 * (7 - v5)) / 3;
  v6 = v2 * (15 - v2) - 36;
  int v7 = !v5 + 4;
  f2(v7 + (v6 < 0 ? 0 : v6 / 6), ' ');
}
int main() {
  if (v4) {
    v4();
  } else {
    puts("#include \"prog.c\"\n\n     AT");
    for (; f3(), v5 || v3; v2 %= 16) {
      if (v5) {
        int v7 = (v3 / v1) & 3;
        f2(1, "ACGT"[v7]);
        f2(v5, '~');
        f2(1, "TGCA"[v7]);
        v1 /= 4;
        f2(1, '\n');
      } else {
        puts(v2 % 8 ? "CG" : "TA");
      }
    }
    puts("GC");
  }
  return 0;
}

// deviations from endoh2
// Fix the trailing \'s in the macros
// Fix the a2 global
// Initialize all the v variables
// Replace getchar with f1
