void main() {
   int V1 = 3;
  
   V1 += 1;

   int V2 = (V1 *= 2);

   printf("%d %d\n", V1, V2);
}