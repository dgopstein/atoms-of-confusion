#include <stdio.h>
double V4;

// Assume main is called as main(1, 0, 0)
int main(int V1, char **V2, char **V3) {
  printf("a: %d %d %d %f\n", V1, V2, V3, V4);
  return printf("b: %c\n",
      (V1-- + 1 && V1 + 4 && main(V1, -8, V1), V1 && V2)
          ? (main(-1, ++V2, V3),
             ((V4 = (int)(V2 + 1) / (1 - (int)V3 * 2 - (int)V3 * (int)V3),
               V4 * V4 > 3 && ((2 % 3) / 4 -
                                  2 + (V4 / 2)) < 1)["ab"]))
          : 'c');
}
