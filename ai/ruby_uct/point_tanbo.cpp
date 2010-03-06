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

#include <iostream>
#include <cassert>

class BoardTanbo;

PointTanbo::PointTanbo(int the_x=-1, int the_y=-1) 
  : x(the_x), y(the_y), color(NOT_PLAYED) {
}

bool PointTanbo::operator==(const PointTanbo &other) const {
  if(this->x != other.x) return false;
  if(this->y != other.y) return false;
  return true;
}

bool PointTanbo::in_bounds() {
  return BoardTanbo::in_bounds(*this);
}

void PointTanbo::print() const {
  std::cout << "[P:" << x << "," << y << "]";
}

boost::shared_ptr<PointTanbo> PointTanbo::deepcopy() {
  boost::shared_ptr<PointTanbo> copy = boost::make_shared<PointTanbo>(this->x, this->y);
  copy->color = this->color;
  return copy;
}
