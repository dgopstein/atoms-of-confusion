#include<stdio.h>

void F1(int n, int i, int a, int m) {
  while (i = ++n)
    for (a = 0; a < i ? a = a * 8 + i % 8, i /= 8, m = a == i | a / 8 == i,
        1 : (n - ++m || (printf("%o\n", n), 2)) && n % m;)
      ;
}

main(int n, char** i, char** a, char** m) {
  F1((int)n, (int)i, (int)a, (int)m);
}

