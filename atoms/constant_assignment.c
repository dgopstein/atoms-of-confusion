#include <stdio.h>

// Confusing: Positive Conditional
void main1() {
  int V1 = 2;

  if (V1 = 1) {
    printf("true\n"); 
  } else {
    printf("false\n"); 
  }
}

// Non-Confusing: Positive Conditional
void main2() {
  int V1 = 2;
  
  V1 = 1;

  if (1) {
    printf("true\n"); 
  } else {
    printf("false\n"); 
  }
}

// Confusing: Short-circuit
void main3() {
  int V1 = 0;

  if (V1 = 0) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

// Non-Confusing: Short-circuit
void main4() {
  int V1 = 0;

  V1 = 0;

  if (V1) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

// Confusing: Loop
void main5() {
  int V1 = 0;
  int V2 = 9;

  while (!(V1 = 3)) {
    V2--;
    V1++;
  }

  printf("%d %d\n", V1, V2);
}

// Confusing: Loop
void main6() {
  int V1 = 0;
  int V2 = 9;

  V1 = 3;

  while (!3) {
    V2--;
    V1++;
  }

  printf("%d %d\n", V1, V2);
}

// Multiply by zero
int main() {
  main1();
  main2();

  main3();
  main4();

  main5();
  main6();
}
