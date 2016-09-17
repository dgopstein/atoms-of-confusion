void main() {
   int V3 = 0;

   for (int V1 = 0; V1 < 2; V1++) {
      for (int V2 = 0; V1 < 2; V1++) {
        V3 = 4 * V1 + V2;
      }
   }

   printf("%d\n", V3);
}