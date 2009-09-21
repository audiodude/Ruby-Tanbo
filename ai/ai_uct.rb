class AIUCT
  attr_reader :player

  def initialize(name, player, max_sec=1.5, max_iteration=100, uct_constant=1)
    raise if player == UCT::Node::NOT_PLAYED
    @name = name
    @player = player
    @max_sec = max_sec
    @max_iteration = max_iteration
    @root = UCT::Node.new(:uct_constant=>uct_constant)
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
	  while ((!@max_iteration || k < @max_iteration) && @root.mode == UCT::Node::NORMAL && end_time - start_time < @max_sec)
      copy = board.deep_copy
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
      	when UCT::Node::NORMAL
      		print "normal #{best_child.score} "
      	when UCT::Node::WINNER
      		print "losing "
      	when UCT::Node::LOSER
      		print "winning "
    	end
      print "move "
      puts move.inspect
    end

    # play best_move
    @root = @root.advance_and_detach(move)
    puts "after playing best_move" if $DEBUG_OUT
    puts @root.print_tree if $DEBUG_OUT


  	copy = move.deep_copy
  	return copy
  end
end