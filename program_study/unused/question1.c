#include "stdio.h"
#define M1 char
#define M2 putchar
#define M3 while
#define M4 int
#define M5 main
#define M6 if
#define M7 '\n'
M1 *V1 [] = {
"[h",
'\0'};
M1 *V2; M4 V3,V4,V5=0x59,V6=0x29,
V7=0x68;M5(){V4=0;M3(V1[V4]){V2=V1[V4++];
M3(*V2){V3= *V2++-V5;M3(V3--)M2(*V2-V6);
M6(*V2==V7)M2(M7);*V2++;}}}
