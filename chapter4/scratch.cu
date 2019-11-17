#include "../common/book.h"

int main(void){
    
    cudaDeviceProp prop;
    int count;
    cudaGetDeviceProperties(&prop, 0);
    printf("Prop NAME [%s] \n", prop.name);

    return 0;

}