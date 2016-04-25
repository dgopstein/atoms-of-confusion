main() {
  char V1[9], *V2, V3 = getchar(), V4,V5 = 'A', V6 = 'a', V7 = 26;
  for (; (V3 + 1) && (!(((V3 - V5) * (V5 + V7 - V3) >= 0) + ((V3 - V6) * (V6 + V7 - V3) >= 0)));
         putchar(V3), V3 = getchar());
  for (; V3 + 1;) {
   for (V2 = V1, V4 = ((V3 - V5) * (V5 + V7 - V3) >= 0);
         ((((V3 - V5) * (V5 + V7 - V3) >= 0) + ((V3 - V6) * (V6 + V7 - V3) >= 0))
             && "-Pig-" "Lat-in" "COb-fus" "ca-tion!!"[(((V3 - V5) * (V5 + V7 - V3) >= 0) ? V3 - V5 + V6 :
             V3) - V6] - '-') || ((V2 == V1) && !(*(V2++) = 'w')) || !(*(V2++) = V6);
       *(V2++) = (((V3 - V5) * (V5 + V7 - V3) >= 0) ? V3 - V5 + V6 : V3), V3 = getchar())
    ;
   for (V3 = V4 ? (((V3 - V6) * (V6 + V7 - V3) >= 0) ? V3 - V6 + V5 : V3) : V3;
         (((V3 - V5) * (V5 + V7 - V3) >= 0) + ((V3 - V6) * (V6 + V7 - V3) >= 0));
         putchar(V3), V3 = getchar())
    ;
   for (*V2 = 0, V2 = V1; *V2; putchar(*(V2++)))
    ;
   for (; (V3 + 1) && (!(((V3 - V5) * (V5 + V7 - V3) >= 0) + ((V3 - V6) * (V6 + V7 - V3) >= 0)));
          putchar (V3), V3 = getchar())
    ;
  }
}
