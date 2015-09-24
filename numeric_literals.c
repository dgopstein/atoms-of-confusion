#include <stdio.h>

int main() {
  int a[] = {20, 2l, 22, 23, 24};
  int sum = 0;

  for (int i = 0; i < 5; i++) {
     sum += a[i];
  }

  printf("sum: %d\n", sum);

  return 0;
}
