#include "../../include/boost/outcome.hpp"

extern BOOSTLITE_NOINLINE void test1()
{
  using namespace boost::outcome;
  outcome<int> m;
}
extern BOOSTLITE_NOINLINE void test2()
{
}

int main(void)
{
  test1();
  test2();
  return 0;
}
