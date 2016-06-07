#include <stdio.h>

void F1(int V1, int V2, int V3, int V4) {
  while ((V2 = ++V1) < 4)
    for (V3 = 0; printf("a: %d %d %d %d\n", V1, V2, V3, V4),
        V3 < V2 ? V3 = V3 * 8 + V2 % 8, V2 /= 8, V4 = V3 == V2 | V3 / 8 == V2,
        1 : (V1 - ++V4 || (printf("b: %d\n", V1), 2)) && V1 % V4;)
      ;
}

int main() { F1(1, 0, 0, 0); }
