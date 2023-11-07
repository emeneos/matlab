function y = passStruct(x)
%#codegen
coder.cinclude('Foo.h');
s.f = x;
coder.cstructname(s, 'wrapperStruct_T');
y = 10;
y = coder.ceval('WrapFoo', coder.ref(s));
end