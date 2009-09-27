// Adapted from UCT implementation by Pierre Gueth and Joel Schaerer, Copyright 2009
// http://github.com/joelthelion/uct
// 
// Authors: Travis Briggs, briggs.travis (at) gmail.com
//          Pierre Gueth and Joel Schaerer
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

#include "board_tanbo.h"
#include "root_tanbo.h"
#include "point_tanbo.h"

#include <boost/make_shared.hpp>

#include <vector>
#include <list>
#include <algorithm>

#include <iostream>
#include <sstream>
#include <cassert>
#include <cstdlib>

MoveTanbo::MoveTanbo(Token player, Size x, Size y) : Move(player), x(x), y(y) {}

void MoveTanbo::print() const {
  if (player != NOT_PLAYED) std::cout<<"{["<<this->x<<", "<<this->y<<"] for player "<<player<<"}";
  else std::cout<<"tanbo null move";
}

Move *MoveTanbo::deepcopy() const {
  Move *copy=new MoveTanbo(player, x, y);
  return copy;
}

bool MoveTanbo::compare (const Move& abstract_move) const {
  const MoveTanbo &move=dynamic_cast<const MoveTanbo&>(abstract_move);
  return Move::compare(abstract_move) && x==move.x && y==move.y;
}

class PointTanbo;
class RootTanbo;

BoardTanbo::BoardTanbo() : turn(NOT_PLAYED), roots(), points(379), me(boost::shared_ptr<BoardTanbo>(this)) {
  this->starting_position();  
  
  //allocate flat
  // flat=new Token[size];
  //   for (Token *iter=flat; iter!=flat+size; iter++) *iter=NOT_PLAYED;
  // 
  //   //allocate column pointer and playable move cache
  //   tokens=new Token*[width];
  //   token_for_columns=new Token*[width];
  //   Size k=0;
  //   for (Token *iter=flat; iter<flat+size; iter+=height) {
  //     tokens[k]=iter;
  //     token_for_columns[k]=iter+height-1;
  //     k++;
  //   }
  // 
  //   assert(k==width);
}

BoardTanbo::~BoardTanbo() {
  //Not currently needed
}

bool BoardTanbo::in_bounds(const PointTanbo &point) {
  return (point.x >= 0 && point.x <= 18 && point.y >= 0 && point.y <= 18);
}

// Allocates a new vector, fills it with the neighbors of the given points that
// are inbounds, and returns a reference to it.
PointTanboVecPtr BoardTanbo::bounded_neighbors(const PointTanbo &point) {
  if(this->in_bounds(point)){
    int x = point.x;
    int y = point.y;
    PointTanboVecPtr ans = PointTanboVecPtr(new std::vector< boost::shared_ptr<PointTanbo> >());
    ans->reserve(4);

    // If the point is in bounds, we only have to check what we're modifiying
    if(x+1 <= 18) ans->push_back(this->at(x+1, y));
    if(y+1 <= 18) ans->push_back(this->at(x, y+1));
    if(x-1 >= 0 ) ans->push_back(this->at(x-1, y));
    if(y-1 >= 0 ) ans->push_back(this->at(x, y-1));
  
    return ans;
  }
}

boost::shared_ptr<PointTanbo> BoardTanbo::at(const int x, const int y) {
  int index = x*20 + y;
  if(points[index].get() == 0) {
    points[index].reset( new PointTanbo(x, y, me) );
  }
  return points[index];
}

void BoardTanbo::starting_position() {
  turn = PLAYER_1;
  
  std::vector< boost::shared_ptr<PointTanbo> > init_white = std::vector< boost::shared_ptr<PointTanbo> >();
  init_white.reserve(8);
  init_white.push_back(this->at(6 ,0 ));
  init_white.push_back(this->at(18,0 ));
  init_white.push_back(this->at(0 ,6 ));
  init_white.push_back(this->at(12,6 ));
  init_white.push_back(this->at(6 ,12));
  init_white.push_back(this->at(18,12));
  init_white.push_back(this->at(0 ,18));
  init_white.push_back(this->at(12,18));
  
  for (std::vector< boost::shared_ptr<PointTanbo> >::iterator itr = init_white.begin(); itr != init_white.end(); ++itr ) {
    boost::shared_ptr<PointTanbo> point = (*itr);
    point->color = PLAYER_2;
    boost::shared_ptr<RootTanbo> new_root = boost::shared_ptr<RootTanbo>(new RootTanbo(PLAYER_2));
    roots.push_back( new_root );
    this->add_point_to_root(point, new_root);
  }
  
  std::vector< boost::shared_ptr<PointTanbo> > init_black = std::vector< boost::shared_ptr<PointTanbo> >();
  init_black.reserve(8);
  init_black.push_back(this->at(0 ,0 ));
  init_black.push_back(this->at(12,0 ));
  init_black.push_back(this->at(6 ,6 ));
  init_black.push_back(this->at(18,6 ));
  init_black.push_back(this->at(12,12));
  init_black.push_back(this->at(18,18));
  init_black.push_back(this->at(6 ,18));
  init_black.push_back(this->at(0 ,12));
  
  for (std::vector< boost::shared_ptr<PointTanbo> >::iterator itr = init_black.begin(); itr != init_black.end(); ++itr ) {
    boost::shared_ptr<PointTanbo> point = (*itr);
    point->color = PLAYER_1;
    boost::shared_ptr<RootTanbo> new_root = boost::shared_ptr<RootTanbo>(new RootTanbo(PLAYER_1));
    roots.push_back( new_root );
    this->add_point_to_root(point, new_root);
  }
}

