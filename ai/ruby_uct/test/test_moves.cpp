#include "common.h"
#include "test_moves.h"

#include "board_tanbo.h"
#include "point_tanbo.h"
#include "root_tanbo.h"

#include <boost/shared_ptr.hpp>

void MovesTest::test_turn_change() {
  boost::shared_ptr<PointTanbo> point = gameboard->at(0, 1);
  CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_1) );
  
  // Should be WHITE's move after single BLACK move at 0, 1
  MoveTanbo move = MoveTanbo(PLAYER_1, 0, 1, gameboard->at(0, 0));
  gameboard->play_move(move);
  CPPUNIT_ASSERT( PLAYER_2 == gameboard->get_turn() );
  
  
  point = gameboard->at(7, 12);
  CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_2) );
  
  // Should be BLACK's move after WHITE move at 7, 12
  move = MoveTanbo(PLAYER_2, 7, 12, gameboard->at(6, 12));
  gameboard->play_move(move);
  CPPUNIT_ASSERT( PLAYER_1 == gameboard->get_turn() );
}

void MovesTest::test_move_effects() {
  //Check that this is a valid move for BLACK
  boost::shared_ptr<PointTanbo> point = gameboard->at(11, 12);
  CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_1) );
  
  //Make the move and assert that the point has been changed to BLACK
  MoveTanbo move = MoveTanbo(PLAYER_1, 11, 12, gameboard->at(12, 12));
  gameboard->play_move(move);
  CPPUNIT_ASSERT( PLAYER_1 == point->color );
  
  //The point should no longer be a valid move for either player
  CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
  CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
  
  // All of these moves should now be valid
  boost::shared_ptr<PointTanbo> next_move = gameboard->at(10, 12);
  CPPUNIT_ASSERT( gameboard->is_move_valid(*next_move, PLAYER_1) );
  next_move = gameboard->at(11, 13);
  CPPUNIT_ASSERT( gameboard->is_move_valid(*next_move, PLAYER_1) );
  next_move = gameboard->at(11, 11);
  CPPUNIT_ASSERT( gameboard->is_move_valid(*next_move, PLAYER_1) );
  
  gameboard->play_random_move(PLAYER_1);
}