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
  class Move
    attr_reader :player, :x, :y
  
  	def initialize(player=nil, x=nil, y=nil)
  	  @player, @x, @y = player, x, y
  	end

  	def deep_copy
  	  copy = Move.new(@player, @x, @y)
    	return copy
  	end
	
  	def inspect
  	  if @player != Node::NOT_PLAYED
  	    return "{[#{@x}, #{@y}] for player #{player}}"
    	else
    	  return "empty move"
    	end
  	end
	
  	def equal?(oth)
      return false if oth.player != @player 
      return false unless oth.x == @x
      return false unless oth.y == @y
      return true
  	end
  end
end