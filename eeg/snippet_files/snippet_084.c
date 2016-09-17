void main() {
   int V1 = 1;
   int V2 = 11;
   int V3 = 0;

   while (V1 != V2) {
      ++V1;
      if (!V1) break;

      V3++;
   }

   printf("%d %d %d\n", V1, V2, V3);
}