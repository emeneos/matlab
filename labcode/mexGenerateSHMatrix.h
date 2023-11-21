#ifndef MEXGENERATESHMATRIX_H
#define MEXGENERATESHMATRIX_H

#include "mex.h"
/*#include <D:/uvalladolid/DMRIMatlab/mexcode/mathsmex/>*/
#include "D:/uvalladolid/DMRIMatlab/mexcode/mathsmex/sphericalHarmonics.h"
#include "D:/uvalladolid/DMRIMatlab/mexcode/mathsmex/mexToMathsTypes.h"

/* The gateway function */
void mexGenerateSHMatrix(int nlhs, mxArray *plhs[],
                          int nrhs, const mxArray *prhs[]);

#endif /* MEXGENERATESHMATRIX_H */