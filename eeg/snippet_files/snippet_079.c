void main() {
   int V1 = 1;
   int V2 = 5;

   if (++V1 || ++V2) {
      V1 = V1 * 2;
      V2 = V2 * 2;
   }

   printf("%d %d\n", V1, V2);
}