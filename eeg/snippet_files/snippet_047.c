void main() {
   int V1[] = {4, 7, 2, 3};
   int *V2 = V1 + 1;
   V2 = V2 + 2;
   printf("%d\n", *V2);
}