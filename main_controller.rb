require 'root.rb'
require 'tanbo_board.rb'
require "observer"


# The conroller, which stores the state of the game, calculates
# valid moves, and calculates the effects of moves.
class MainController
  include Observable

  BOARD_UPDATE_EVENT = -100
  BLACK_WINS_EVENT = -11
  WHITE_WINS_EVENT = -22
  
  attr_reader :roots
  attr_accessor :modified, :player1, :player2

  def initialize
    reset!
  end
  
  # Set up the game board and game conditions. This method is called from
  # initialize, and is the appropriate method for "New game" functionality.
  def reset!
    @turn = TanboBoard::BLACK

    # The game board is a 19x19 2D grid of intersections (a Go board)
    @gameboard = TanboBoard.new

    # A root is a group of pieces of the same color, connected
    # Each of the initial pieces represents a root, and roots are
    # never added to the game, only removed.
    # A root is created for each of the initial pieces in the loops below,
    # and that piece is assigned to the root.
    @roots = []

    # Set all the initial white pieces
    init_white = [
      @gameboard[6 ,0 ], @gameboard[18,0 ],
      @gameboard[0 ,6 ], @gameboard[12,6 ],
      @gameboard[6 ,12], @gameboard[18,12],
      @gameboard[0 ,18], @gameboard[12,18]
    ]
    init_white.each do |point|
      point.color = TanboBoard::WHITE
      @roots << add_point_to_root(point, Root.new(TanboBoard::WHITE))
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
      @roots << add_point_to_root(point, Root.new(TanboBoard::BLACK))
    end
  end
  
  def start!
    Thread.new {
      raise "Player 1 not set!" unless @player1
      raise "Player 2 not set!" unless @player2
  
      while not game_over?
        if whose_turn? == TanboBoard::BLACK
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
  def get_all_moves(color=nil)
    color = whose_turn? unless color
    
    ans = {}
    0.upto(18) {|x|
      0.upto(18) {|y|
        next_point = @gameboard[x, y]
        adj_point = valid_move?(next_point, color)
        ans[next_point] = adj_point if adj_point
      }
    }
    return ans
  end
  
  def random_move
    return if game_over?
    
    moves = get_all_moves
    return if moves.empty? #Guard against race conditions
    chosen = moves.keys[rand(moves.keys.size)]
    make_move(chosen, moves[chosen])
  end
  ## End convenience auto-play code
  
  def whose_turn?
    return @turn
  end
  
  # If the game is not over, return nil
  # Otherwise, return the color constant (WHITE or BLACK) of the side that has
  # won the game
  def game_over?
    return nil unless @roots
    return @roots.first.color if @roots.size == 1
    winning_color = nil
    for root in @roots
      if winning_color 
        # There is no winner if we find a root with a different color than the
        # first color
        return nil if winning_color != root.color
      else
        # We haven't seen any colors yet. The first one we see is
        # the potential winner
        winning_color = root.color
      end
    end
    # If we got here, every root in the array matches the color of the first root
    return winning_color
  end
  
  def blank?(point)
    return point.color == TanboBoard::BLANK
  end
  
  alias :empty? :blank?
  
  # Check if the given board location is a valid move for the given color.
  # If no color is given, the check is performed for the whichever color
  # currently has control of the board.
  #
  # Returns an array [x, y] of the board location of the piece that makes
  # this a valid move, or nil if there is no such piece. Always returns nil
  # when the game is in the BLACK_WINS or WHITE_WINS state.
  def valid_move?(point, color=nil)    
    x,y = point.x, point.y
    color = whose_turn? unless color
    
    # Valid moves are in within the bounds of the board
    return nil if x < 0 || y < 0 || x > 18 || y > 18
    
    # The location must be blank for the move to be valid
    return nil unless blank?(point)
    
    adjacent = false
    answer = nil
    if x-1 >= 0 #Check the location to the west
      adj_point = @gameboard[x-1, y]
      if adj_point.color == color
        # The west location is the same color as the queried location.
        # For now, this is the answer, unless there are other adjacent
        # pieces, in which case this ceases to be a valid move
        answer = adj_point
        adjacent = true
      end
    end
    if y-1 >= 0 #North location
      adj_point = @gameboard[x, y-1]
      if adj_point.color == color
        # This is the answer, unless we have already found an adajcent piece
        answer = (adjacent ? nil : adj_point)
        adjacent = true
      end
    end
    if x+1 < 19 #East location
      adj_point = @gameboard[x+1, y]
      if adj_point.color == color
        # Ditto
        answer = (adjacent ? nil : adj_point)
        adjacent = true
      end
    end
    if y+1 < 19 #South location
      adj_point = @gameboard[x, y+1]
      if adj_point.color == color
        # Ditto
        answer = (adjacent ? nil : adj_point)
        adjacent = true
      end
    end
    
    #puts "----#{point.inspect} -> #{answer.inspect}"
    return answer
  end
  
  # Adds the given point to the given root. This puts the point in the roots
  # points array, and calculates any liberties that should be added or removed
  # based on the value of the new point's neighbors.
  #
  # Returns the root, as a convenience for method chaining
  def add_point_to_root(point, root)
    # Add the point to the points, delete it from the available liberties
    point.root = root
    root.points << point
    root.liberties.delete(point)
    
    # Check each neighbor. If it's a valid move, it's a liberty. Otherwise,
    # it's not (remove it in case it was previously).
    point.bounded_neighbors.each do |pair|
      if valid_move?(pair, root.color)
        root.liberties << pair
      else
        root.liberties.delete(pair)
      end
    end
    
    
    return root
  end
  
  def remove_root_pieces(root)
    for point in root.points
      point.color = TanboBoard::BLANK
    end
  end
  
  # Place a piece of the color of the current turn at the indicated x,y
  # location. 'adj' represents the piece that this piece will be adjacent
  # to, and allows us to calculate which root this piece is a part of.
  #
  # After the piece is place, calculations are done to see if any roots have
  # become bounded. If so, roots are immediately removed according to the
  # games bounding rules.
  #
  # If the BLACK_WINS or WHITE_WINS state is in effect, this is a no op.
  def make_move(point, adj)
    return if game_over?
    unless point
      #debug 
      raise ArgumentError, "nil value given for move"
    end
    
    @modified = true
    
    #print point.inspect + ", "
    x,y = point
    
    # Find the root that the newly placed piece is a part of
    cur_root = adj.root
    unless cur_root 
      #puts "@pts_to_root: #{@pts_to_root.inspect}"
      raise "Could not find root for pt: " + adj.inspect 
    end
    
    # Set the give location to the current turn's color
    point.color = @turn
    
    # Switch turn control
    mover = @turn
    @turn = (@turn == TanboBoard::BLACK ? TanboBoard::WHITE : TanboBoard::BLACK)
    
    # Add the point to the root, which causes the root's "valid moves" to be
    # recalculated
    add_point_to_root(point, cur_root)
    
    other_bounded = []
    # Get the new piece's neighbor's neighbors. If they contain roots,
    # let those roots recalculate if their liberties are still valid.
    for neighbor in point.neighbors
      # Skip the neighbor that allowed us to place the piece, and any
      # non-empty points. The status of filled points doesn't change
      # by placing a piece.    
      next if neighbor == adj || neighbor.color != TanboBoard::BLANK
      
      for next_neighbor in neighbor.neighbors
        next_root = next_neighbor.root
        if next_root && next_root != cur_root && next_root.color == cur_root.color
          # There is a root next to one of the new pieces neighbors, and it is
          # the same color as the root of this piece. That neighbor, therefore,
          # is no longer a liberty for that root.
          next_root.remove_point(neighbor)
        end
      end
    end
    
    # Now check every root
    for root in @roots
      # The current move is no longer a valid liberty of any root
      root.remove_point(point)
      
      # If the root has become bounded, keep track of it.
      if root.bounded? && root != cur_root
        other_bounded << root
      end
    end
    
    # If the current root is bounded, remove all of it's pieces and delete it
    # from the list of roots (effectively removing it from the board)
    if cur_root.bounded?
      remove_root_pieces(cur_root)
      @roots.delete(cur_root)
    else
      # Otherwise, similarly delete any other roots that have been bounded    
      if not other_bounded.empty?
        for root in other_bounded
          remove_root_pieces(root)
          @roots.delete(root)
        end
      end
    end
    
    changed
    notify_observers(BOARD_UPDATE_EVENT)
    
    # There can be only one...
    if winning_color = game_over? #Intentional assignment, returns nil if no one has won
      event = (winning_color == TanboBoard::WHITE ? WHITE_WINS_EVENT : BLACK_WINS_EVENT)
      changed
      notify_observers(event)
    end
  end
  
  def remove!(point)
    @modified = true
    @gameboard[point[0]][point[1]].color = TanboBoard::BLANK
  end
  
  def debug
    require 'pp'
    
    @roots.each do |r|
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
    ans += (@turn == TanboBoard::WHITE ? "WHITE" : "BLACK")
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
      @turn = TanboBoard::WHITE
    else
      @turn = TanboBoard::BLACK
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
        @roots << new_root
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