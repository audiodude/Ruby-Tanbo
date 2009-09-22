# Adapted from UCT implementation by Pierre Gueth and Joel Schaerer, Copyright 2009
# http://github.com/joelthelion/uct

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