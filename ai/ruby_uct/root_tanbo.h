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

#ifndef __ROOT_TANBO__
#define __ROOT_TANBO__

#include "point_tanbo.h"
#include "board_tanbo.h"
#include "common.h"

#include <vector>
#include <list>
#include <boost/shared_ptr.hpp>

class RootTanbo {
public:
  RootTanbo(Token init_color);
  void remove_point(const boost::shared_ptr<PointTanbo> point);
  bool bounded() const;
  void print() const;
  RootTanbo *deepcopy(const BoardTanbo *board);
  void associate_with(const BoardTanbo *board);
  
  Token color;
  std::vector < boost::shared_ptr<PointTanbo> > points;
  std::list < boost::shared_ptr<PointTanbo> > liberties;
};

#endif