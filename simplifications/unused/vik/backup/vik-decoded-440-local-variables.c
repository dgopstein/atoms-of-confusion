#include <stdio.h>
#include <string.h>

char X[] =
  " ETIANMSURWDKGOHVF:L:PJBXCYZQ::54:3:::2&:+::::16=/:::(:7:::8:90"
  "::::::::::::?_::::\"::.::::@:::'::-::::::::;!:):::::,:::::";

int j,h,f,u,d,g,n,i,l,r,p,c,o,t,s,Q=32,T[32],W[32],I=13000;

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
                l=W[h%Q]=o;
                h += 1;
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
  
  int a=0;
  int V2 = 0;
  while (i<=Q*Q&&!v) {
    if (!(i++%Q)) {
      if (c>a) {
        V2=s;
        a=c;
      }
      c=s=0;
    }

    j=T[i%Q];
    if (j) {
      j = T[i/Q]*10/j;
    }
    if (j < 5) {
      j *= 3;
    }
    if (j>7&&j<13) {
      s=(c*s+T[i/Q]/2)/(c+1);
      c = c + 1;
    }
  }

  while (i<((int)(v/4)*I)) {
    int V1 = 0;
    if (i/I<v%4) {
      V1 = (i%2)*85;
    }
    if (i%176 >= 88) {
      V1 *= 2;
    }

    putchar(V1);
    i++;
  }

  r+=(h-r)/Q*Q;

  if (v == 0) {
    g = 0;

    while (r+t!=h+1&&h>5) {
      *X=Q;

      if (r%2) {
        ++n;
        p = 2*p+(W[r%Q]>2*V2);
        r += 1;
      }

      if (r+t!=h+1) {
        if (W[r%Q]>2*V2||r==h) {
          if (n<=6) {
            putchar(X[p-1+(1<<n)]);
          }
          p=n=0;
        }
        if (W[r%Q]>6*V2) {
          putchar(Q);
        }
        r += 1;
      }
    }
  }


  return 0;
}
