#include <stdio.h>

// Confusing: empty if
void main1() {
  int V1 = 0;
  int V2 = 2;

  if (V1);
    V2 = 4;

  printf("%d\n", V2);
}

// Non-Confusing: empty if
void main2() {
  int V1 = 0;
  int V2 = 2;

  if (V1);
    V2 = 4;

  printf("%d\n", V2);
}

int main() {
  main1();
  main2();
}
