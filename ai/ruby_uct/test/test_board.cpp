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

#include "point_tanbo.h"
#include "root_tanbo.h"

#include <boost/shared_ptr.hpp>

#include <vector>
#include <list>
#include <algorithm>
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

void BoardTest::test_root_points() {
    std::vector< boost::shared_ptr<PointTanbo> > root_points = std::vector< boost::shared_ptr<PointTanbo> >();
    root_points.push_back(gameboard->at(6 ,0 ));
    root_points.push_back(gameboard->at(18,0 ));
    root_points.push_back(gameboard->at(0 ,6 ));
    root_points.push_back(gameboard->at(12,6 ));
    root_points.push_back(gameboard->at(6 ,12));
    root_points.push_back(gameboard->at(18,12));
    root_points.push_back(gameboard->at(0 ,18));
    root_points.push_back(gameboard->at(12,18));
    root_points.push_back(gameboard->at(0 ,0 ));
    root_points.push_back(gameboard->at(12,0 ));
    root_points.push_back(gameboard->at(6 ,6 ));
    root_points.push_back(gameboard->at(18,6 ));
    root_points.push_back(gameboard->at(12,12));
    root_points.push_back(gameboard->at(18,18));
    root_points.push_back(gameboard->at(6 ,18));
    root_points.push_back(gameboard->at(0 ,12));

    //Get the roots from the gameboard for iterating over
    std::vector < boost::shared_ptr<RootTanbo> > the_roots = gameboard->roots;

    for (std::vector< boost::shared_ptr<PointTanbo> >::iterator itr = root_points.begin(); itr != root_points.end(); ++itr ) {
        boost::shared_ptr<PointTanbo> point = (*itr);
        std::vector< boost::shared_ptr<PointTanbo> > found = std::vector< boost::shared_ptr<PointTanbo> >();
      
        //Find the point in the roots
        for( std::vector< boost::shared_ptr<RootTanbo> >::iterator itr = the_roots.begin(); itr != the_roots.end(); ++itr ) {
            boost::shared_ptr<RootTanbo> cur_root = (*itr);
            std::vector< boost::shared_ptr<PointTanbo> > cur_points = cur_root->points;
            
            std::vector< boost::shared_ptr<PointTanbo> >::iterator found_point, search_start;
            search_start = cur_points.begin();
            while(true) {
              found_point = std::find(search_start, cur_points.end(), point);
              if(found_point == cur_points.end()) {
                break;
              }
              found.push_back(*found_point);
              search_start = found_point + 1;
            }
        }
        
        //Should have found the point in exactly one root
        CPPUNIT_ASSERT( found.size() == 1 );
    }
}

void BoardTest::test_valid_move() {
    // Test PLAYER2 (white) starting moves
    boost::shared_ptr<PointTanbo> point = gameboard->at(0, 7);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(0, 5);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(1, 18);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(0, 17);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(5, 12);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(6, 13);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_2) );
  
    // Test PLAYER1 (black) starting moves
    point = gameboard->at(0, 1);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_1) );
    point = gameboard->at(1, 0);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_1) );
    point = gameboard->at(17, 18);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_1) );
    point = gameboard->at(18, 17);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_1) );
    point = gameboard->at(7, 6);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_1) );
    point = gameboard->at(6, 7);
    CPPUNIT_ASSERT( gameboard->is_move_valid(*point, PLAYER_1) );
}

void BoardTest::test_no_invalid_move() {  
    boost::shared_ptr<PointTanbo> point = gameboard->at(19,19);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(19,-1);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(3,4);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(4,4);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(5,4);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(9,0);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(0,10);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(10,0);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(0,18);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(6,6);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(10,18);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
    point = gameboard->at(18,10);
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_1) );
    CPPUNIT_ASSERT( ! gameboard->is_move_valid(*point, PLAYER_2) );
}

  void BoardTest::test_root_liberties() {
    std::vector< boost::shared_ptr<PointTanbo> > root_points = std::vector< boost::shared_ptr<PointTanbo> >();
    root_points.push_back(gameboard->at(6 ,0 ));
    root_points.push_back(gameboard->at(18,0 ));
    root_points.push_back(gameboard->at(0 ,6 ));
    root_points.push_back(gameboard->at(12,6 ));
    root_points.push_back(gameboard->at(6 ,12));
    root_points.push_back(gameboard->at(18,12));
    root_points.push_back(gameboard->at(0 ,18));
    root_points.push_back(gameboard->at(12,18));
    root_points.push_back(gameboard->at(0 ,0 ));
    root_points.push_back(gameboard->at(12,0 ));
    root_points.push_back(gameboard->at(6 ,6 ));
    root_points.push_back(gameboard->at(18,6 ));
    root_points.push_back(gameboard->at(12,12));
    root_points.push_back(gameboard->at(18,18));
    root_points.push_back(gameboard->at(6 ,18));
    root_points.push_back(gameboard->at(0 ,12));
    
    //Get the roots from the gameboard for iterating over
    std::vector < boost::shared_ptr<RootTanbo> > the_roots = gameboard->roots;

    for (std::vector< boost::shared_ptr<PointTanbo> >::iterator itr = root_points.begin(); itr != root_points.end(); ++itr ) {
        boost::shared_ptr<PointTanbo> point = (*itr);
        std::vector< boost::shared_ptr<PointTanbo> > found = std::vector< boost::shared_ptr<PointTanbo> >();
      
        //Find the point in the roots
        for( std::vector< boost::shared_ptr<RootTanbo> >::iterator itr = the_roots.begin(); itr != the_roots.end(); ++itr ) {
            boost::shared_ptr<RootTanbo> cur_root = (*itr);
            std::vector< boost::shared_ptr<PointTanbo> > cur_points = cur_root->points;
            
            std::vector< boost::shared_ptr<PointTanbo> >::iterator found_point, search_start;
            search_start = cur_points.begin();
            while(true) {
              found_point = std::find(search_start, cur_points.end(), point);
              if(found_point == cur_points.end()) {
                break;
              }
              search_start = found_point + 1;
              
              //We found the root we're looking for (contains point)
              PointTanboVecPtr bnd_neighbors = point->bounded_neighbors();
              for( std::vector< boost::shared_ptr<PointTanbo> >::iterator itr = bnd_neighbors->begin(); itr != bnd_neighbors->end(); ++itr ) {
                boost::shared_ptr<PointTanbo> cur_nbor = (*itr);
                bool lib_found = false;
                std::list< boost::shared_ptr<PointTanbo> > root_libs = cur_root->liberties;
                
                // std::cout << "****" << std::endl;
                // cur_root->print();
                // // for(std::list< boost::shared_ptr<PointTanbo> >::iterator itr_1 = root_libs.begin(); itr_1 != root_libs.end(); ++itr_1) {
                // //   (*(*itr_1)).print();
                // // }
                // std::cout << "****" << std::endl;
                
                std::list< boost::shared_ptr<PointTanbo> >::iterator found_point_lib, search_start_lib;
                search_start_lib = root_libs.begin();
                while(true) {
                  found_point_lib = std::find(search_start_lib, root_libs.end(), cur_nbor);
                  // find() returns the end of list if nothing is found
                  if(found_point_lib == root_libs.end()) {
                    break;
                  } else {
                    lib_found = true;
                    break;
                  }
                }
                
                //Assert that each of the neighbors of the point of the root was returned as a liberty of that root
                CPPUNIT_ASSERT( lib_found );
              }
            }
        }
    }
  }