void BoardTanbo::add_point_to_root(boost::shared_ptr<PointTanbo> &point, boost::shared_ptr<RootTanbo> &root) {
  // Add the point to the points and delete it from the available liberties
  boost::shared_ptr<RootTanbo> new_root_ptr = boost::shared_ptr<RootTanbo>(root);
  point->root.reset(new_root_ptr, root.get());
  root->points.push_back(point);
  
  // Search and destroy!
  std::list< boost::shared_ptr<PointTanbo> >::iterator new_end;
  new_end = std::remove(root->liberties.begin(), root->liberties.end(), point);
  root->liberties.erase(new_end, root->liberties.end());
  
  // Check each neighbor. If it's a valid move, it's a liberty. Otherwise,
  // it's not (remove it in case it was previously).
  PointTanboVecPtr bnded_nbs = point->bounded_neighbors();
  
  for (std::vector< boost::shared_ptr<PointTanbo> >::iterator itr = bnded_nbs->begin(); itr != bnded_nbs->end(); ++itr ) {
    boost::shared_ptr<PointTanbo> pair = (*itr);
    if (this->is_move_valid(*pair, root->color)) {
      root->liberties.push_back(point);
    } else {
      new_end = std::remove(root->liberties.begin(), root->liberties.end(), pair);
      root->liberties.erase(new_end, root->liberties.end());
    }
  }
}

Board *BoardTanbo::deepcopy() const {
  //     BoardTanbo *copy=new BoardTanbo(width,height,win_length);
  // 
  //     //copy last move and played_count
  //     copy->lastmove=lastmove;
  //     copy->played_count=played_count;
  // 
  // //copy flat
  //     const Token *current_iter=flat;
  // for (Token *iter=copy->flat; iter!=copy->flat+size; iter++) {
  //         *iter=*current_iter;
  //         current_iter++;
  //     }
  // 
  // //copy token_for_columns
  //     for (int k=0; k<width; k++) {
  //         copy->token_for_columns[k]=copy->tokens[k]+(token_for_columns[k]-tokens[k]);
  //     }
  // 
  //     return copy;
}

void BoardTanbo::print() const {
  // std::cout<<"  ";
  //   for (Size column=0; column<width; column++) std::cout<<column;
  //   std::cout<<std::endl;
  // 
  //   std::cout<<" +";
  //   for (Size column=0; column<width; column++) std::cout<<"-";
  //   std::cout<<"+"<<std::endl;
  // 
  //   for (Size row=0; row<height; row++) {
  //     std::cout<<row<<"|";
  //     for (Size column=0; column<width; column++) {
  //       switch(tokens[column][row]) {
  //       case NOT_PLAYED:
  //         std::cout<<" ";
  //         break;
  //       case PLAYER_1:
  //         std::cout<<"x";
  //         break;
  //       case PLAYER_2:
  //         std::cout<<"o";
  //         break;
  //       }
  //     }
  //     std::cout<<"|"<<row<<std::endl;
  //   }
  // 
  //   std::cout<<" +";
  //   for (Size column=0; column<width; column++) std::cout<<"-";
  //   std::cout<<"+"<<std::endl;
  // 
  //   std::cout<<"  ";
  //   for (Size column=0; column<width; column++) std::cout<<column;
  //   std::cout<<std::endl;
}

bool BoardTanbo::is_move_valid(const Move &abstract_move) const {
  return is_move_valid(dynamic_cast<const MoveTanbo&>(abstract_move));
}

