# Adapted from UCT implementation by Pierre Gueth and Joel Schaerer, Copyright 2009
# http://github.com/joelthelion/uct

module UCT
  class Move
    attr_reader :player, :column
  
  	def initialize(player=nil, column=nil)
  	  @player, @column = player, column
  	end

  	def dup
  	  copy = Move.new(@player, @column)
    	return copy
  	end
	
  	def inspect
  	  if @player != Node::NOT_PLAYED
  	    return "{column #{@column} for player #{player}}"
    	else
    	  return "c4 null move"
    	end
  	end
	
  	def equal?(oth)
      return false if oth.player != @player 
      return false unless oth.move.equal?(@move) 
      return true
  	end
  end
end