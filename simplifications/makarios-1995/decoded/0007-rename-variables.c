#include<stdio.h>

void F1(int V1, int V2, int V3, int V4) {
  while (V2 = ++V1)
    for (V3 = 0; V3 < V2 ? V3 = V3 * 8 + V2 % 8, V2 /= 8, V4 = V3 == V2 | V3 / 8 == V2,
        1 : (V1 - ++V4 || (printf("%o\n", V1), 2)) && V1 % V4;)
      ;
}

int main(int V5, char** V6, char** V7, char** V8) {
  F1((int)V5, (int)V6, (int)V7, (int)V8);
}

