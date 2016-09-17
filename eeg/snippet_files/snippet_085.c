void main() {
   int V1[5];
   V1[4] = 3;

   while (V1[4]) {
      V1[3 - V1[4]] = V1[4];
      V1[4] = V1[4] - 1;
   }

   printf("%d %d\n", V1[1], V1[4]);
}