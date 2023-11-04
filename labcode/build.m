function build(target)

    entryPoint = 'foo';
    %example input
    a = 1;
    b = 3;
    output = 0;


    %configuration object

    cfg = coder.config(target);

    %custom source file

    cfg.CustomSource = 'sumfunction.cpp';

    %Custom source code

    cfg.CustomSourceCode = ['#include "sumfunction.h"'];
    cfg.CustomInclude = 'D:\uvalladolid\matlab\labcode';
    %generate and launch report
    cfg.GenerateReport = true;
    cfg.LaunchReport = true;

    %generate code
        codegen(entryPoint,'-args',{a,b},'-config', cfg);

end