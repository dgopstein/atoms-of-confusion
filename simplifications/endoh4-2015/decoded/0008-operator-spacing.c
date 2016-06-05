#include <stdio.h>

int F1(int V1, int V2) {
  int V3, V4;

  for (V3 = V4 = 1;
       V3 * V3 <= V1 ? V4 = V1 % V3 ? V4 : V3 : V2 + 1 ? V4 < 2 ? V1 && F1(V2, 0) : F1(V4, V2),
      printf("%c", V2 ? 10 : 32 << !V1), V1 -= V4 * !!V1 : (F1(V4, V1 / V4), 0);)
    V3++;

  return 0;
}

int main(int V6, char **V7) {
  F1(V5 - 1, -1);
}
