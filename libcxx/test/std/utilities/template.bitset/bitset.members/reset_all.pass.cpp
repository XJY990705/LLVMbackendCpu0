//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// bitset<N>& reset(); // constexpr since C++23

#include <bitset>
#include <cassert>
#include <cstddef>

#include "test_macros.h"

template <std::size_t N>
TEST_CONSTEXPR_CXX23 void test_reset_all() {
    std::bitset<N> v;
    v.set();
    v.reset();
    for (std::size_t i = 0; i < v.size(); ++i)
        assert(!v[i]);
}

TEST_CONSTEXPR_CXX23 bool test() {
  test_reset_all<0>();
  test_reset_all<1>();
  test_reset_all<31>();
  test_reset_all<32>();
  test_reset_all<33>();
  test_reset_all<63>();
  test_reset_all<64>();
  test_reset_all<65>();
  test_reset_all<1000>();

  return true;
}

int main(int, char**) {
  test();
#if TEST_STD_VER > 20
  static_assert(test());
#endif

  return 0;
}
