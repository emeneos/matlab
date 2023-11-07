#ifndef MEXGENERATESHMATRIX_H
#define MEXGENERATESHMATRIX_H

#include "mex.h"
#include "../mathsmex/sphericalHarmonics.h"
#include "../mathsmex/mexToMathsTypes.h"

/* The gateway function */
void mexGenerateSHMatrix(int nlhs, mxArray *plhs[],
                          int nrhs, const mxArray *prhs[]);

#endif /* MEXGENERATESHMATRIX_H */