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

#include "ruby_uct.h"
#include "board_tanbo.h"

#include <iostream> 
#include <cassert>
#include <ctime>

Player::Player(const std::string &name,Token player) : name(name), player(player) {
	assert(not player==NOT_PLAYED);
}

Token Player::get_player() const {
	return player;
}


PlayerBot::PlayerBot(Token player,double max_sec,int max_iteration,double uct_constant) : Player("bot",player), max_sec(max_sec),max_iteration(max_iteration),root(new Node(uct_constant)) {}

int *PlayerBot::get_move(const Board *board, const Move * last_move) {
    //std::cout<<"playing enemy move"<<std::endl;
    //root->print_tree();

    //reuse last simulations if possibles
	if (last_move) root=root->advance_and_detach(last_move);
    Count saved_simulations=root->get_nb();

    //std::cout<<"before simulations"<<std::endl;
    //root->print_tree();

	clock_t start=clock(),end=clock();
	int k;
    for (k=0; (k<max_iteration or not max_iteration) and root->get_mode()==NORMAL and end-start<max_sec*CLOCKS_PER_SEC; k++) {
        Board *copy=board->deepcopy();
        Token winner=root->play_random_game(copy,player);
        delete copy;

		end=clock();
    }

	const Node *best_child=root->get_best_child();
	if (not best_child) return NULL;

    const Move *move=best_child->get_move();

	//debug report
    //std::cout<<"after simulations"<<std::endl;
    //root->print_tree();
    //root->print_best_branch_down();
    //std::cout<<std::endl;

	//simulation report
	std::cout<<"simulated "<<k<<" games ("<<saved_simulations<<" saved) in "<<float(end-start)/CLOCKS_PER_SEC<<"s"<<std::endl;

	//move report
    std::cout<<"playing ";
	switch (root->get_mode()) {
	case NORMAL:
		std::cout<<"normal "<<best_child->get_winning_probability()<<" ";
		break;
	case WINNER:
		std::cout<<"loosing ";
		break;
	case LOOSER:
		std::cout<<"winning ";
		break;
	}
	std::cout<<"move ";
    move->print();
    std::cout<<std::endl;

    //play best_move
	root=root->advance_and_detach(move);
    //std::cout<<"after playing best_move"<<std::endl;
    //root->print_tree();

  const MoveTanbo *tan_move = dynamic_cast<const MoveTanbo*>(move);
  int *ans = new int[2];
  ans[0] = tan_move->x; ans[1] = tan_move->y;
  return ans;
}

PlayerBot::~PlayerBot() {
	delete root;
}