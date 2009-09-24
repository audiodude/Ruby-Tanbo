# Adapted from UCT implementation by Pierre Gueth and Joel Schaerer, Copyright 2009
# http://github.com/joelthelion/uct

# Authors: Travis Briggs, briggs.travis (at) gmail.com
#          Pierre Gueth and Joel Schaerer
# ===================================================
# Copyright (C) 2009 Travis Briggs
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. See the COPYING file. If not, see
# <http://www.gnu.org/licenses/>.


module UCT
  class AIBoard < TanboBoard

    def initialize()
      super()
      
      @lastmove = UCT::Move.new(UCT::Node::NOT_PLAYED)
      @played_count = 0
      @size = 19 * 19
    end

    def deep_copy
      copy = super(AIBoard.new)

      #copy last move and played_count
      copy.lastmove = @lastmove
      copy.played_count = @played_count
    
      return copy
    end
  
    def get_possible_moves(player)
      if(player == UCT::Node::PLAYER_1)
        return self.get_all_moves(TanboBoard::BLACK).keys.map! do |move|
          UCT::Move.new(UCT::Node::PLAYER_1, move.x, move.y)
        end
      elsif(player == UCT::Node::PLAYER_2)
        return self.get_all_moves(TanboBoard::WHITE).keys.map! do |move|
          UCT::Move.new(UCT::Node::PLAYER_2, move.x, move.y)
          
        end
      else
        raise "No valid moves for: #{player}"
      end
    end
  
    def play_move(move)
      adj = self.valid_move?(self[move.x, move.y])
      raise move.inspect unless adj

      self.make_move(self[move.x, move.y], adj)

      @played_count += 1
      @lastmove = move
    end
  
    def play_random_move(player)
      possible_moves = get_possible_moves(player)

      selected = rand(possible_moves.size)
      move = possible_moves[selected]
      play_move(move)
        
      return true
    end
  
    def check_for_win  
      case self.game_over?
        when nil
          return UCT::Node::NOT_PLAYED
        when TanboBoard::BLACK
          return UCT::Node::PLAYER_1
        when TanboBoard::WHITE
          return UCT::Node::PLAYER_2
      end
    end
  
    def play_random_game(next_player)
      winner = UCT::Node::NOT_PLAYED
      player = next_player
      while (self.play_random_move(player))
        winner = self.check_for_win

        if winner != UCT::Node::NOT_PLAYED
          return winner
        end
       
        player=UCT::Node.other_player(player)
      end
    end
  
  end
end