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

#include "board_tanbo.h"
#include "root_tanbo.h"
#include "point_tanbo.h"

#include <iostream>
#include <sstream>
#include <cassert>
#include <cstdlib>

MoveTanbo::MoveTanbo(Token player, Size x, Size y) : Move(player), x(x), y(y) {}

void MoveTanbo::print() const {
	if (player != NOT_PLAYED) std::cout<<"{["<<this->x<<", "<<this->y<<"] for player "<<player<<"}";
	else std::cout<<"tanbo null move";
}

Move *MoveTanbo::deepcopy() const {
	Move *copy=new MoveTanbo(player, x, y);
	return copy;
}

bool MoveTanbo::compare (const Move& abstract_move) const {
  const MoveTanbo &move=dynamic_cast<const MoveTanbo&>(abstract_move);
	return Move::compare(abstract_move) && x==move.x && y==move.y;
}


BoardTanbo::BoardTanbo() : lastmove(NOT_PLAYED,-1,-1), played_count(0) {

	//allocate flat
	// flat=new Token[size];
	//   for (Token *iter=flat; iter!=flat+size; iter++) *iter=NOT_PLAYED;
	// 
	//   //allocate column pointer and playable move cache
	//   tokens=new Token*[width];
	//   token_for_columns=new Token*[width];
	//   Size k=0;
	//   for (Token *iter=flat; iter<flat+size; iter+=height) {
	//     tokens[k]=iter;
	//     token_for_columns[k]=iter+height-1;
	//     k++;
	//   }
	// 
	//   assert(k==width);
}

BoardTanbo::~BoardTanbo() {
	delete [] points;
	delete [] roots;
}

Board *BoardTanbo::deepcopy() const {
  //     BoardTanbo *copy=new BoardTanbo(width,height,win_length);
  // 
  //     //copy last move and played_count
  //     copy->lastmove=lastmove;
  //     copy->played_count=played_count;
  // 
  // //copy flat
  //     const Token *current_iter=flat;
  // for (Token *iter=copy->flat; iter!=copy->flat+size; iter++) {
  //         *iter=*current_iter;
  //         current_iter++;
  //     }
  // 
  // //copy token_for_columns
  //     for (int k=0; k<width; k++) {
  //         copy->token_for_columns[k]=copy->tokens[k]+(token_for_columns[k]-tokens[k]);
  //     }
  // 
  //     return copy;
}

void BoardTanbo::print() const {
	// std::cout<<"  ";
	//   for (Size column=0; column<width; column++) std::cout<<column;
	//   std::cout<<std::endl;
	// 
	//   std::cout<<" +";
	//   for (Size column=0; column<width; column++) std::cout<<"-";
	//   std::cout<<"+"<<std::endl;
	// 
	//   for (Size row=0; row<height; row++) {
	//     std::cout<<row<<"|";
	//     for (Size column=0; column<width; column++) {
	//       switch(tokens[column][row]) {
	//       case NOT_PLAYED:
	//         std::cout<<" ";
	//         break;
	//       case PLAYER_1:
	//         std::cout<<"x";
	//         break;
	//       case PLAYER_2:
	//         std::cout<<"o";
	//         break;
	//       }
	//     }
	//     std::cout<<"|"<<row<<std::endl;
	//   }
	// 
	//   std::cout<<" +";
	//   for (Size column=0; column<width; column++) std::cout<<"-";
	//   std::cout<<"+"<<std::endl;
	// 
	//   std::cout<<"  ";
	//   for (Size column=0; column<width; column++) std::cout<<column;
	//   std::cout<<std::endl;
}

bool BoardTanbo::is_move_valid(const Move &abstract_move) const {
  return false;
  // return is_move_valid(dynamic_cast<const MoveTanbo&>(abstract_move));
}

bool BoardTanbo::is_move_valid(const MoveTanbo &move) const {
  return false;
  // return move.player!=NOT_PLAYED and move.column>=0 and move.column<width and token_for_columns[move.column]>=tokens[move.column];
}

Moves BoardTanbo::get_possible_moves(Token player) const {
	Moves moves;
	
  // for (Size column=0; column<width; column++) {
  //  if (tokens[column]<=token_for_columns[column]) moves.push_back(new MoveTanbo(player,column));
  // }

	return moves;
}

void BoardTanbo::play_move(const Move &abstract_move) {
  // const MoveTanbo &move=dynamic_cast<const MoveTanbo&>(abstract_move);
  // 
  // assert(this->is_move_valid(move));
  // 
  // *token_for_columns[move.column]=move.player;
  // token_for_columns[move.column]--;
  // 
  // played_count++;
  // lastmove=move;
}

bool BoardTanbo::play_random_move(Token player) {
  return false;
  // if (played_count<size) {
  //  Moves possible_moves=get_possible_moves(player);
  // 
  //  int selected=rand()/(RAND_MAX + 1.0) * possible_moves.size();
  //  Moves::const_iterator selected_iter=possible_moves.begin();
  //  while (selected>0) {
  //    selected--;
  //    selected_iter++;
  //  }
  //  play_move(**selected_iter);
  // 
  //  //play_move(*selected);
  //  //Move *selected=possible_moves[rand()%possible_moves.size()];
  //  //play_move(*selected);
  // 
  //  for (Moves::iterator iter=possible_moves.begin(); iter!=possible_moves.end(); iter++) delete *iter;
  // 
  //  return true;
  // } else {
  //  //std::cout<<"board full"<<std::endl;
  //  return false;
  // }
}

Token BoardTanbo::check_for_win() const {
  //     Size column=lastmove.column;
  //     Size row=token_for_columns[column]-tokens[column]+1;
  // 
  // assert(propagate(row,column,-1,0,lastmove.player)==1); //move up are never played
  // 
  //     if (propagate(row,column,1,0,lastmove.player)+1>win_length) return lastmove.player;
  //     if (propagate(row,column,0,1,lastmove.player)+propagate(row,column,0,-1,lastmove.player)>win_length) return lastmove.player;
  //     if (propagate(row,column,1,1,lastmove.player)+propagate(row,column,-1,-1,lastmove.player)>win_length) return lastmove.player;
  //     if (propagate(row,column,1,-1,lastmove.player)+propagate(row,column,-1,1,lastmove.player)>win_length) return lastmove.player;

	return NOT_PLAYED;
}

