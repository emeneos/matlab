function OutputDouble = DummyFunction2doubles(InputDouble01, InputDouble02)
  
%#codegen
% Check input types
  assert(isa(InputDouble01, 'double'), 'InputDouble01 must be a double');
  assert(isa(InputDouble02, 'double'), 'InputDouble02 must be a double');

  % Compute the output
  OutputDouble = InputDouble01 + InputDouble02 + 4;
end