#include <stdio.h>

void toplevel_C() {
  int V1 = 12;
  int V2 = 013;
  int V3;

  if (V1 > V2) {
    V3 = 1;
  } else {
    V3 = 2;
  }

  printf("%d\n", V3);
}

void toplevel_NC() {
  int V1 = 12;
  int V2 = 11;
  int V3;

  if (V1 > V2) {
    V3 = 1;
  } else {
    V3 = 2;
  }

  printf("%d\n", V3);
}

void predicate_C() {
  int V1 = 12;
  int V2;
  
  if (V1 > 013) {
    V2 = 1;
  } else {
    V2 = 2;
  }

  printf("%d\n", V2);
}

void predicate_NC() {
  int V1 = 12;
  int V2;
  
  if (V1 > 11) {
    V2 = 1;
  } else {
    V2 = 2;
  }

  printf("%d\n", V2);
}

void body_C() {
  int V1 = 1;
  int V2 = 2;

  if (V1) {
    V2 = 012;
  }

  printf("%d\n", V2);
}

void body_NC() {
  int V1 = 1;
  int V2 = 012;
  int V3 = 2;

  if (V1) {
    V3 = V2;
  }

  printf("%d\n", V3);
}

void arithmetic_C() {
  int V1 = 12 + 013;

  printf("%d\n", V1);
}

void arithmetic_NC() {
  int V3 = 12 + 11;

  printf("%d\n", V3);
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
