#include <stdio.h>

//int main() { printf("\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\v\w\y\z"); }

//int main() { printf("A:\DATA\ZORK1.DAT\n"); }

// No null terminator
void main1() {
  //char v1[] = {'S','t','r','i','n','g','\0'}; // Correct line
  char v1[] = {'S','t','r','i','n','g','\O'};

  printf("%s\n", v1);
}

void main2() {
  printf("\c\n");
}
