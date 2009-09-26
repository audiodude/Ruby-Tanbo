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
  CPPUNIT_TEST( test_black_starts );
  CPPUNIT_TEST_SUITE_END();

public:
  void test_black_starts();
};

// class BoardTest < Test::Unit::TestCase
//   include RubyTanboTest
// 
//   def test_start_position
//     msg = "Starting position was found invalid, wrong moves for WHITE at: "
//     point = @gameboard[6, 0]
//     assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[18, 0]
//     assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[0, 6]
//     assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[12, 6]
//     assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[6, 12]
//     assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[18, 12]
//     assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[0, 18]
//     assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[12, 18]
//     assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
//                
//     msg = "Starting position was found invalid, wrong moves for BLACK at: "
//     point = @gameboard[0, 0]
//     assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[12, 0]
//     assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[6, 6]
//     assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[18, 6]
//     assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[12, 12]
//     assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[18, 18]
//     assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[6, 18]
//     assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
//     point = @gameboard[0, 12]
//     assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
//   
//     msg = "Starting position was found invalid, expected EMPTY point not empty at: "
//     0.upto(18) do |x|
//       0.upto(18) do |y|
//         unless x%6 == 0 && y%6 == 0
//           point = @gameboard[x, y]
//           assert_equal TanboBoard::BLANK, @main_controller.get_color(point), (msg + point.inspect)
//         end
//       end
//     end
//   end
// 
// 
//   def test_valid_move
//     msg = "Valid WHITE starting move reported as invalid at: "
//     point = @gameboard[0, 7]
//     assert @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[0, 5]
//     assert @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[1, 18]
//     assert @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[0, 17]
//     assert @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[5, 12]
//     assert @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[6, 13]
//     assert @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//   
//     msg = "Valid BLACK starting move reported as invalid at: "
//     point = @gameboard[0, 1]
//     assert @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     point = @gameboard[1, 0]
//     assert @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     point = @gameboard[17, 18]
//     assert @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     point = @gameboard[18, 17]
//     assert @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     point = @gameboard[7, 6]
//     assert @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     point = @gameboard[6, 7]
//     assert @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//   end
// 
//   def test_no_invalid_move
//     msg = "Invalid move from starting position reported as valid at: "
//     point = @gameboard[-1,-1]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[19,19]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[-1,19]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[19,-1]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[-532,1087]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[7734,-1985]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[3,4]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[4,4]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[5,4]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[9,0]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[0,10]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[10,0]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[0,18]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[6,6]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[10,18]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//     point = @gameboard[18,10]
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
//   end
//   
//   def test_right_root_number
//     assert_equal 16, @gameboard.roots.size
//   end
//   
//   def test_root_points  
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
//       found = []
//       for root in @gameboard.roots
//         found << root if root.points.include?(point)
//       end
//       
//       assert !found.empty?, "Couldn't find point in any root: " + point.inspect
//       assert_equal 1, found.size, "More than one root had point: " + point.inspect
//     end
//   end
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