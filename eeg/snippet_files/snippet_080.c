void main() {
   int V1 = 2;
   int V2 = 4;

   if (++V1) {
        V1 = V1 * 2;
        V2 = V2 * 2;
   } else if (++V2) {
        V1 = V1 * 2;
        V2 = V2 * 2;
   }

   printf("%d %d\n", V1, V2);
}