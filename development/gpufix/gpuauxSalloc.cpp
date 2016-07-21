/* Store a single precision matrix on the GPU.
 *
 * Yoel Shkolnisky, July 2016.
 */

/* Compile using
 * mex gpuauxSalloc.cpp -O -I/usr/local/cuda/targets/x86_64-linux/include/ -L/usr/local/cuda/targets/x86_64-linux/lib/ -lcublas
 */

#include <stdint.h>
#include <inttypes.h>
#include "mex.h"
#include "cublas.h"

#define DEBUG

void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    int M,N;    // Dimensions of the input matrix.
    float *A;   // Data elements of the input array.
    float *gA;  // Pointer to the GPU copy of the data of A.
    uint64_t *gptr; // Address of the GPU-allocated array.
    cublasStatus retStatus;
    
    if (nrhs != 1) {
        mexErrMsgTxt("gpuauxSalloc requires 1 input arguments (matrix A)");
    } else if (nlhs != 1) {
        mexErrMsgTxt("gpuauxSalloc requires 1 output argument");
    }
    
    A = (float*) mxGetPr(prhs[0]);  // Get data of A.
    M = mxGetM(prhs[0]);   // Get number of rows of A.
    N = mxGetN(prhs[0]);   // Get number of columns of A.
        
    #ifdef DEBUG
    mexPrintf("M=%d  N=%d\n",M,N);
    #endif
    
    /* ALLOCATE SPACE ON THE GPU */
    cublasAlloc (M*N, sizeof(float), (void**)&gA);
    // test for error
    retStatus = cublasGetError ();   
    if (retStatus != CUBLAS_STATUS_SUCCESS) {
        mexPrintf("CUBLAS: an error occured in cublasAlloc\n");
    } 
    #ifdef DEBUG
    else {
        mexPrintf("CUBLAS: cublasAlloc worked\n");
    }
    #endif
    
    retStatus = cublasSetMatrix (M, N, sizeof(float),
            A, M, (void*)gA, M);
    
    if (retStatus != CUBLAS_STATUS_SUCCESS) {
        mexPrintf("CUBLAS: an error occured in cublasSetMatrix\n");
    } 
    #ifdef DEBUG
    else {
        mexPrintf("CUBLAS: cublasSetMatrix worked\n");
    }
    #endif
        
    plhs[0] = mxCreateNumericMatrix(1, 1, mxUINT64_CLASS, mxREAL);
    gptr=(uint64_t*) mxGetPr(plhs[0]);
    *gptr=(uint64_t) gA;
    
    cublasShutdown();
    
    #ifdef DEBUG
    mexPrintf("GPU array allocated at address %" PRIu64 "\n", (uint64_t)gA);
    #endif
}

