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

#include "point_tanbo.h"
#include "board_tanbo.h"

#include <boost/make_shared.hpp>

#include <cassert>

class BoardTanbo;

PointTanbo::PointTanbo(int the_x=-1, int the_y=-1, boost::shared_ptr<BoardTanbo> the_board=boost::make_shared<BoardTanbo>()) 
  : x(the_x), y(the_y), board(the_board) {
}

bool PointTanbo::operator==(const PointTanbo &other) const {
  if(this->x != other.x) return false;
  if(this->y != other.y) return false;
  if( &(this->board) != &(other.board) ) return false;
  return true;
}

bool PointTanbo::in_bounds() {
  return BoardTanbo::in_bounds(*this);
}

PointTanboVecPtr PointTanbo::bounded_neighbors() {
  if (! cached_neighbors) {
    cached_neighbors = board->bounded_neighbors(*this);
  }
  return cached_neighbors;
}

void PointTanbo::print() const {
  assert(false);
}

boost::shared_ptr<PointTanbo> PointTanbo::deepcopy(boost::shared_ptr<BoardTanbo> board) {
  assert(false);
  return boost::make_shared<PointTanbo>(-1, -1, board);
}
