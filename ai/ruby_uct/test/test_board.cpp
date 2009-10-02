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

#include "common.h"
#include "test_board.h"

#include <boost/shared_ptr.hpp>

#include <iostream>

void BoardTest::test_black_starts() {
  CPPUNIT_ASSERT( PLAYER_1 == gameboard->get_turn() );
}

void BoardTest::test_right_root_number() {
  CPPUNIT_ASSERT( 16 == gameboard->roots.size() ); 
}

void BoardTest::test_start_position() {
    // Starting positions for PLAYER_2 (white)
    boost::shared_ptr<PointTanbo> point = gameboard->at(6, 0); 
    CPPUNIT_ASSERT( PLAYER_2 == point->color );
    point = gameboard->at(18, 0);
    CPPUNIT_ASSERT( PLAYER_2 == point->color );
    point = gameboard->at(0, 6);
    CPPUNIT_ASSERT( PLAYER_2 == point->color );
    point = gameboard->at(12, 6);
    CPPUNIT_ASSERT( PLAYER_2 == point->color );
    point = gameboard->at(6, 12);
    CPPUNIT_ASSERT( PLAYER_2 == point->color );
    point = gameboard->at(18, 12);
    CPPUNIT_ASSERT( PLAYER_2 == point->color );
    point = gameboard->at(0, 18);
    CPPUNIT_ASSERT( PLAYER_2 == point->color );
    point = gameboard->at(12, 18);
    CPPUNIT_ASSERT( PLAYER_2 == point->color );
             
    // Starting positions for PLAYER_1 (black)
    point = gameboard->at(0, 0);
    CPPUNIT_ASSERT( PLAYER_1 == point->color );
    point = gameboard->at(12, 0);
    CPPUNIT_ASSERT( PLAYER_1 == point->color );
    point = gameboard->at(6, 6);
    CPPUNIT_ASSERT( PLAYER_1 == point->color );
    point = gameboard->at(18, 6);
    CPPUNIT_ASSERT( PLAYER_1 == point->color );
    point = gameboard->at(12, 12);
    CPPUNIT_ASSERT( PLAYER_1 == point->color );
    point = gameboard->at(18, 18);
    CPPUNIT_ASSERT( PLAYER_1 == point->color );
    point = gameboard->at(6, 18);
    CPPUNIT_ASSERT( PLAYER_1 == point->color );
    point = gameboard->at(0, 12);
    CPPUNIT_ASSERT( PLAYER_1 == point->color );

   // Empty points (NOT_PLAYED)
    for(int x=0; x<19; x++) {
      for(int y=0; y<19; y++) {
       if( x%6 != 0 || y%6 != 0) {
         point = gameboard->at(x, y);
         CPPUNIT_ASSERT( NOT_PLAYED == point->color );
       }
     }
   }
}