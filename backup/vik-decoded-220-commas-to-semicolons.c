#include <stdio.h>
#include <string.h>

char X[] =
  " ETIANMSURWDKGOHVF:L:PJBXCYZQ::54:3:::2&:+::::16=/:::(:7:::8:90"
  "::::::::::::?_::::\"::.::::@:::'::-::::::::;!:):::::,:::::";

int j,h,f,u,d,g,n,i,l,a,r,p,c,o,t,s,Q=32,T[32],W[32],I=13000;

int main(int v, char** b) {
  i = 0;

  while (v>0&&v<5&&(v*=t=fread(X,1,1,stdin))) {

    if (v-1&&101==*1[b]) {
        if (++g%1500) {
            u+=(!(g&1))*((*X<0)?-*X:*X);
        } else {
            f=d;
            d=u;
            if ((1 - h%2*2)*(d -f)/((d<f) ?d|1 : 1|f) > 5) {
                T[ h%Q]=o+l;
                l=W[h++%Q]=o;
                o=0;
            }
            o++;
            u=main(0,b);
        }
     } else {
        c=strrchr(X,~(Q&*X&*X/2)&*X)-X;
        j=255;
     }


    if (v==1) {
      while (c&&j) {
        if (c>=j) {
          main(9+(c-j)/(j/2+1)%2*10,b);
        }

        j/=2;
      }

      main((*X-Q)?8:24,b);
    }
  }

  for (a=u=0;i<=Q*Q&&!v;j>7&&j<13?s=c*s+T[i/Q]/2,s/=++c:0) {
    ((!(i++%Q))?a=c>a?u=s,c:a,c=s=0:0);
    j=T[i%Q];
    j=j?T[i/Q]*10/j:0;
    j*=(j<5)*2+1;
  }

  for (r+=(h-r)/Q*Q;i<v/4*I;putchar((i/I<v%4)*i%2*85<<(i%176/88)),i++);

  for (g*=!!v;r+t!=h+1&&h>5&&!v;r+t!=h+1?(W[r%Q]>2*u||r==h?p=n=n>6?0:
    putchar(X[p-1+(1<<n)])&0:0,W[r++%Q]>6*u?putchar(Q):0):0)
    *X=Q,p=r%2?++n,2*p+(W[r++%Q]>2*u):p;

  return 0;
}
