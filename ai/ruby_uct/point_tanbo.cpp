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

class BoardTanbo;

PointTanbo::PointTanbo(int x=-1, int y=-1, BoardTanbo *board=NULL) {
  this->x = x;
  this->y = y;
  this->board = board;
}

bool PointTanbo::in_bounds() {
  return BoardTanbo::in_bounds(this);
}

PointTanbo *PointTanbo::bounded_neighbors() {
  return new PointTanbo();
}

void PointTanbo::print() const {
  
}

PointTanbo *PointTanbo::deepcopy(BoardTanbo *board) {
  return new PointTanbo(0, 0, board);
}
