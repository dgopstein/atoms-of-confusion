#include <stdio.h>

// Increment and print all elements of an array
void inc_deref() {
  int v1[] = {0, 1, 2, 3};

  int *v2 = v1;
  for (int v3 = 0; v3 < 4; v3++) {
    printf("%d\n", *v2++);
    v2++;
  }
}

//int main() { int v1[] = {0, 1, 2, 3}; int *v2 = v1; for (int v3 = 0; v3 < 4; v3++) { printf("%d\n", *v2++); v2++; } } // Incrememnt
//int main() { int v1[] = {0, 1, 2, 3}; int *v2 = v1; for (int v3 = 0; v3 < 4; v3++) { printf("%d\n", *v2--); v2++; } } // Decrement
