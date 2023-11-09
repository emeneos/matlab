function build(target)
%build mex or build lib


    entryPoint = 'refFunction';

    %configuration object

    cfg = coder.config(target);

    cfg.TargetLang = 'C++';
    %custom source file

    cfg.CustomSource = 'init_array.c';

    %Custom source code

    cfg.CustomSourceCode = '#include "init_array.h"';
    %cfg.CustomInclude = 'D:\uvalladolid\matlab\labcode\codebyreference';
    %generate and launch report
    cfg.GenerateReport = true;
    cfg.LaunchReport = true;

    %generate code
        codegen(entryPoint,'-config', cfg);

end