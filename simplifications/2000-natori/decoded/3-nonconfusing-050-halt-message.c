#include <math.h>
#include <stdio.h>
double V4;

int F1(int V1, int V2, int V3) {
  int V5 = V1;
  char V6;

  printf("a: %d %d %d %f\n", V1, V2, V3, V4);

  V1 = V1 - 1;
  if (V5 + 1 != 0 && V5 + 4 != 0) {
    F1(V1, -1, V1);
  }

  if (V1 && V2) {
    V2 = V2 + 1;
    F1(-1, V2, V3);
    V4 = trunc((int)(V2 + 1) / (1 - ((int)V3 * 2) - ((int)V3 * (int)V3)));
    int V7 =
        ((V4 * V4) >= 1) && ((((int)trunc((2 % 3) / 4) - 2) + (V4 / 2)) < 1);
    printf("c: %d %d %d %f %d\n", V1, V2, V3, V4, V7);
    V6 = "ab"[V7];
  } else {
    V6 = 'c';
  }

  return printf("b: %c\n", V6);
}

int main() {
  F1(-1, -2, 0);
  printf("d\n");
}
