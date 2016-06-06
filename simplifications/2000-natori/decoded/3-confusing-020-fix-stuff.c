#include <stdio.h>
double V4;
int V5;

int F1(int V1, int V2, int V3) {
  printf("a: %d %d %d %f\n", V1, V2, V3, V4);
  return printf("b: %c\n",
      (V1-- + 1 && V1 + 4 && F1(V1, -1, V1), V1 && V2)
          ? (F1(-1, ++V2, V3),
             ((V5 = (int)(V4 = (int)(V2 + 1) / (1 - (int)V3 * 2 - (int)V3 * (int)V3),
               V4 * V4 >= 1 && ((2 % 3) / 4 -
                                  2 + (V4 / 2)) < 1), printf("c: %d %d %d %f %d\n", V1, V2, V3, V4, V5), V5)["ab"]))
          : 'c');
}

int main(int V1, char **V2, char **V3) {
  F1(-1, -2, 0);
}

