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

  static bool in_bounds(const PointTanbo *point) {
    return (point->x >= 0 && point->x <= 18 && point->y >= 0 && point->y <= 18);
  }

  virtual Board *deepcopy() const;
	virtual void print() const;
	inline virtual bool is_move_valid(const Move &move) const;
	inline bool is_move_valid(const MoveTanbo &move) const;
	virtual Moves get_possible_moves(Token player) const; //FIXME not sure about constness
	virtual void play_move(const Move &move);
	virtual bool play_random_move(Token player);
	virtual Token check_for_win() const;

private:
	MoveTanbo lastmove;

	Size width;
	Size height;
	Size win_length;
	Size size, played_count;
	
  PointTanbo *points;
  RootTanbo *roots;
};

#endif
