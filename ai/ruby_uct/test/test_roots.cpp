#include "test_roots.h"

#include <vector>
void RootsTest::test_simple_white_bounded() {
  std::vector< boost::shared_ptr<PointTanbo> > seq = std::vector< boost::shared_ptr<PointTanbo> >();
  seq.reserve(17);
  seq.push_back(gameboard->at(5,  6)); seq.push_back(gameboard->at(5, 12)); seq.push_back(gameboard->at(4, 6));
  seq.push_back(gameboard->at(4, 12)); seq.push_back(gameboard->at(3,  6)); seq.push_back(gameboard->at(3, 12));
  seq.push_back(gameboard->at(2,  6)); seq.push_back(gameboard->at(2, 12)); seq.push_back(gameboard->at(1, 6));
  seq.push_back(gameboard->at(1, 12)); seq.push_back(gameboard->at(1,  5)); seq.push_back(gameboard->at(1, 11));
  seq.push_back(gameboard->at(0,  5)); seq.push_back(gameboard->at(0, 11)); seq.push_back(gameboard->at(1,  7));
  seq.push_back(gameboard->at(1, 13)); seq.push_back(gameboard->at(0, 7));
  
  do_move_sequence(seq, PLAYER_1);
  
  CPPUNIT_ASSERT( PLAYER_2 == gameboard->turn );
  CPPUNIT_ASSERT( NOT_PLAYED == gameboard->at(0, 6)->color);

  std::vector< boost::shared_ptr<PointTanbo> > black_points = std::vector< boost::shared_ptr<PointTanbo> >();
  black_points.push_back(gameboard->at(5, 6)); black_points.push_back(gameboard->at(4, 6));
  black_points.push_back(gameboard->at(3, 6)); black_points.push_back(gameboard->at(2, 6));
  black_points.push_back(gameboard->at(1, 6)); black_points.push_back(gameboard->at(1, 5));
  black_points.push_back(gameboard->at(0, 5)); black_points.push_back(gameboard->at(1, 7));
  black_points.push_back(gameboard->at(0, 7));
  for(std::vector < boost::shared_ptr<PointTanbo> >::iterator itr = black_points.begin(); itr != black_points.end(); ++itr) {
    boost::shared_ptr<PointTanbo> point = (*itr);
    CPPUNIT_ASSERT( PLAYER_1 == point->color );
  }

  std::vector< boost::shared_ptr<PointTanbo> > white_points = std::vector< boost::shared_ptr<PointTanbo> >();
  white_points.push_back(gameboard->at(5, 12)); white_points.push_back(gameboard->at(4, 12));
  white_points.push_back(gameboard->at(3, 12)); white_points.push_back(gameboard->at(2, 12));
  white_points.push_back(gameboard->at(1, 12)); white_points.push_back(gameboard->at(1, 11));
  white_points.push_back(gameboard->at(0, 11)); white_points.push_back(gameboard->at(1, 13));
  for(std::vector < boost::shared_ptr<PointTanbo> >::iterator itr = white_points.begin(); itr != white_points.end(); ++itr) {
    boost::shared_ptr<PointTanbo> point = (*itr);
    CPPUNIT_ASSERT( PLAYER_2 == point->color );
  }
}

void RootsTest::test_simple_white_two_bounded() {
  std::vector< boost::shared_ptr<PointTanbo> > seq = std::vector< boost::shared_ptr<PointTanbo> >();
  seq.reserve(17);
  seq.push_back(gameboard->at(5,  6)); seq.push_back(gameboard->at( 0,  5)); seq.push_back(gameboard->at(4 , 6));
  seq.push_back(gameboard->at(5,  0)); seq.push_back(gameboard->at( 3,  6)); seq.push_back(gameboard->at(11, 6));
  seq.push_back(gameboard->at(2,  6)); seq.push_back(gameboard->at(13, 18)); seq.push_back(gameboard->at(1, 6));
  seq.push_back(gameboard->at(1,  5)); seq.push_back(gameboard->at(17,  0)); seq.push_back(gameboard->at(1, 4));
  seq.push_back(gameboard->at(7,  0)); seq.push_back(gameboard->at( 0,  4));
  
  
  do_move_sequence(seq, PLAYER_1);

  CPPUNIT_ASSERT( PLAYER_2 == gameboard->turn );
  CPPUNIT_ASSERT( NOT_PLAYED == gameboard->at(0, 6)->color);
  CPPUNIT_ASSERT( NOT_PLAYED == gameboard->at(0, 5)->color);
  
  std::vector< boost::shared_ptr<PointTanbo> > black_points = std::vector< boost::shared_ptr<PointTanbo> >();
  black_points.push_back(gameboard->at(5, 6)); black_points.push_back(gameboard->at(4, 6));
  black_points.push_back(gameboard->at(3, 6)); black_points.push_back(gameboard->at(2, 6));
  black_points.push_back(gameboard->at(1, 6)); black_points.push_back(gameboard->at(1, 5));
  black_points.push_back(gameboard->at(1, 4)); black_points.push_back(gameboard->at(1, 7));
  black_points.push_back(gameboard->at(0, 4)); black_points.push_back(gameboard->at(0, 7));
  for(std::vector < boost::shared_ptr<PointTanbo> >::iterator itr = black_points.begin(); itr != black_points.end(); ++itr) {
    boost::shared_ptr<PointTanbo> point = (*itr);
    CPPUNIT_ASSERT( PLAYER_1 == point->color );
  }
  
  std::vector< boost::shared_ptr<PointTanbo> > white_points = std::vector< boost::shared_ptr<PointTanbo> >();
  white_points.push_back(gameboard->at(5, 0)); white_points.push_back(gameboard->at(11, 6));
  white_points.push_back(gameboard->at(13, 18)); white_points.push_back(gameboard->at(0, 17));
  white_points.push_back(gameboard->at(5, 12)); white_points.push_back(gameboard->at(17, 12));
  white_points.push_back(gameboard->at(17, 12)); white_points.push_back(gameboard->at(17, 0));
  white_points.push_back(gameboard->at(7, 0));
  for(std::vector < boost::shared_ptr<PointTanbo> >::iterator itr = white_points.begin(); itr != white_points.end(); ++itr) {
    boost::shared_ptr<PointTanbo> point = (*itr);
    CPPUNIT_ASSERT( PLAYER_2 == point->color );
  }
}