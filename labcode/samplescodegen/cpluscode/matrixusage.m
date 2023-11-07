function mtr = matrixusage(number)
    %#codegen
    S=struct('x',{0},'y',{0} );
    %mtr = zeros(2,2);
    coder.cinclude("create_2x2_matrix.h");
    S = coder.ceval("create_2x2_matrix",number);
    mtr = S;
end
