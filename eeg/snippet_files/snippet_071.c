void main() {
   int V1 = 1, V2 = 2;

   if (V1 < V2) {
      #define M1 1
      #define M2 2
   } else {
      #define M1 2
      #define M2 1
   }

   printf("%d %d\n", M1, M2);
}