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

#ifndef __COMMON__
#define __COMMON__

#include <cassert>

#define MAX_INPUT_LENGTH 256

typedef int Size;
typedef enum {NOT_PLAYED,PLAYER_1,PLAYER_2} Token;

inline Token other_player(Token player) {
  switch (player) {
  case PLAYER_1:
    return PLAYER_2;
  case PLAYER_2:
    return PLAYER_1;
    default:
    assert(false);
  }
}

typedef enum {NORMAL,LOOSER,WINNER} Mode;
typedef float Value;
typedef int Count;

#endif
