function suma = varar(a, b, varargin)

  opt.L = 6;              optchk.L = [true,true];       % always 1x1 double
  opt.lambda = 0.006;     optchk.lambda = [true,true];  % always 1x1 double
  opt = custom_parse_inputs(opt, optchk, varargin{:});

  % Return a + b.
  suma= a + b;
end