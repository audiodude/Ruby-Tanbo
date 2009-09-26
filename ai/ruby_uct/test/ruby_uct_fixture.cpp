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

#include "ruby_uct_fixture.h"
#include "test_board.h"
#include "board.h"

#include <cppunit/TestCase.h>
#include <cppunit/TestSuite.h>
#include <cppunit/TestCaller.h>
#include <cppunit/TestRunner.h>
#include <cppunit/ui/text/TestRunner.h>

#include <iostream>
// 
// void RubyTanboTest::setUp() {
//   std::cout << "Creating board";
//   gameboard = new BoardTanbo();
// }
// 
// void RubyTanboTest::tearDown() {
//   std::cout << "Deleting board";
//   delete gameboard;
// }

int main( int argc, char **argv) {
  CppUnit::TextUi::TestRunner runner;
  runner.addTest( BoardTest::suite() );
  runner.run();
  return 0;
}
