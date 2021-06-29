#include <stdio.h>

int func(int X,int Y){
int Z;
int tempi;

tempi=X;

tempi++;

while(tempi){
int tempii;

tempii=X;

while(tempii){
Y++;

tempi=0;

tempii=0;

}

while(tempi){
Z++;

tempi=0;

}

}


 return Z; 
 }

int main(){
func(int X,int Y);

 return 0;
}