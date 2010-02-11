// Author: Travis Briggs, briggs.travis (at) gmail.com
// ===================================================
// Copyright (C) 2009 Travis Briggs
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. See the COPYING file. If not, see
// <http://www.gnu.org/licenses/>.

#ifndef __TEST_BOARD__
#define __TEST_BOARD__

#include "ruby_uct_fixture.h"

#include <cppunit/TestCase.h>
#include <cppunit/TestSuite.h>
#include <cppunit/TestCaller.h>
#include <cppunit/TestRunner.h>
#include <cppunit/extensions/HelperMacros.h>

class BoardTest : public RubyTanboTest {
  CPPUNIT_TEST_SUITE( BoardTest );
  CPPUNIT_TEST( test_start_position );
  CPPUNIT_TEST( test_black_starts );
  CPPUNIT_TEST( test_right_root_number );
  CPPUNIT_TEST( test_root_points );
  CPPUNIT_TEST( test_valid_move );
  CPPUNIT_TEST( test_no_invalid_move );
  CPPUNIT_TEST( test_root_liberties );
  CPPUNIT_TEST_SUITE_END();

public:
  void test_black_starts();
  void test_right_root_number();
  void test_start_position();
  void test_root_points();
  void test_valid_move();
  void test_no_invalid_move();
  void test_root_liberties();
};
#endif /* end of include guard: __TEST_BOARD__ */