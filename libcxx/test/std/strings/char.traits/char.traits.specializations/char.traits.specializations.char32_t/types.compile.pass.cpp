//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <string>

// template<> struct char_traits<char32_t>

// using char_type           = char32_t;
// using int_type            = uint_least32_t;
// using off_type            = streamoff;
// using pos_type            = u32streampos;
// using state_type          = mbstate_t;
// using comparison_category = strong_ordering;

#include <string>
#include <type_traits>
#include <cstdint>

#include "test_macros.h"

static_assert(std::is_same<std::char_traits<char32_t>::char_type, char32_t>::value, "");
static_assert(std::is_same<std::char_traits<char32_t>::int_type, std::uint_least32_t>::value, "");
static_assert(std::is_same<std::char_traits<char32_t>::off_type, std::streamoff>::value, "");
static_assert(std::is_same<std::char_traits<char32_t>::pos_type, std::u32streampos>::value, "");
static_assert(std::is_same<std::char_traits<char32_t>::state_type, std::mbstate_t>::value, "");
#if TEST_STD_VER > 17
static_assert(std::is_same_v<std::char_traits<char32_t>::comparison_category, std::strong_ordering>);
#endif
