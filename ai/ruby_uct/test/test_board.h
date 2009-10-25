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
  CPPUNIT_TEST_SUITE_END();

public:
  void test_black_starts();
  void test_right_root_number();
  void test_start_position();
  void test_root_points();
  void test_valid_move();
  void test_no_invalid_move();
};

// class BoardTest < Test::Unit::TestCase
//   include RubyTanboTest
// 
// 
// 
// 
//   
//   def test_root_liberties
//     root_points = [
//       @gameboard[6 ,0 ], @gameboard[18,0 ],
//       @gameboard[0 ,6 ], @gameboard[12,6 ],
//       @gameboard[6 ,12], @gameboard[18,12],
//       @gameboard[0 ,18], @gameboard[12,18],
//       @gameboard[0 ,0 ], @gameboard[12,0 ],
//       @gameboard[6 ,6 ], @gameboard[18,6 ],
//       @gameboard[12,12], @gameboard[18,18],
//       @gameboard[6 ,18], @gameboard[0 ,12]
//     ]
//     
//     for point in root_points
//       for root in @gameboard.roots
//         if root.points.include?(point)
//           point.bounded_neighbors.each do |lib|
//             assert root.liberties.include?(lib), "Root: " + root.inspect + " should have had liberty: " + lib.inspect
//           end
//         end
//       end
//     end
//   end
//   
//   def test_deep_copy
//     orig_board = @gameboard
//     copy_board = orig_board.deep_copy
//     
//     orig_point = @gameboard[5, 12]
//     copy_point = copy_board[5, 12]
//     
//     assert !(orig_point.object_id == copy_point.object_id), "Copied points should not have same object_id"
//     assert (orig_point.color == copy_point.color), "Color should be the same for copied points"
//     assert (orig_point.root == copy_point.root), "Should have same (null) root"
//     
//     orig_point = @gameboard[0, 12]
//     copy_point = copy_board[0, 12]
//     
//     assert !(orig_point.object_id == copy_point.object_id), "Copied points should not have same object_id"
//     assert (orig_point.color == copy_point.color), "Color should be the same for copied points"
//     assert !(orig_point.root == copy_point.root), "Copied points should have unique roots"
//   end
//   
// end
#endif /* end of include guard: __TEST_BOARD__ */