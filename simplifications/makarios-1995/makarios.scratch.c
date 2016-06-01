#include <stdio.h>

main(int n,char**i,char**a,char**m){
  printf("a: %c, m: %c\n", a[0], m[0]);
  F1(n,i,a,m);
}

F1(n,i,a,m){
  while(i=++n)
    for(a=0;a<i?a=a*8+i%8,i/=8,m=a==i|a/8==i,1:(n-++m||printf("%o\n",n))&&n%m;)
      ;//fflush(stdout);
}
