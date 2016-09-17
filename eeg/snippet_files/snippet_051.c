void main() {
   int V1 = 2;
   int V2 = 3;
   int V3 = 1;

   int V4 = (V1 == 2 ? (V3 == 2 ? 1 : 2) : (V2 == 2 ? 3 : 4));

   printf("%d\n", V4);
}