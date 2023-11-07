#include "Foo.h"
double WrapFoo(wrapperStruct_T *s)
{
    return Foo(s->f);
}

double Foo(double *x)
{
    return 2.0*x[0];
}