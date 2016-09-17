void main() {
   int V1 = 3;
   int V2 = 5;
   int V3 = 0;

   while (V1 != V2 && ++V1) {
      V3++;
   }

   printf("%d %d %d\n", V1, V2, V3);
}