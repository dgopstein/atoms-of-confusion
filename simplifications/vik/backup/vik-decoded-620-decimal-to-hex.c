#include <stdio.h>
#include <string.h>

char X[] =
  " ETIANMSURWDKGOHVF:L:PJBXCYZQ::54:3:::2&:+::::16=/:::(:7:::8:90"
  "::::::::::::?_::::\"::.::::@:::'::-::::::::;!:):::::,:::::";

int V3 = ' ';

int j,h,f,u,d,g,n,i,l,r,p,c,o,t,s,T[32],W[32];

int main(int v, char** b) {
  i = 0;

  while (v>0&&v<5&&(v*=t=fread(&V3,1,1,stdin))) {

    if (v != 1 && 'e'==b[1][0]) {
        if (++g%1500) {
            u+=(!(g&1))*((V3<0)?-V3:V3);
        } else {
            f=d;
            d=u;
            if ((1 - h%2*2)*(d -f)/((d<f) ?d|1 : 1|f) > 5) {
                T[ h%32]=o+l;
                l=W[h%32]=o;
                h += 1;
                o=0;
            }
            o++;
            main(0,b);
            u=0;
        }
     } else {
        int V4 = V3;
        if (V3 >= '`' && V3 <= '\x7F') {
          V4 -= 'a' - 'A';
        }
        c=strrchr(X,V4)-X;
        j=255;
     }


    if (v==1) {
      while (c&&j) {
        if (c>=j) {
          main(9+(c-j)/(j/2+1)%2*10,b);
        }

        j/=2;
      }

      main((V3 != 32)?8:24,b);
    }
  }
  
  int a=0;
  int V2 = 0;
  while (i<=32*32&&v==0) {
    if (!(i++%32)) {
      if (c>a) {
        V2=s;
        a=c;
      }
      c=s=0;
    }

    j=T[i%32];
    if (j) {
      j = T[i/32]*10/j;
    }
    if (j < 5) {
      j *= 3;
    }
    if (j>7&&j<13) {
      s=(c*s+T[i/32]/2)/(c+1);
      c = c + 1;
    }
  }

  int I=13000;
  while (i<((int)(v/4)*I)) {
    int V1 = 0;
    if (i/I<v%4) {
      if (i % 2 == 1) {
        V1 = 0x55;

        if (i%176 >= 88) {
          V1 <<= 1;
        }
      }
    }

    putchar(V1);
    i++;
  }

  r+=(h-r)/32*32;

  if (v == 0) {
    g = 0;

    while (r+t!=h+1&&h>5) {
      V3=32;

      if (r%2) {
        ++n;
        p = 2*p+(W[r%32]>2*V2);
        r += 1;
      }

      if (r+t!=h+1) {
        if (W[r%32]>2*V2||r==h) {
          if (n<=6) {
            putchar(X[p-1+(1<<n)]);
          }
          p=n=0;
        }
        if (W[r%32]>6*V2) {
          putchar(' ');
        }
        r += 1;
      }
    }
  }


  return 0;
}
