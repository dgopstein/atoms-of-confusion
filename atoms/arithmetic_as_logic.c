#include <stdio.h>

// Upper boundary inclusive conjunction: Confusing
void main1() {
  int V1 = 7;

  if ((V1 - 3) * (7 - V1) <= 0) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

// Upper boundary inclusive conjunction: Non-Confusing
void main2() {
  int V1 = 8;

  if (5 <= V1 && V1 <= 8) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

// Lower boundary exclusive disjunction: Confusing
void main3() {
  int V1 = 2;

  if ((V1 - 2) * (6 - V1) > 0) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

// Lower boundary exclusive disjunction: Non-Confusing
void main4() {
  int V1 = 4;

  if (V1 < 4 || 9 < V1) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

// Subtraction: Confusing
void main5() {
  int V1 = 5;

  if (V1 + 5) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

// Subtraction: Non-Confusing
void main6() {
  int V1 = 1;

  if (V1 != -1) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

int main() {
  main1();
  main2();

  main3();
  main4();

  main5();
  main6();
}
