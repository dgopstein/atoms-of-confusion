#include <stdio.h>

// Basic assignment: Confusing
void main1() {
  int V1 = 4;
  int V2 = 3;

  int V3 = V1 == 3 ? 2 : 1;

  printf("%d\n", V3);
}

// Basic assignment: Non-Confusing
void main2() {
  int V1 = 4;
  int V2 = 3;

  int V3;
  
  if (V1 == 3) {
    V3 = 2;
  } else {
    V3 = 1;
  }

  printf("%d\n", V3);
}

// Nested assignment: Confusing
void main3() {
  int V1 = 2;
  int V2 = 3;
  int V3 = 1;

  int V4 = V1 == 2 ? V3 == 2 ? 1 : 2 : V2 == 2 ? 3 : 4;

  printf("%d\n", V4);
}

// Nested assignment: Non-Confusing
void main4() {
  int V1 = 2;
  int V2 = 3;
  int V3 = 1;

  int V4;
  if (V1 == 2) {
    if (V3 == 2) {
     V4 = 1;
    } else {
     V4 = 2;
    }
  } else {
    if (V2 == 2) {
     V4 = 3;
    } else {
     V4 = 4;
    }
  }

  printf("%d\n", V4);
}

int main() {
  main1();
  main2();

  main3();
  main4();
}
