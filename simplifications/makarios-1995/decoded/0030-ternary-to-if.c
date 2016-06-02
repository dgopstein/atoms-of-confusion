#include<stdio.h>

void F1(int V1, int V2, int V3, int V4) {
  V1 = V1 + 1;
  V2 = V1;
  while (V2) {
    V3 = 0;

    int V9;
    if (V3 < V2) {
      V9 = V3 = V3 * 8 + V2 % 8, V2 /= 8, V4 = V3 == V2 | V3 / 8 == V2, 1;
    } else {
      V9 = (V1 - ++V4 || (printf("%d\n", V1), 2)) && V1 % V4;
    }

    for (; V9;)
      if (V3 < V2) {
        V9 = V3 = V3 * 8 + V2 % 8, V2 /= 8, V4 = V3 == V2 | V3 / 8 == V2, 1;
      } else {
        V9 = (V1 - ++V4 || (printf("%d\n", V1), 2)) && V1 % V4;
      }

    V1 = V1 + 1;
    V2 = V1;
  }
}

int main(int V5, char** V6, char** V7, char** V8) {
  F1((int)V5, (int)V6, (int)V7, (int)V8);
}

