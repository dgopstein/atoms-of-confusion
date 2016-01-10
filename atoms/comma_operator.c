#include <stdio.h>

// Comma and nested assignment: Confusing
void main1() {
  int V1, V2;

  V1 = (V2 = 1, 2);

  printf("%d %d\n", V1, V2);
}

// Comma and nested assignment: Non-Confusing
void main2() {
  int V1, V2;

  V1 = 2;
  V2 = 1;

  printf("%d %d\n", V1, V2);
}

// Comma evaluation order: Confusing
void main3() {
  int V1 = 3;
  int V2 = (V1 *= 2, V1 += 1);

  printf("%d %d\n", V1, V2);
}

// Comma evaluation order: Non-Confusing
void main4() {
  int V1 = 3;
  
  V1 *= 2;

  int V2 = (V1 += 1);

  printf("%d %d\n", V1, V2);

}

int main() {
  main1();
  main2();

  main3();
  main4();

  //main5();
  //main6();
}
