#include <stdlib.h>
#include "../common/book.h"

#define N 100


////////////////////////////////////////
__global__ void cuda_add(int * a, int * b, int * c){

  int tid = blockIdx.x;
  if(tid<N){
    
    a[tid] = b[tid] + c[tid];

  }

}


////////////////////////////////////////
void fill_vectors(int * a, int * b, int * c){

  for(int i=0; i<=N; i++){

    a[i] = 0;
    b[i] = i*i;
    c[i] = -i;

  }

}


////////////////////////////////////////
int main(void){

  int a[N], b[N], c[N];
  int * deva, * devb, * devc;

  // allocating ON-DEVICE memory using cudaMalloc(...)
  HANDLE_ERROR( cudaMalloc( (void**)&deva, N * sizeof(int) ) );
  HANDLE_ERROR( cudaMalloc( (void**)&devb, N * sizeof(int) ) );
  HANDLE_ERROR( cudaMalloc( (void**)&devc, N * sizeof(int) ) );

  // fill vectors with numbers
  int * pa = &a[0];
  int * pb = &b[0];
  int * pc = &c[0];
  fill_vectors(pa, pb, pc);

  // copy HOST -> DEVICE using cudaMemcpy(...)
  HANDLE_ERROR(cudaMemcpy(devb, b, N * sizeof(int), cudaMemcpyHostToDevice));
  HANDLE_ERROR(cudaMemcpy(devc, c, N * sizeof(int), cudaMemcpyHostToDevice));

  // perform DEVICE operation
  cuda_add<<<N,1>>>(deva, devb, devc);

  // return result by copying from DEVICE -> HOST
  HANDLE_ERROR(cudaMemcpy(a, deva, N * sizeof(int), cudaMemcpyDeviceToHost));

  // print final results
  for(int i=0; i<N; i++){

    printf("[%d] + [%d] = [%d] \n", b[i], c[i], a[i]);

  }

  cudaFree(deva);
  cudaFree(devb);
  cudaFree(devc);

  return 0;

}
