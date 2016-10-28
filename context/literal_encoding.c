int toplevel_C() {
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

int toplevel_NC() {
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

int predicate_C() {
  int V1 = 12;
  int V2;
  
  if (V1 > 013) {
    V2 = 1;
  } else {
    V2 = 2;
  }

  printf("%d\n", V2);
}

int predicate_NC() {
  int V1 = 12;
  int V2;
  
  if (V1 > 11) {
    V2 = 1;
  } else {
    V2 = 2;
  }

  printf("%d\n", V2);
}

int main() {
  toplevel_C();
  toplevel_NC();
  predicate_C();
  predicate_NC();
}
