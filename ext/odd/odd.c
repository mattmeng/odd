#include "odd.h"

VALUE rb_mOdd;

void
Init_odd(void)
{
  rb_mOdd = rb_define_module("Odd");
}
