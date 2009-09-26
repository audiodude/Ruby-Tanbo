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

#ifndef __TEST_MOVES__
#define __TEST_MOVES__

#include <cppunit/TestCase.h>
#include <cppunit/TestSuite.h>
#include <cppunit/TestCaller.h>
#include <cppunit/TestRunner.h>

// class MovesTest < Test::Unit::TestCase
//   include RubyTanboTest
// 
//   def test_turn_change
//     msg = "Should be WHITE's move after single black move at: "
//     point = @gameboard[0, 1]
//     assert @gameboard.valid_move?(point, TanboBoard::BLACK), ("Expected valid move reported invalid at: " + point.inspect)
//     @gameboard.make_move(point, @gameboard[0, 0])
//     assert_equal TanboBoard::WHITE, @gameboard.turn, (msg + point.inspect)
//   
//   
//     msg = "Should be BLACK's move after WHITE move at: "
//     point = @gameboard[7, 12]
//     assert @gameboard.valid_move?(point, TanboBoard::WHITE), ("Expected valid move reported invalid at: " + point.inspect)
//     @gameboard.make_move(point, @gameboard[6, 12])
//     assert_equal TanboBoard::BLACK, @gameboard.turn, (msg + point.inspect)
//   end
// 
//   def test_move_effects
//     point = @gameboard[11, 12]
//     assert @gameboard.valid_move?(point), ("Expected BLACK valid move reported invalid at: " + point.inspect)
//     @gameboard.make_move(point, @gameboard[12, 12])
//     assert_equal TanboBoard::BLACK, @main_controller.get_color(point), ("Point should be BLACK after single black move at: " + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), ("Move reported valid for BLACK after already being made at: " + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), ("Move reported valid for WHITE after already being made at: " + point.inspect)
//     next_move = @gameboard[10, 12]
//     assert @gameboard.valid_move?(next_move, TanboBoard::BLACK), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
//     next_move = @gameboard[11, 13]
//     assert @gameboard.valid_move?(next_move, TanboBoard::BLACK), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
//     next_move = @gameboard[11, 11]
//     assert @gameboard.valid_move?(next_move, TanboBoard::BLACK), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
//   
//   
//     point = @gameboard[0, 5]
//     assert @gameboard.valid_move?(point), ("Expected WHITE valid move reported invalid at: " + point.inspect)
//     @gameboard.make_move(point, @gameboard[0, 6])
//     assert_equal TanboBoard::WHITE, @main_controller.get_color(point), ("Point should be WHITE after single black move at: " + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::BLACK), ("Move reported valid for BLACK after already being made at: " + point.inspect)
//     assert ! @gameboard.valid_move?(point, TanboBoard::WHITE), ("Move reported valid for WHITE after already being made at: " + point.inspect)
//     next_move = @gameboard[0, 4]
//     assert @gameboard.valid_move?(next_move, TanboBoard::WHITE), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
//     next_move = @gameboard[1, 5]
//     assert @gameboard.valid_move?(next_move, TanboBoard::WHITE), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
//     next_move = @gameboard[-1, 5]
//     assert ! @gameboard.valid_move?(next_move, TanboBoard::WHITE), ("Making move at: " + point.inspect + " should *not* enable move at: " + next_move.inspect)
//   end
// end
#endif /* end of include guard: __TEST_MOVES__ */
