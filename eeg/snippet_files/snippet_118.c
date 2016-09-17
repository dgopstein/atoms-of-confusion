#include  &lt;limits.h&gt;
void main() {
   int V1 = -1;

   unsigned int V2;
   if (V1 >= 0) {
      V2 = V1;
   } else {
      V2 = UINT_MAX + (V1 + 1);
   }

   int V3;
   if (V2 >= 0) {
      V3 = 4;
   } else {
      V3 = 5;
   }  

   printf("%d\n", V3);
}