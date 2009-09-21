# Based on UCT implementation by Pierre Gueth and Joel Schaerer, Copyright 2009
require 'tanbo_board.rb'

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
    @move = opts[:move] || Move.new
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

class AIBoard

  attr_accessor :width, :height, :win_length, :played_count
  attr_accessor :lastmove, :tokens, :token_count

  def initialize(width=7,height=6,win_length=4)
    @width, @height, @win_length = width, height, win_length
    @lastmove = Move.new(Node::NOT_PLAYED, 0)
    @size = @width*@height
    @played_count = 0
    
    # token count per column
    @token_count = Array.new(@width, 0)

  	#allocate column pointer and playable move cache
  	@tokens = Array.new(@width) do |column|
  	  Array.new(@height, Node::NOT_PLAYED)
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
  			  when Node::NOT_PLAYED
  				  ans += " "
  			  when Node::PLAYER_1
  				  ans += "x"
  			  when Node::PLAYER_2
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
    move.player != Node::NOT_PLAYED &&
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

  	return Node::NOT_PLAYED
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
    winner = Node::NOT_PLAYED
  	player = next_player
  	while (self.play_random_move(player))
      winner = self.check_for_win

  		if winner != Node::NOT_PLAYED
  		  return winner
  		end
  		 
  		player=Node.other_player(player)
    end
  end
  
end

class AIUCT
  attr_reader :player
  
  def initialize(name, player, max_sec=1.5, max_iteration=100, uct_constant=1)
    raise if player == Node::NOT_PLAYED
    @name = name
    @player = player
    @max_sec = max_sec
    @max_iteration = max_iteration
    @root = Node.new(:uct_constant=>uct_constant)
  end

  def inspect
    "Bot (#{@name})"
  end

  def move(board, last_move)
    puts "playing move" if $DEBUG_OUT
    puts @root.print_tree if $DEBUG_OUT

    #reuse last simulations if possibles
	  @root=@root.advance_and_detach(last_move) if last_move
    saved_simulations=@root.nb

    puts "before simulations" if $DEBUG_OUT
    puts @root.print_tree if $DEBUG_OUT
    
    k = 0
    start_time = end_time = Time.now.to_f
	  while ((!@max_iteration || k < @max_iteration) && @root.mode == Node::NORMAL && end_time - start_time < @max_sec)
      copy = board.dup
      winner = @root.play_random_game(copy, @player)
      k += 1
      end_time = Time.now.to_f
		end

	  best_child = @root.get_best_child
  	raise "Best child is nil" unless best_child

    move = best_child.move

    puts "after simulations" if $DEBUG_OUT
    puts @root.print_tree if $DEBUG_OUT
    puts @root.print_best_branch_down if $DEBUG_OUT

  	# simulation report
    puts "simulated #{k} games (#{saved_simulations} saved) in #{end_time-start_time}"if $DEBUG_OUT

  	# move report
  	if $DEBUG_OUT
      print "playing "
    	case @root.mode
      	when Node::NORMAL
      		print "normal #{best_child.score} "
      	when Node::WINNER
      		print "losing "
      	when Node::LOSER
      		print "winning "
    	end
      print "move "
      puts move.inspect
    end
  
    # play best_move
    @root = @root.advance_and_detach(move)
    puts "after playing best_move" if $DEBUG_OUT
    puts @root.print_tree if $DEBUG_OUT


  	copy = move.dup
  	return copy
  end
end

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
  	if (winner_token != Node::NOT_PLAYED)
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
    Move.new(@player, n)
  end
  
  def inspect
    "Human (#{@name})"
  end
end

# board = AIBoard.new()
# player_a = AIUCT.new("Alice", Node::PLAYER_1, 1, 100)
# player_b = HumanPlayer.new("T-$", Node::PLAYER_2)
# 
# $DEBUG_OUT = true
# play_game(player_a, player_b, board)
