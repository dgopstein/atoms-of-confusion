char*_="'""/*"; // No \0?

#include <stdio.h>

int main() {
  printf("_: %s\n", _);
}
