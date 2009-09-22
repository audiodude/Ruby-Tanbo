require 'root.rb'
require 'tanbo_board.rb'

# The conroller, which stores the state of the game, calculates
# valid moves, and calculates the effects of moves.
class MainController
  attr_reader :roots
  attr_accessor :modified, :player1, :player2

  def initialize
    reset!
  end
  
  # Set up the game board and game conditions. This method is called from
  # initialize, and is the appropriate method for "New game" functionality.
  def reset!
    # The game board is a 19x19 2D grid of intersections (a Go board)
    @gameboard = TanboBoard.new

    @gameboard.turn = TanboBoard::BLACK

    # Set all the initial white pieces
    init_white = [
      @gameboard[6 ,0 ], @gameboard[18,0 ],
      @gameboard[0 ,6 ], @gameboard[12,6 ],
      @gameboard[6 ,12], @gameboard[18,12],
      @gameboard[0 ,18], @gameboard[12,18]
    ]
    init_white.each do |point|
      point.color = TanboBoard::WHITE
      @gameboard.roots << @gameboard.add_point_to_root(point, Root.new(TanboBoard::WHITE))
    end
    
    # And all of the initial black ones
    init_black = [
      @gameboard[0 ,0 ], @gameboard[12,0 ],
      @gameboard[6 ,6 ], @gameboard[18,6 ],
      @gameboard[12,12], @gameboard[18,18],
      @gameboard[6 ,18], @gameboard[0 ,12]
    ]
    init_black.each do |point|
      point.color = TanboBoard::BLACK
      @gameboard.roots << @gameboard.add_point_to_root(point, Root.new(TanboBoard::BLACK))
    end
  end
  
  def start!
    Thread.new {
      raise "Player 1 not set!" unless @player1
      raise "Player 2 not set!" unless @player2
  
      while not game_over?
        if @gameboard.turn == TanboBoard::BLACK
          next_move = @player1.move
        else
          next_move = @player2.move
        end
        next unless next_move
    
        move_point = @gameboard[next_move[0], next_move[1]]
        adj = valid_move?(move_point)
        next unless adj
    
        make_move(move_point, adj)
      end
    }
  end
  
  def set_board(board)
    @gameboard = board
  end
  
  def get_board
    @gameboard
  end
  
  def get_color(point)
    if point.in_bounds?
      point.color
    else
      nil
    end
  end
  
  ## Convenience for auto-playing for debug. This is the same logic as
  ## Randbo, but this is NOT the code that Randbo runs. See ai/randbo.rb
  def random_move
    return if game_over?
    
    moves = @gameboard.get_all_moves
    return if moves.empty? #Guard against race conditions
    chosen = moves.keys[rand(moves.keys.size)]
    make_move(chosen, moves[chosen])
  end
  ## End convenience auto-play code
  
  def blank?(point)
    return point.color == TanboBoard::BLANK
  end
  
  alias :empty? :blank?
  
  def debug
    require 'pp'
    
    @gameboard.roots.each do |r|
      puts r.inspect
      puts "=========="
    end

    puts "-"*10
    puts output_board
  end
  
  # Store a simple text representation of the game board. It looks like this:
  # b.....w.....b.....w
  # ...................
  # ...................
  # ...................
  # ...................
  # ...................
  # w.....b.....w.....b
  # ...................
  # ...................
  # ...................
  # ...................
  # ...................
  # b.....w.....b.....w
  # ...................
  # ...................
  # ...................
  # ...................
  # ...................
  # w.....b.....w......
  def output_board
    ans = ''
    0.upto(18) do |x|
      0.upto(18) do |y|
        case @gameboard[y, x].color
          when TanboBoard::WHITE
            ans += 'w'
          when TanboBoard::BLACK
            ans += 'b'
          when TanboBoard::BLANK
            ans += '.'
        end
      end
      ans += "\n"
    end
    ans += (@gameboard.turn == TanboBoard::WHITE ? "WHITE" : "BLACK")
    ans += "\n"
    return ans
  end
  
  # Parse a string in the above format (including newlines) and set the state
  # of the game board accordingly
  def parse_board(str)
    return unless str
    @gameboard = TanboBoard.new
    @roots = []
    
    chars = str.split(/\n/).collect { |line|
      line.scan(/WHITE|BLACK|./m)
    }.flatten
    
    0.upto(18) do |x|
      0.upto(18) do |y|
        c = chars.shift
        case c
          when 'w'
            @gameboard[y, x].color = TanboBoard::WHITE
          when 'b'
            @gameboard[y, x].color = TanboBoard::BLACK
          when '.'
            @gameboard[y, x].color = TanboBoard::BLANK
        end
      end
    end
    
    if(chars.shift == "WHITE")
      @gameboard.turn = TanboBoard::WHITE
    else
      @gameboard.turn = TanboBoard::BLACK
    end
    
    create_roots
  end
  
  def create_roots
    visited = {}
    0.upto(18) do |x|
      0.upto(18) do |y|
        point = @gameboard[x, y]
        # Skip this square if it's already been visited by one of the dfs runs
        next if visited[point]
        
        # Mark as visited, but skip if its empty
        if point.color == TanboBoard::BLANK
          visited[point] = true
          next
        end
        
        # Create a new root for this square and add it to @pts_to_root and @roots
        # The point is marked as visited in this method
        new_root = Root.new(point.color)
        @gameboard.roots << new_root
        dfs_add_to_root(point, new_root, visited)
      end
    end
  end
  
  # Add
  def dfs_add_to_root(point, root, visited)
    visited[point] = true
    if(point.color == root.color)
      add_point_to_root(point, root)
    end
    point.bounded_neighbors.each do |neighbor|
      if (! visited.include?(neighbor)) and neighbor.color == root.color
        dfs_add_to_root(neighbor, root, visited)
      end
    end
  end

end