function [mtrx] = matrixOpsIntegrated(in1)
%#codegen
% for code generation, preinitialize the output variable
% data type, size, and complexity 
s = struct('beta',(zeros(2,2,'double')));
% generate an include in the C code
coder.cinclude('create_2x2_matrix.h');
% evaluate the C function
s = coder.ceval('create_2x2_matrix', in1); 
mtrx = s;
end
