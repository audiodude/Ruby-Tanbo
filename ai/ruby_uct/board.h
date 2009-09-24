// Copyright Pierre Gueth and Joel Schaerer, 2009
// 
// uct is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// uct is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with uct.  If not, see <http://www.gnu.org/licenses/>.

#ifndef __BOARD__
#define __BOARD__

#include <list>
#include "common.h"

class Board;

class Move {
public:
  Move();
  Move(Token player);

  virtual Move *deepcopy() const;
  virtual void print() const;
  virtual bool compare(const Move& move) const;

  Token player;
};

typedef std::list<Move*> Moves;

class Board {
public:
  virtual ~Board() =0;

  virtual Board *deepcopy() const =0;
  virtual Move *parse_move_string(Token player,const char *string) const =0;
  virtual void print() const =0;
  virtual bool is_move_valid(const Move &move) const =0;
  virtual Moves get_possible_moves(Token player) const =0; //FIXME possible constness problem
  virtual void play_move(const Move &move) =0;
  virtual bool play_random_move(Token player) =0;
  virtual Token check_for_win() const =0;
  virtual Token play_random_game(Token next_player);
};

#endif
