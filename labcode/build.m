function build(target)
%build mex or build lib


    entryPoint = 'signal2sh';

    %configuration object

    cfg = coder.config(target);

    cfg.TargetLang = 'C++';
    %custom source file

    cfg.CustomSource = 'mexGenerateSHMatrix.cpp';

    %Custom source code

    cfg.CustomSourceCode = '#include "mexGenerateSHMatrix.h"';
    cfg.CustomInclude = 'D:\uvalladolid\matlab\labcoded';
    %generate and launch report
    cfg.GenerateReport = true;
    cfg.LaunchReport = true;




    load test_data.mat; 
    signal = atti( :, :, :, abs(bi-1000)<100 ); 
    gi = gi( abs(bi-1000)<100, : ); 
     
    [M,N,P,G] = size(signal); 
    options = create_signal2sh_options(M, N, P); 
    options.mask=mask; 
    %generate code
    codegen(entryPoint,'-args',{signal, gi, options},'-config', cfg);

end