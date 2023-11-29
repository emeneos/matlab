/*==========================================================
 * mexGenerateSHMatrix.c
 *
 * Re-implements GenerateSHMatrix as a mex function
 *
 * This is a MEX-file for MATLAB.
 * Copyright 2022 - Antonio Tristán Vega
 *
 * nlhs: Number of left-hand side arguments (outputs).
 * plhs: Array of pointers to mxArray pointers for left-hand side arguments (outputs). plhs[0] is the SH matrix
 * nrhs: Number of right-hand side arguments (inputs).
 * prhs: Array of pointers to mxArray pointers for right-hand side arguments (inputs).
 * in this case prhs[0] is L (Order of Spherical Harmonics) and prhs[1] is G (Gradient Directions or Angular Coordinates)
 *========================================================*/





#include "mex.h"
/*include <D:/uvalladolid/DMRIMatlab/mexcode/mathsmex/>*/
#include "D:/uvalladolid/DMRIMatlab/mexcode/mathsmex/sphericalHarmonics.h" //perhaps I don't need this
#include "D:/uvalladolid/DMRIMatlab/mexcode/mathsmex/mexToMathsTypes.h"



 /* The gateway function */
void mexFunction(int nlhs, mxArray* plhs[],
    int nrhs, const mxArray* prhs[])
{

/* check for proper number of arguments */
    if (nrhs < 2) {
        mexErrMsgIdAndTxt("MyToolbox:mexGenerateSHMatrix:nrhs", "At least two inputs required.");
    }
    if (nlhs < 1) {
        mexErrMsgIdAndTxt("MyToolbox:mexGenerateSHMatrix:nlhs", "At least one output required.");
    }

   
    /* make sure the first input argument is scalar */
    if (!mxIsDouble(prhs[0]) ||
        mxIsComplex(prhs[0]) ||
        mxGetNumberOfElements(prhs[0]) != 1) {
        mexErrMsgIdAndTxt("MyToolbox:mexGenerateSHMatrix:notScalar", "Input L must be a scalar.");
    }
/* make sure the first argument is an integer */
    double Ld = mxGetScalar(prhs[0]);
    unsigned int L = (unsigned int)Ld;
    double err = Ld - L;
    err = (err > 0 ? err : -err);
    if (err > 10 * mxGetEps()) {
        mexErrMsgIdAndTxt("MyToolbox:mexGenerateSHMatrix:notInteger", "Input L must be an integer.");
    }

    /* make sure the first argument is even */
    if (L != 2 * (L / 2)) {
        mexErrMsgIdAndTxt("MyToolbox:mexGenerateSHMatrix:notEven", "Input L must be even.");
    }

    /* make sure the second input argument is type double */
    if (!mxIsDouble(prhs[1]) ||
        mxIsComplex(prhs[1])) {
        mexErrMsgIdAndTxt("MyToolbox:mexGenerateSHMatrix:notDouble", "Input G must be type double.");
    }

  /* make sure the second argument has proper size */
    size_t G = mxGetM(prhs[1]);
    size_t D = mxGetN(prhs[1]);
    if (D != 3) {
        mexErrMsgIdAndTxt("MyToolbox:mexGenerateSHMatrix:timesThree", "Input G must be Nx3.");
    }

    /* create a pointer to the real data in the input matrix  */
    mxDouble* Gi = mxGetDoubles(prhs[1]);
    plhs[0] = mxCreateDoubleMatrix(G, shmaths::getNumberOfEvenAssociatedLegendrePolynomials(L), mxREAL); 
    operationResult = sharedFunction(plhs[0],coder.ref(B),[],L, Gi,G);

    if (operationResult != 0){
        mexErrMsgIdAndTxt("MyToolbox: sharedFunctionMex", "operation not successful");
    }

}