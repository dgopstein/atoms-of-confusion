void main() {
   int V1 = 0;
   int V2 = 9;

   while (!(V1 = 3)) {
      V2--;
      V1++;
   }

   printf("%d %d\n", V1, V2);
}