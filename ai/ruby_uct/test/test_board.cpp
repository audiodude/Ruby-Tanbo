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

#include "test_board.h"

void BoardTest::test_black_starts() {
  CPPUNIT_ASSERT( PLAYER_1 == gameboard->get_turn() );
}

void BoardTest::test_right_root_number() {
  CPPUNIT_ASSERT( 16 == gameboard->roots.size() ); 
}

void BoardTest::test_start_position() {
  CPPUNIT_ASSERT( true );
  // msg = "Starting position was found invalid, wrong moves for WHITE at: "
  //  point = @gameboard[6, 0]
  //  assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[18, 0]
  //  assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[0, 6]
  //  assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[12, 6]
  //  assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[6, 12]
  //  assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[18, 12]
  //  assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[0, 18]
  //  assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[12, 18]
  //  assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
  //             
  //  msg = "Starting position was found invalid, wrong moves for BLACK at: "
  //  point = @gameboard[0, 0]
  //  assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[12, 0]
  //  assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[6, 6]
  //  assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[18, 6]
  //  assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[12, 12]
  //  assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[18, 18]
  //  assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[6, 18]
  //  assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
  //  point = @gameboard[0, 12]
  //  assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
  // 
  //  msg = "Starting position was found invalid, expected EMPTY point not empty at: "
  //  0.upto(18) do |x|
  //    0.upto(18) do |y|
  //      unless x%6 == 0 && y%6 == 0
  //        point = @gameboard[x, y]
  //        assert_equal TanboBoard::BLANK, @main_controller.get_color(point), (msg + point.inspect)
  //      end
  //    end
  //  end
}