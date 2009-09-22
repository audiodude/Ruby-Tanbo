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

require 'ai/uct/move.rb'

module UCT
  class Node
    # Mode
    WINNER = 0100
    NORMAL = 0010
    LOSER  = 0001  
  
    # Token
    NOT_PLAYED = -0100
    PLAYER_1   = -0010
    PLAYER_2   = -0001
  
    attr_reader :nb, :father, :value, :move
    attr_accessor :mode
  
    def self.other_player(player)
    	case player
    	when PLAYER_1:
    		return PLAYER_2
    	when PLAYER_2:
    		return PLAYER_1
      else
    		raise "Invalid argument to other_player"
    	end
    end
  
    def initialize(opts = {})
      @move = opts[:move] || UCT::Move.new
      @uct_constant = opts[:uct_constant]
      @father = opts[:father]
      @nb = 0
      @value = nil
      @simulation_value = 0
      @mode = NORMAL
      @children = []
      @unexplored_moves = []
    end

    def inspect
      ans = ""
      ans += "[" + @children.size.to_s + " children"
      ans += "," + @unexplored_moves.size.to_s + " unexplored"

      ans += ","
      ans += @move.inspect

      ans += ",ROOT" if (not @father)

      ans += ","
      case @mode
      when NORMAL:
        ans += "NORMAL"
      when WINNER:
        ans += "WINNER"
      when LOSER:
        ans += "LOSER"
      end

      ans += ","
      if @nb > 0
        ans += @value.to_s + "," + @nb.to_s + "," + (@value/@nb).to_s
      else
        ans += @nb.to_s
      end

      ans += "]"
      return ans
    end
  
    def print_tree(indent=0)
      ans = ""
      ans += "-"*indent*2 + self.inspect + "\n"

      for child in @children
        ans += child.print_tree(indent+1)
      end
    
      return ans
    end
  
    def print_best_branch_down()
      print_branch(get_best_branch_down)
    end
  
    def print_branch_up()
      print_branch(get_best_branch_up)
    end
  
    def get_best_child
      return nil if @children.empty?

    	best_score = 0
    	best_child = nil

      for child in @children
        return child if child.mode == WINNER
      
        if (child.mode==NORMAL && (!best_child || best_score<child.score))
    			best_score=child.score
    			best_child=child
    		end
      end
    
      return best_child if best_child
    
      raise "This node should be a winner node" unless @mode == WINNER #if all child are loosing then this is a winner node

      selected=rand(@children.size)
      puts "SEPUKU!!!  #{@children.size} #{selected}" if $DEBUG_OUT
      puts print_tree if $DEBUG_OUT
    
      return @children[selected]
    end

    def play_random_game(board, player) #board is a Board, player is a Token      
        lose_value=0.0
        draw_value=0.5
        win_value=1.0

        if (@father)
          raise unless player == self.class.other_player(@move.player)
        end
      
        raise unless mode==NORMAL

        if (@father)
          board.play_move(@move) #root as no move
        end

        if (@father && (winner = board.check_for_win) != NOT_PLAYED)
          # puts "win situation detected"
          # puts @move.print

          if winner == @move.player
        		propagate_winning_to_granpa 
      		else
      		  propagate_loosing_to_daddy
      		end

          return winner
        end

        unless @nb > 0
            @unexplored_moves = board.get_possible_moves(player)
            winner = board.play_random_game(player)

            raise @value.to_s unless not @value
            if(winner == NOT_PLAYED)
              @value = draw_value
            elsif (winner == @move.player)
              @value = win_value
            else
              @value = lose_value
            end
            @simulation_value = @value

            @nb = 1

            update_father(@value)
            return winner
        end

        unless @unexplored_moves.empty?
            move = @unexplored_moves.pop

            child = Node.new(:move => move, :uct_constant => @uct_constant, :father => self)
            @children.push(child)
            return child.play_random_game(board, self.class.other_player(player))
        end

        best_score = 0
        best_child = nil
      
        for child in @children
          if (not child.mode==LOSER)
            weight = @uct_constant*Math.sqrt(2.0*Math.log(@nb)/child.nb)
            if( !best_child || best_score < child.score + weight )
               best_score = child.score + weight
               best_child = child
            end
          end
        end

        if (not best_child)
          # puts "no child move possible"
          @value += draw_value
          @nb += 1
          return NOT_PLAYED
        end

        return best_child.play_random_game(board, self.class.other_player(player))
    end

  	def score
  	  return @value/@nb
  	  #returns a Float
  	end
	
  	def advance_and_detach(move) #move is a Move
  	 	raise unless not father

    	to_del = nil
    	for child in @children
    	  if @move.equal?(child.move)
    	    new_root = child
    	    new_root.father = nil
    	    to_del = child
    	    break
    	  end
    	end
    	@children.delete(to_del)

      return new_root if new_root
      return Node.new(:uct_constant=>@uct_constant)
  	end

    def print_branch(branch) #takes a ConstNodes
      ans = ""
      for node in branch
        ans += node.inspect
      end
      return ans
    end

    def get_best_branch_down
      branch = []
      current = self

      while (current && current.mode != WINNER)
          branch.push(current)
          current=current.get_best_child
      end

      return branch
    end
  
    def get_best_branch_up
      branch = []
      current = self

      while (current.father)
          branch.push(current)
          current=current.father
      end

      return branch
    end
  
    def update_father(value) #value is a Value
    
    end
  
    def propagate_winning_to_granpa
      @mode = WINNER
    
      if (@father)
          @father.mode = LOSER
          if (@father.father)
              @father.father.tell_granpa_dad_is_a_loser(@father)
          end
      end
    end
  
    def propagate_losing_to_daddy
      @mode = LOSER
    
      if (@father)
  	    @father.tell_granpa_dad_is_a_loser(self)
      end
    end
  
    def recompute_inheritance
      @nb = 1
      @value = @simulation_value
      for child in @children
          if (child.mode != LOSER) 
              @nb += child.nb
              @value += child.nb - child.value
          end
      end

      @father.recompute_inheritance() if @father
    end
  
    def tell_granpa_dad_is_a_loser(dad) #dad is a Node
      new_nb = 1
      new_value = @simulation_value
      for child in @children
          if (child.mode != LOSER) 
              new_nb += child.nb
              new_value += child.nb - child.value
          end
      end

      if (new_nb == 1) #all children are losers
          propagate_winning_to_granpa()
      else
          @nb = new_nb
          @value = new_value

          @father.recompute_inheritance if @father
      end
    end
  end
end