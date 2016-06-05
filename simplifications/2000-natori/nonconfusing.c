#include <math.h>
#include <stdio.h>
double V4;
int main(int V1, char **V2, char **V3) {
  char V4;
  int V5 = V1;

  printf("a: %d %d %d %f\n", V1, V2, V3, V4);

  V1 = V1 - 1;
  if (V5 + 1 != 0 && V5 + 4 != 0) {
    main(V1, -8, V1);
  }

  if (V1 && V2) {
    V2 = V2 + 1;
    main(-1, V2, V3);
    V4 = trunc((int)(V2 + 1) / (1 - ((int)V3 * 2) - ((int)V3 * (int)V3)));
    V4 = "ab"[((V4 * V4) > 3) && (((trunc((2 % 3) / 4) - 2) + (V4 / 2)) < 1)];
  } else {
    V4 = 'c';
  }

  return printf("b: %c\n", V4);
}
