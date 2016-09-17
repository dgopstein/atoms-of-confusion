void main() {
   int V1;
   for (int V2 = 0; V2 < 2; V2++) {
      int V3 = (V2 < 1);
      if (V3) {
         V1 = V2 + 4;
      } else {
         V1 = V3 + 4;
      }
   }
   printf("%d\n", V1);
}