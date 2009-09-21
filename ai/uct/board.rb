# Adapted from UCT implementation by Pierre Gueth and Joel Schaerer, Copyright 2009
# http://github.com/joelthelion/uct

module UCT
  class AIBoard

    attr_accessor :width, :height, :win_length, :played_count
    attr_accessor :lastmove, :tokens, :token_count

    def initialize(width=7,height=6,win_length=4)
      @width, @height, @win_length = width, height, win_length
      @lastmove = UCT::Move.new(UCT::Node::NOT_PLAYED, 0)
      @size = @width*@height
      @played_count = 0
    
      # token count per column
      @token_count = Array.new(@width, 0)

    	#allocate column pointer and playable move cache
    	@tokens = Array.new(@width) do |column|
    	  Array.new(@height, UCT::Node::NOT_PLAYED)
    	end
    end

    def dup
      copy = AIBoard.new(@width, @height, @win_length)

      #copy last move and played_count
      copy.lastmove = @lastmove
      copy.played_count = @played_count
    
      copy.tokens = Array.new(@width) do |column|
    	  @tokens[column].dup
    	end
      copy.token_count = @token_count.dup
    
      return copy
    end
  
    def inspect
      #     ans = " #"
      #     0.upto(@width-1) do |column|
      #   ans += @token_count[column].to_s
      # end
      # ans += "\n  "
      ans = "  "
    	0.upto(@width-1) do |column|
    	  ans += column.to_s
    	end
    	ans += "\n"

    	ans += " +"
    	0.upto(@width-1) do
    	  ans += "-"
    	end
    	ans += "+\n"

      (@height-1).downto(0) do |row|
        ans += row.to_s + "|"
        0.upto(@width-1) do |column|
          case @tokens[column][row]
    			  when UCT::Node::NOT_PLAYED
    				  ans += " "
    			  when UCT::Node::PLAYER_1
    				  ans += "x"
    			  when UCT::Node::PLAYER_2
    				  ans += "o"
    			end
      	end
      	ans += "|\n"
      end

    	ans += " +"
    	0.upto(@width-1) do |column|
    	  ans += "-"
    	end
    	ans += "+\n"

      ans += "  "
    	0.upto(@width-1) do |column|
    	  ans += column.to_s
    	end
    	ans += "\n"

      return ans
    end
  
    def valid_move?(move)
      move.player != UCT::Node::NOT_PLAYED &&
      move.column >= 0 &&
      move.column < @width &&
      @token_count[move.column] < @height 
    end
  
    def get_possible_moves(player)
      moves = []

    	0.upto(@width-1) do |column|
    	  unless @token_count[column] == @height
    	    moves << Move.new(player, column)
    	  end
    	end

    	return moves
    end
  
    def play_move(move)
    	raise move.inspect unless self.valid_move?(move)

    	@tokens[move.column][@token_count[move.column]] = move.player
    	@token_count[move.column] += 1

    	@played_count += 1
    	@lastmove = move
    end
  
    def play_random_move(player)
      if (@played_count<@size)
    		possible_moves = get_possible_moves(player)

    		selected = rand(possible_moves.size)
    		move = possible_moves[selected]
    		play_move(move)

    		return true
    	else
    		puts "board full" if $DEBUG_OUT
    		return false
    	end
    end
  
    def check_for_win
      column = @lastmove.column
      row = @token_count[column]-1

      # Can't win with moves above us!
      top_length = self.propagate(row, column, 1, 0, @lastmove.player)
    	unless top_length == 1
    	  puts self.inspect
    	  puts "#{row}:#{column}" 
    	  raise top_length.to_s + " should have been 1"
    	end
  	
      return @lastmove.player if (self.propagate(row,column,-1,0,@lastmove.player)+1 > win_length) ||
        (self.propagate(row,column, 0, 1,lastmove.player) + self.propagate(row,column, 0,-1,lastmove.player)>win_length) ||
        (self.propagate(row,column,-1, 1,lastmove.player) + self.propagate(row,column, 1,-1,lastmove.player)>win_length) ||
        (self.propagate(row,column,-1,-1,lastmove.player) + self.propagate(row,column, 1, 1,lastmove.player)>win_length)

    	return UCT::Node::NOT_PLAYED
    end
  
    def propagate(row, column, drow, dcolumn, player)
      length = 0
      while (row>=0 && row<height && column>=0 && column<width && @tokens[column][row] == player)
          length += 1
          row += drow
          column += dcolumn
      end

  	  return length
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