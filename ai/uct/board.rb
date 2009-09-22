# Adapted from UCT implementation by Pierre Gueth and Joel Schaerer, Copyright 2009
# http://github.com/joelthelion/uct

module UCT
  class AIBoard < TanboBoard

    def initialize()
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
      puts self.inspect
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