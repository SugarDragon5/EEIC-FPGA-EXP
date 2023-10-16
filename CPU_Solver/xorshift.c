#include<stdio.h>

unsigned int xor128() {
  static unsigned int x=123456789, y=362436069, z=521288629, w=88675123;
  unsigned int t=(x^(x<<11));
  x=y; y=z; z=w;
  return ( w=(w^(w>>19))^(t^(t>>8)) );
}

int main(){
    for(int i=0;i<100;i++){
        printf("%u\n",xor128());
    }
    return 0;
}