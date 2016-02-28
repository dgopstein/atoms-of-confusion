#include <stdio.h>

//Confusing: Conditional
void main1() {
  int V1 = 2;

  if (0)
    V1++;
  V1++;

  printf("%d\n", V1);
}

//Non-Confusing: Conditional
void main2() {
  int V1 = 2;

  if (0) {
    V1++;
  }
  V1++;

  printf("%d\n", V1);
}

// Confusing: loop
// Confusing: array initialization
// Confusing: function declaration

int main() {
  main1();
  main2();
}
