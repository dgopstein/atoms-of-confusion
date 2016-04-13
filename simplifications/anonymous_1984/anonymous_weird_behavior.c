    #include <stdio.h>
    char* V1 = "hello, world!\n";

    void F1(/*char * */A1){
      printf("%p %u %u %u\n", V1 - A1, V1 - A1 == 0, V1 == A1, sizeof(A1));
    }
    
    int main(){
      F1(V1);
      return 0;
    }
    
