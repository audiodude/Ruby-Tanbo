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

#ifndef __POINT_TANBO__
#define __POINT_TANBO__

#include "root_tanbo.h"
#include "board_tanbo.h"
#include "common.h"

class BoardTanbo;
class RootTanbo;

class PointTanbo {
public:
  PointTanbo(int x, int y, BoardTanbo *board);
  
  bool in_bounds();
  bool blank() { return color == NOT_PLAYED; }
  PointTanbo *bounded_neighbors();
  void print() const;
  PointTanbo *deepcopy(BoardTanbo *board);
  
  int x;
  int y;
  RootTanbo *root;
  Token color;
  BoardTanbo *board;
};

#endif