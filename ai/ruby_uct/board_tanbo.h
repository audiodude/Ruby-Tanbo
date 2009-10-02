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

#ifndef __TANBO_BOARD__
#define __TANBO_BOARD__

#include "root_tanbo.h"
#include "point_tanbo.h"
#include "board.h"

#include <vector>
#include <boost/shared_ptr.hpp>

#include <cassert>

class MoveTanbo : public Move {
friend class BoardTanbo;
public:
  MoveTanbo(Token player, Size x, Size y);

  virtual void print() const;
  virtual Move *deepcopy() const;
  virtual bool compare (const Move& move) const;

private:
  Size x;
  Size y;
};

class PointTanbo;
class RootTanbo;

class BoardTanbo : public Board {
public:
  BoardTanbo();
  virtual ~BoardTanbo();

  void starting_position();
  
  // Link the given point to the given root in both directions, and update the
  // liberties of the root.
  void add_point_to_root(boost::shared_ptr<PointTanbo> &point, boost::shared_ptr<RootTanbo> &root);

  static bool in_bounds(const PointTanbo &point);

  // Instantiate and return a vector of the neighbors of the given Point
  boost::shared_ptr<  std::vector< boost::shared_ptr<PointTanbo> >  > BoardTanbo::bounded_neighbors(const PointTanbo &point);

  boost::shared_ptr<PointTanbo> at(int x, int y);

  // These are the functions defined in the super class
  virtual Board *deepcopy() const;
  virtual void print() const;
  inline virtual bool is_move_valid(const Move &move) const;
  inline bool is_move_valid(const MoveTanbo &move);
  virtual Moves get_possible_moves(Token player) const; //FIXME not sure about constness
  virtual void play_move(const Move &move);
  virtual bool play_random_move(Token player);
  virtual Token check_for_win() const;
  // End superclass functions

  // If the given point is adjacent to a single root of the given color, return
  // that point. Otherwise, return null.
  boost::shared_ptr<RootTanbo> get_adjacent_root(const PointTanbo &point, Token color);
  // Find out if the move at a specified point is valid for a specified color. Uses
  // the color of whoever's turn it is if NOT_PLAYED is specified.
  bool is_move_valid(const PointTanbo &move, Token color=NOT_PLAYED);

  void to_s();

  Token get_turn() const {
    return turn;
  }
  
  //Not implemented
  Move* parse_move_string(Token, const char*) const {
    assert(false);
    return 0;
  }
  
  Token turn;
  std::vector < boost::shared_ptr<PointTanbo> > points;
  std::vector < boost::shared_ptr<RootTanbo> > roots;
  boost::shared_ptr<BoardTanbo> me;
};

#endif
