//void main() {
//  int V1 = 1;
//  int V2 = 5;
//
//  V1 == V2 && ++V1 || ++V2;
//
//  printf("%d %d\n", V1, V2);
//}

void main() {
  int V1;
  int V2;
  int V3;
  for (V2 = 0; V2 < 2; V2++) {
    V3 = (V2 < 1);
    if (V3) {
      V1 = V2 + 4;
    } else {
      V1 = V3 + 4;
    }
  }
  printf("%d %d %d\n", V1, V2, V3);
}