bool BoardTanbo::is_move_valid(const MoveTanbo &move) {
  return is_move_valid(*this->at(move.x, move.y));
  // return move.player!=NOT_PLAYED and move.column>=0 and move.column<width and token_for_columns[move.column]>=tokens[move.column];
}

bool BoardTanbo::is_move_valid(const PointTanbo &point, Token color) const {
  if(! this->in_bounds(point)) {
    return false;
  }
  
  int x = point.x;
  int y = point.y;
  if(color == NOT_PLAYED) {
    color = turn;
  }
  
  // # Valid moves are in within the bounds of the board
  if(x < 0 || y < 0 || x > 18 || y > 18) {
    return false;
  }
  
  if(point.color != NOT_PLAYED) {
    return false;
  }
  
  // Implementation not finished, see commented out code below...
  assert(false);
  return false;
  
  // Factor this into get_adjacent_root() method...
  // adjacent = false
  // answer = nil
  // if x-1 >= 0 #Check the location to the west
  //  adj_point = self[x-1, y]
  //  if adj_point.color == color
  //    # The west location is the same color as the queried location.
  //    # For now, this is the answer, unless there are other adjacent
  //    # pieces, in which case this ceases to be a valid move
  //    answer = adj_point
  //    adjacent = true
  //  end
  // end
  // if y-1 >= 0 #North location
  //  adj_point = self[x, y-1]
  //  if adj_point.color == color
  //    # This is the answer, unless we have already found an adajcent piece
  //    if adjacent
  //      return nil
  //    else
  //      answer = adj_point
  //    end
  //    adjacent = true
  //  end
  // end
  // if x+1 < 19 #East location
  //  adj_point = self[x+1, y]
  //  if adj_point.color == color
  //    # Ditto
  //    if adjacent
  //      return nil
  //    else
  //      answer = adj_point
  //    end
  //    adjacent = true
  //  end
  // end
  // if y+1 < 19 #South location
  //  adj_point = self[x, y+1]
  //  if adj_point.color == color
  //    # Ditto
  //    if adjacent
  //      return nil
  //    else
  //      answer = adj_point
  //    end
  //    adjacent = true
  //  end
  // end
  // 
  // #puts "----#{point.inspect} -> #{answer.inspect}"
  // return answer
}

Moves BoardTanbo::get_possible_moves(Token player) const {
  Moves moves;
  
  // for (Size column=0; column<width; column++) {
  //  if (tokens[column]<=token_for_columns[column]) moves.push_back(new MoveTanbo(player,column));
  // }

  return moves;
}

void BoardTanbo::play_move(const Move &abstract_move) {
  // const MoveTanbo &move=dynamic_cast<const MoveTanbo&>(abstract_move);
  // 
  // assert(this->is_move_valid(move));
  // 
  // *token_for_columns[move.column]=move.player;
  // token_for_columns[move.column]--;
  // 
  // played_count++;
  // lastmove=move;
}

bool BoardTanbo::play_random_move(Token player) {
  return false;
  // if (played_count<size) {
  //  Moves possible_moves=get_possible_moves(player);
  // 
  //  int selected=rand()/(RAND_MAX + 1.0) * possible_moves.size();
  //  Moves::const_iterator selected_iter=possible_moves.begin();
  //  while (selected>0) {
  //    selected--;
  //    selected_iter++;
  //  }
  //  play_move(**selected_iter);
  // 
  //  //play_move(*selected);
  //  //Move *selected=possible_moves[rand()%possible_moves.size()];
  //  //play_move(*selected);
  // 
  //  for (Moves::iterator iter=possible_moves.begin(); iter!=possible_moves.end(); iter++) delete *iter;
  // 
  //  return true;
  // } else {
  //  //std::cout<<"board full"<<std::endl;
  //  return false;
  // }
}

Token BoardTanbo::check_for_win() const {
  //     Size column=lastmove.column;
  //     Size row=token_for_columns[column]-tokens[column]+1;
  // 
  // assert(propagate(row,column,-1,0,lastmove.player)==1); //move up are never played
  // 
  //     if (propagate(row,column,1,0,lastmove.player)+1>win_length) return lastmove.player;
  //     if (propagate(row,column,0,1,lastmove.player)+propagate(row,column,0,-1,lastmove.player)>win_length) return lastmove.player;
  //     if (propagate(row,column,1,1,lastmove.player)+propagate(row,column,-1,-1,lastmove.player)>win_length) return lastmove.player;
  //     if (propagate(row,column,1,-1,lastmove.player)+propagate(row,column,-1,1,lastmove.player)>win_length) return lastmove.player;

  return NOT_PLAYED;
}

