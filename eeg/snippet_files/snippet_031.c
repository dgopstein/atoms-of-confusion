void main() {
   int V1 = 2;
   int V2 = 0;
   int V3 = 3;

   if (V1)
      if (V2)
         V3 = V3 + 2;
   else
      V3 = V3 + 4;

   printf("%d\n", V3);
}