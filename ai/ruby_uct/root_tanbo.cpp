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

#include "root_tanbo.h"
#include "point_tanbo.h"

#include <iostream>
#include <cassert>
#include <list>
#include <vector>
#include <boost/shared_ptr.hpp>

RootTanbo::RootTanbo(Token init_color) : color(init_color) {
}

void RootTanbo::remove_point(const boost::shared_ptr<PointTanbo> point) {
  std::list< boost::shared_ptr<PointTanbo> >::iterator new_end;
  new_end = std::remove(liberties.begin(), liberties.end(), point);
  liberties.erase(new_end, liberties.end());
}

bool RootTanbo::bounded() const {
  return liberties.empty();
}

void RootTanbo::print() const {
  std::cout << "[R:" << std::endl << "  Pts:  ";
  for(std::vector< boost::shared_ptr<PointTanbo> >::const_iterator itr = this->points.begin(); itr != this->points.end(); ++itr) {
    (*(*itr)).print();
  }
  std::cout << std::endl << "  Libs:  ";
  for(std::list< boost::shared_ptr<PointTanbo> >::const_iterator itr_1 = this->liberties.begin(); itr_1 != this->liberties.end(); ++itr_1) {
    (*(*itr_1)).print();
  }
  std::cout << "]" << std::endl;
}

RootTanbo *RootTanbo::deepcopy(const BoardTanbo *board) {
  assert(false);
  return new RootTanbo(this->color);
}

void RootTanbo::associate_with(const BoardTanbo *board) {
  assert(false);
}
  

