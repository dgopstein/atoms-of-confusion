#include <stdio.h>

// Self-assignment: Confusing
void main1() {
  int V1 = 0;
  V1 = V1;
  printf("%d\n", V1);
}

// Self-assignment: Non-Confusing
void main2() {
  int V1 = 0;
  printf("%d\n", V1);
}

void main3() {
  int V1, V2;

  if (V1) {
    V2 = 10000;
  } else {
    V2 = 10000;
  }

  printf("%d\n", V2);
}

void main4() {
  int V1, V2;

  V2 = 10000;

  printf("%d\n", V2);
}

void main5() {
  int V1 = 0;
  int V2;

  while (V1 < 100) {
    V1 = V1 + 1;
    V2 = V1;
  }

  printf("%d %d\n", V1, V2);
}

void main6() {
  int V1 = 100;
  int V2 = 100;

  printf("%d %d\n", V1, V2);
}

int main() {
  main1();
  main2();

  main3();
  main4();

  main5();
  main6();
}
