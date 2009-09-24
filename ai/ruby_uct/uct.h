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

#ifndef __UCT__
#define __UCT__

#include <list>
#include "common.h"
#include "board.h"

class Node;

typedef std::list<Node*> Nodes;
typedef std::list<const Node*> ConstNodes;

class Node {
public:
    Node(double uct_constant); //root constructor
    Node(const Move *move,double uct_constant,Node *father=NULL);
    ~Node();

    void print() const;
    void print_tree(int level=0) const;
    void print_best_branch_down() const;
    void print_branch_up() const;

    const Node *get_best_child() const;
    Token play_random_game(Board *board,Token player);

  Value get_winning_probability() const;
  Mode get_mode() const;
  const Move *get_move() const;
    Count get_nb() const;
  Node * advance_and_detach(const Move * move);

protected:
    static void print_branch(const ConstNodes &branch);

    ConstNodes get_best_branch_down() const;
    ConstNodes get_branch_up() const;

    void update_father(Value value);
    void propagate_winning_to_granpa();
  void propagate_loosing_to_daddy();
    void recompute_inheritance();
    void tell_granpa_dad_is_a_looser(const Node *dad);
  double uct_constant;

private:
    Node *father;
    //Nodes good_children;
    Nodes children;
    Moves unexplored_moves;

    Count nb;
    Value value;
    Value simulation_value;

    Mode mode;
    const Move *move;
};

#endif
