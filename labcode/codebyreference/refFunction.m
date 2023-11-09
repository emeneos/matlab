function Y = refFunction()
    Y = zeros(5, 10);
    coder.cinclude("init_array.h");
    coder.ceval('init_array', coder.wref(Y), int32(numel(Y)));
end
