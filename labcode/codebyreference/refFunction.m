function Y = refFunction(Y)
    coder.varsize('Y', [inf, inf], [1 1]);
    assert(isa(Y, 'double'));
    coder.cinclude("init_array.h");
    coder.ceval('init_array', coder.wref(Y), int32(numel(Y)));
end
