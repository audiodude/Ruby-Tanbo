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
#include "test_moves.h"
#include "test_roots.h"

#include "board_tanbo.h"
#include "common.h"
#include "board.h"

#include <cppunit/TestCase.h>
#include <cppunit/TestSuite.h>
#include <cppunit/TestCaller.h>
#include <cppunit/TestRunner.h>
#include <cppunit/ui/text/TestRunner.h>

#include <vector>

void RubyTanboTest::setUp() {
  gameboard = new BoardTanbo();
  gameboard->init();
  gameboard->starting_position();
}

void RubyTanboTest::tearDown() {
  delete gameboard;
}

void RubyTanboTest::do_move_sequence(std::vector< boost::shared_ptr<PointTanbo> > &moves, Token starting_color) {
  Token cur_color = starting_color;
  for (std::vector< boost::shared_ptr<PointTanbo> >::iterator itr = moves.begin(); itr != moves.end(); ++itr ) {
    boost::shared_ptr<PointTanbo> point = (*itr);
    boost::shared_ptr<PointTanbo> adj = gameboard->get_adjacent_point(*point, cur_color);
    CPPUNIT_ASSERT( adj );
    MoveTanbo move = MoveTanbo(cur_color, point->x, point->y, adj);
    gameboard->play_move(move);
    cur_color = other_player(cur_color);
  }
}

int main( int argc, char **argv) {
  CppUnit::TextUi::TestRunner runner;
  runner.addTest( BoardTest::suite() );
  runner.addTest( MovesTest::suite() );
  runner.addTest( RootsTest::suite() );
  runner.run();
  return 0;
}
