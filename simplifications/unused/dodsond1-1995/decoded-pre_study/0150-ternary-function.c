int F1(int A1) {
  int L1;

  if (65 <= A1 && A1 <= 91) {
    L1 = A1 + 32;
  } else {
    L1 = A1;
  }

  return L1 - 97;
}

main() {
  char V1[9], *V2, V3 = getchar(), V4;
  for (; (V3 != -1) && (!((65 <= V3 && V3 <= 91) || (97 <= V3 && V3 <= 123)));
         V3 = getchar()) {
    putchar(V3);
  }
  for (; V3 != -1;) {
   V2 = V1;
   for (V4 = (65 <= V3 && V3 <= 91);
         (((65 <= V3 && V3 <= 91) || (97 <= V3 && V3 <= 123))
             && "-Pig-Lat-inCOb-fusca-tion!!"[F1(V3)] != '-') || ((V2 == V1) && !(*(V2++) = 'w')) || !(*(V2++) = 97);
       V3 = getchar()) {
     if (65 <= V3 && V3 <= 91) {
       *V2 = V3 + 32;
     } else {
       *V2 = V3;
     }
     V2++;
   }

   if (V4) {
     if (97 <= V3 && V3 <= 123) {
        V3 = V3 - 32;
      } else {
        V3 = V3;
      }
   } else {
     V3 = V3;
   }
   for (;
         ((65 <= V3 && V3 <= 91) || (97 <= V3 && V3 <= 123));
         V3 = getchar()) {
      putchar(V3); 
   }
   *V2 = 0;
   for (V2 = V1; *V2; putchar(*(V2++)))
    ;
   for (; (V3 != -1) && (!((65 <= V3 && V3 <= 91) || (97 <= V3 && V3 <= 123)));
          V3 = getchar()) {
     putchar (V3);
   }
  }
}
