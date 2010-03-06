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

MoveTanbo::MoveTanbo(Token player, Size x, Size y, boost::shared_ptr<PointTanbo> adj_point) : Move(player), x(x), y(y), adj_point(adj_point) {}

void MoveTanbo::print() const {
  if (player != NOT_PLAYED) std::cout<<"{["<<this->x<<", "<<this->y<<"] for player "<<player<<"}";
  else std::cout<<"tanbo null move";
}

Move *MoveTanbo::deepcopy() const {
  Move *copy=new MoveTanbo(player, x, y, adj_point);
  return copy;
}

bool MoveTanbo::compare (const Move& abstract_move) const {
  const MoveTanbo &move=dynamic_cast<const MoveTanbo&>(abstract_move);
  return Move::compare(abstract_move) && x==move.x && y==move.y;
}

class PointTanbo;
class RootTanbo;

BoardTanbo::BoardTanbo() : turn(NOT_PLAYED), roots(), points(379), me(boost::shared_ptr<BoardTanbo>(this)) {
  int index;
  for(int x=0; x<19; x++) {
    for(int y=0; y<19; y++) {
      index = x*20 + y;
      PointTanbo *point = new PointTanbo(x, y, me);
      points[index].reset( point );
    }
  }
  
  this->starting_position();
  
  //allocate flat
  // flat=new Token[size];
  //   for (Token *iter=flat; iter!=flat+size; iter++) *iter=NOT_PLAYED;
  // 
  //   //allocate column pointer and playable move cache
  //   tokens=new Token*[19];
  //   token_for_columns=new Token*[19];
  //   Size k=0;
  //   for (Token *iter=flat; iter<flat+size; iter+=19) {
  //     tokens[k]=iter;
  //     token_for_columns[k]=iter+19-1;
  //     k++;
  //   }
  // 
  //   assert(k==19);
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

boost::shared_ptr<PointTanbo> BoardTanbo::at(const int x, const int y) const{
  int index = x*20 + y;
  assert (index >= 0 && index <= 399);
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
  assert(point);
  assert(root);

  // Add the point to the root and add the root to the point
  boost::shared_ptr<RootTanbo> new_root_ptr = boost::shared_ptr<RootTanbo>(root);
  point->root.swap(new_root_ptr);
  root->points.push_back(point);
  
  // Search and destroy! (remove the point from the root's liberties)
  root->remove_point(point);
  
  // Check each neighbor. If it's a valid move, it's a liberty. Otherwise,
  // it's not (remove it in case it was previously).
  PointTanboVecPtr bnded_nbs = point->bounded_neighbors();
  
  for (std::vector< boost::shared_ptr<PointTanbo> >::iterator itr = bnded_nbs->begin(); itr != bnded_nbs->end(); ++itr ) {
    boost::shared_ptr<PointTanbo> pair = (*itr);
    if (this->is_move_valid(*pair, root->color)) {
      root->liberties.push_back(pair);
    } else {
      std::list< boost::shared_ptr<PointTanbo> >::iterator new_end;
      new_end = std::remove(root->liberties.begin(), root->liberties.end(), pair);
      root->liberties.erase(new_end, root->liberties.end());
    }
  }
}

Board *BoardTanbo::deepcopy() const {
  boost::shared_ptr<BoardTanbo> copy = boost::make_shared<BoardTanbo>();
  copy->turn = this->turn;
  
  for(int x=0; x<19; x++) {
    for(int y=0; y<19; y++) {
      int index = x*20 + y;
      // Put a copy of each point, deep_copylicated using the new board, 
      // at all of the used indices
      copy->points[index] = this->points[index]->deepcopy(copy);
    }
  }
  
  // copy.turn = @turn
  // 
  // @points.each_with_index do |val, i|
  //   next unless val
  //   # Put a copy of each point, deep_copylicated using the new board, at all of the
  //   # used indices
  //   copy.points[i] = val.deep_copy(copy)
  // end
  // 
  // copy.roots = @roots.dup
  // # puts @roots.size.to_s + " " + @roots.compact.size.to_s
  // copy.roots.map! do |root|
  //   root.deep_copy(copy)
  // end
  // 
  // return copy
}

void BoardTanbo::print() const{
  // the at function is non-const, so this function doesn't do anything
}

void BoardTanbo::to_s() {
  std::cout<<std::endl<<"+";
  for (int column=0; column<19; column++) std::cout<<"-";
  std::cout<<"+"<<std::endl;

  for (int row=0; row<19; row++) {
    std::cout<<"|";
    for (int column=0; column<19; column++) {
      boost::shared_ptr<PointTanbo> point = this->at(row, column);
      switch(point->color) {
      case NOT_PLAYED:
        std::cout<<".";
        break;
      case PLAYER_1:
        std::cout<<"b";
        break;
      case PLAYER_2:
        std::cout<<"w";
        break;
      default:
      std::cout<<point->color;
      }
    }
    std::cout<<"|"<<std::endl;
  }

  std::cout<<"+";
  for (int column=0; column<19; column++) std::cout<<"-";
  std::cout<<"+"<<std::endl;
}

boost::shared_ptr<PointTanbo> BoardTanbo::get_adjacent_point(const PointTanbo &point, Token color) const {
  bool adjacent = false;
  boost::shared_ptr<PointTanbo> answer;
  boost::shared_ptr<PointTanbo> adj_point;
  
  int x = point.x;
  int y = point.y;
  
  if(x-1 >= 0) {  //Check the location to the west
    boost::shared_ptr<PointTanbo> adj_point = this->at(x-1, y);
    if(adj_point->color == color) {
      // The west location is the same color as the queried location.
      // For now, this is the answer, unless there are other adjacent
      // pieces, in which case this ceases to be a valid move
      answer = adj_point;
      adjacent = true;
    }
  }
  
  if(y-1 >= 0) { //North location
    adj_point = this->at(x, y-1);
    if(adj_point->color == color) {
      // This is the answer, unless we have already found an adajcent piece
      if(adjacent) {
        return boost::shared_ptr<PointTanbo>(); //Return null pointer
      } else {
        answer = adj_point;
      }
      adjacent = true;
    }
  }
  
  if(x+1 < 19) { //East location
    adj_point = this->at(x+1, y);
    if(adj_point->color == color) {
      // Ditto
      if(adjacent) {
        return boost::shared_ptr<PointTanbo>(); //Return null pointer
      } else {
        answer = adj_point;
      }
      adjacent = true;
    }
  }
  
  if(y+1 < 19) { //South location
    adj_point = this->at(x, y+1);
    if(adj_point->color == color) {
      // Ditto
      if(adjacent) {
        return boost::shared_ptr<PointTanbo>(); //Return null pointer
      } else {
        answer = adj_point;
      }
      adjacent = true;
    }
  }
  
  return answer;
}

inline bool BoardTanbo::is_move_valid(const Move &abstract_move) const {
  return is_move_valid(dynamic_cast<const MoveTanbo&>(abstract_move));
}

bool BoardTanbo::is_move_valid(const MoveTanbo &move) {
  return is_move_valid(*this->at(move.x, move.y));
}

bool BoardTanbo::is_move_valid(const PointTanbo &point, Token color) {
  if(! this->in_bounds(point)) {
    return false;
  }
  
  int x = point.x;
  int y = point.y;
  if(color == NOT_PLAYED) {
    color = turn;
  }
  
  // Valid moves are in within the bounds of the board
  if(x < 0 || y < 0 || x > 18 || y > 18) {
    return false;
  }
  
  // Valid moves don't have a piece on them already
  if(point.color != NOT_PLAYED) {
    return false;
  }
  
  // Valid moves are adjacent to a root
  boost::shared_ptr<PointTanbo> adj = this->get_adjacent_point(point, color);
  if(adj) {  //If the pointer isn't null
    return true;
  } else {
    return false;
  }
}

Moves BoardTanbo::get_possible_moves(Token player) const {
  Moves moves = Moves();
  for (std::vector< boost::shared_ptr<RootTanbo> >::const_iterator itr = roots.begin(); itr != roots.end(); ++itr ) {
    boost::shared_ptr<RootTanbo> root = (*itr);
    if(root->color != player) { continue; }
    for(std::list < boost::shared_ptr<PointTanbo> >::const_iterator itr2 = root->liberties.begin(); itr2 != root->liberties.end(); ++itr2) {
      boost::shared_ptr<PointTanbo> point = (*itr2);
      boost::shared_ptr<PointTanbo> adj = this->get_adjacent_point(*point, player);
      MoveTanbo *next_move = new MoveTanbo(player, point->x, point->y, adj);
      moves.push_back(next_move);
    }
  }
  return moves;
}

// Convenience method to remove all of the pieces from the board that are
// in the given root, setting their color to NOT_PLAYED
inline void remove_root_pieces(const boost::shared_ptr<RootTanbo> root) {
  for(std::vector < boost::shared_ptr<PointTanbo> >::iterator itr = root->points.begin(); itr != root->points.end(); ++itr) {
    boost::shared_ptr<PointTanbo> point = (*itr);
    point->color = NOT_PLAYED;
  }
}

void BoardTanbo::play_move(const Move &abstract_move) {
  const MoveTanbo &move=dynamic_cast<const MoveTanbo&>(abstract_move);
  
  boost::shared_ptr<PointTanbo> point = this->at(move.x, move.y);
  point->color = turn;
  turn = other_player(turn);
  
  // Add the point to the root, which causes the root's "valid moves" to be
  // recalculated
  boost::shared_ptr<RootTanbo> cur_root = move.adj_point->root;
  this->add_point_to_root(point, cur_root);
  
  // Get the new piece's neighbor's neighbors. If they contain roots,
  // let those roots recalculate if their liberties are still valid.
  PointTanboVecPtr neighbors = this->bounded_neighbors(*point);
  for (std::vector< boost::shared_ptr<PointTanbo> >::iterator itr = neighbors->begin(); itr != neighbors->end(); ++itr ) {
    boost::shared_ptr<PointTanbo> neighbor = (*itr);
    // Skip the neighbor that allowed us to place the piece, and any
    // non-empty points. The status of filled points doesn't change
    // by placing a piece.
    if((*neighbor) == (*move.adj_point) || neighbor->color != NOT_PLAYED) { continue; }
    
    PointTanboVecPtr neighbors_neighbors = this->bounded_neighbors(*neighbor);
    for (std::vector< boost::shared_ptr<PointTanbo> >::iterator itr_1 = neighbors_neighbors->begin();
         itr_1 != neighbors_neighbors->end(); ++itr_1 ) {
      boost::shared_ptr<PointTanbo> next_neighbor = (*itr_1);
      boost::shared_ptr<RootTanbo> next_root = next_neighbor->root;
      if(next_root && next_root != cur_root && next_root->color == cur_root->color) {
        // There is a root next to one of the new pieces neighbors, and it is
        // the same color as the root of this piece. That neighbor, therefore,
        // is no longer a liberty for that root.
        next_root->remove_point(neighbor);
      }
    }
  }

  // Now check every root
  std::vector< boost::shared_ptr<RootTanbo> > other_bounded = std::vector< boost::shared_ptr<RootTanbo> >();
  for (std::vector< boost::shared_ptr<RootTanbo> >::iterator itr = roots.begin(); itr != roots.end(); ++itr ) {  
    boost::shared_ptr<RootTanbo> root = (*itr);
    //The current move is no longer a valid liberty of any root
    root->remove_point(point);
    
    // If the root has become bounded, keep track of it.
    if(root->bounded() && root != cur_root) {
      other_bounded.push_back(root);
    }
  }
  
  // If the current root is bounded, remove all of it's pieces and delete it
  // from the list of roots (effectively removing it from the board)
  if(cur_root->bounded()) {
    remove_root_pieces(cur_root);
    // Remove the root
    std::vector< boost::shared_ptr<RootTanbo> >::iterator new_end;
    new_end = std::remove(this->roots.begin(), this->roots.end(), cur_root);
    this->roots.erase(new_end, this->roots.end());
  } else {
    if(false == other_bounded.empty()) {
        for (std::vector< boost::shared_ptr<RootTanbo> >::iterator itr = other_bounded.begin(); itr != other_bounded.end(); ++itr ) {
        boost::shared_ptr<RootTanbo> root = (*itr);
        remove_root_pieces(root);        
        //Remove the root
        std::vector< boost::shared_ptr<RootTanbo> >::iterator new_end;
        new_end = std::remove(this->roots.begin(), this->roots.end(), root);
        this->roots.erase(new_end, this->roots.end());
      }
    }
  }
}

bool BoardTanbo::play_random_move(Token player) {
  std::srand((unsigned) std::time(0));
  Moves m = this->get_possible_moves(player);
  int idx = std::rand() % m.size();
  Move *random_move;
  
  //Delete every move except the one we're going to make
  int i=0;
  for (std::list<Move *>::iterator itr = m.begin(); itr != m.end(); ++itr ) {
    Move *move = (*itr);
    
    if(i == idx) {
      random_move = move;
    } else {
      delete move;
    }
    i++;
  }

  this->play_move(*random_move);
  delete random_move;
  return this->check_for_win() == player;
}

Token BoardTanbo::check_for_win() const {
  if(this->roots.size() == 1) {
    return roots[0]->color;
  }
  Token winning_color = NOT_PLAYED;
  for (std::vector< boost::shared_ptr<RootTanbo> >::const_iterator itr = this->roots.begin(); itr != this->roots.end(); ++itr ) {
    boost::shared_ptr<RootTanbo> root = (*itr);
    if(winning_color != NOT_PLAYED) {
      // There is no winner if we find a root with a different color than the
      // first color
      if(root->color != winning_color) {
        return NOT_PLAYED;
      }
    } else {
      //  We haven't seen any colors yet. The first one we see is
      //  the potential winner
      winning_color = root->color;
    }
  }
  // If we got here, every root in the array matches the color of the first root
  return winning_color;
}
