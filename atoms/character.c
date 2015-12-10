#include <stdio.h>

void main_3() { char v1 = 10; printf("Hello World!%c", v1); }
void main_3_non() { char v1 = 10; printf("Hello World!%c", v1); }

void main1() { int v1 = 13; printf("Size: %c     \n", v1); }

// print an equation 6/3=2
void main2() {
  char v1[] = {0x36, 0x2f, 0x33, 0x3d, 0x32, 0x0a, 0x00};

  printf("%s", v1);
}

void main2_non () {
  char v1[] = {'6', '/', '3', '=', '2', '\n', '\0'};

  printf("%s", v1);
}

//int main() {
//  putchar(7);
//}
