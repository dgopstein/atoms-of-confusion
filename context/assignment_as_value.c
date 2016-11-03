#include <stdio.h>

void toplevel_C() {
  int V1 = 1;
  int V2 = (V1 = 2);

  printf("%d %d\n", V1, V2);
}

void toplevel_NC() {
  int V1 = 1;

  V1 = 2;

  int V2 = V1;

  printf("%d %d\n", V1, V2);
}

void predicate_C() {
  int V1 = 0;
  int V2 = 1;

  if ((V1 = 2) != 0) {
    V2 = 1;
  } else {
    V2 = 2;
  }

  printf("%d %d\n", V1, V2);
}

void predicate_NC() {
  int V1 = 0;
  int V2 = 1;

  V1 = 2;
  
  if (V1 != 0) {
    V2 = 1;
  } else {
    V2 = 2;
  }

  printf("%d %d\n", V1, V2);
}

void body_C() {
  int V1 = 1;
  int V2 = 2;
  int V3 = 3;

  if (V1) {
    V3 = (V2 = 4);
  } else {
    V3 = 5;
  }

  printf("%d %d %d\n", V1, V2, V3);
}

void body_NC() {
  int V1 = 1;
  int V2 = 2;
  int V3 = 3;

  if (V1) {
    V2 = 4;
    V3 = V2;
  } else {
    V3 = 5;
  }

  printf("%d %d %d\n", V1, V2, V3);
}

void arithmetic_C() {
  int V1 = 1;
  int V2 = 2;
  int V3 = 3 + (V1 = V2);

  printf("%d %d %d\n", V1, V2, V3);
}

void arithmetic_NC() {
  int V1 = 1;
  int V2 = 2;

  V1 = V2;
  
  int V3 = 3 + V1;

  printf("%d %d %d\n", V1, V2, V3);
}

int main() {
  toplevel_C();
  toplevel_NC();
  predicate_C();
  predicate_NC();
  body_C();
  body_NC();
  arithmetic_C();
  arithmetic_NC();
}
