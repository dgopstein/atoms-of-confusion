#include "stdio.h"
char *V1 [] = {
  "]I^x[I]k\\I^o[IZ~\\IZ~[I^|[I^l[I^j[I^}[I^n[I]m\\I]h",
  "]IZx\\IZx[IZk\\IZk[IZo_IZ~\\IZ~[IZ|_IZl_IZj\\IZj]IZ}]IZn_IZm\\IZm_IZh",
  "]IZx\\IZx[I^k[I\\o]IZ~\\IZ~\\I]|[IZl_I^j]IZ}]I^n[IZm\\IZm_IZh",
  "]IZx\\IZx[IZk\\IZk[IZo_IZ~\\IZ~_IZ|[IZl_IZj\\IZj]IZ}]IZn_IZm\\IZm]IZh",
  "]I^x[I]k\\IZo_I^~[I^|[I^l[IZj\\IZj]IZ}]I^n[I]m^IZh",'\0'};
char *V2;
int V3,V4;
    
main(){
  V4=0;
  while(V1[V4]){
    V2=V1[V4++];
    while(*V2){
      V3= *V2++-0x59;
      while(V3--)putchar(*V2-0x29);
      if(*V2==0x68)putchar('\n');
      *V2++;}
  }
}
