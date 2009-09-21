# Adapted from UCT implementation by Pierre Gueth and Joel Schaerer, Copyright 2009
# http://github.com/joelthelion/uct

require 'ai/uct/node.rb'
require 'ai/uct/board.rb'
require 'ai/uct/move.rb'
require 'ai/ai_uct.rb'

def play_game(player_a, player_b, board, max_move=nil)
  #FIXME check if there is a player one and a player two
	player_current = player_a
	winner = nil
	last_move = nil

  k = 0
	while ( !max_move || k < max_move)
		puts board.inspect
	
		puts "getting move..." if $DEBUG_OUT

		# get the move
		move = player_current.move(board, last_move);
	  raise "Move was nil" unless move
	  last_move = move

	  # actually play the move
	  board.play_move(move)

	  # check for win
	  winner_token = board.check_for_win
  	if (winner_token != UCT::Node::NOT_PLAYED)
  		winner = (winner_token == player_a.player ? player_a : player_b)
  		break
  	end

  	# switch player
  	player_current = (player_current==player_a ? player_b : player_a)

    k += 1
  end

  puts board.inspect 
	if (winner)
		puts "winner: #{winner.inspect}"
	else
		puts "draw"
	end

	return winner
end

class HumanPlayer
  attr_reader :name, :player
  
  def initialize(name, player)
    @name, @player = name, player
  end
  
  def move(board, last_move)
    puts "Your move..."
    n = STDIN.gets.chomp!.to_i
    UCT::Move.new(@player, n)
  end
  
  def inspect
    "Human (#{@name})"
  end
end

board = UCT::AIBoard.new()
player_a = AIUCT.new("Alice", UCT::Node::PLAYER_1, 1, 100)
player_b = HumanPlayer.new("T-$", UCT::Node::PLAYER_2)

$DEBUG_OUT = true
play_game(player_a, player_b, board)