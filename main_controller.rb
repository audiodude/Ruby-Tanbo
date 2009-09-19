require 'root.rb'
require "observer"


# The conroller, which stores the state of the game, calculates
# valid moves, and calculates the effects of moves.
class MainController
  include Observable

  BLACK_WINS_EVENT = -11
  WHITE_WINS_EVENT = -22
  
  WHITE = 1
  EMPTY = BLANK = 0
  BLACK = -1
  
  attr_accessor :modified

  def self.neighbors(point)
    x,y = point
    return [ [x+1, y], [x, y+1], [x-1, y], [x, y-1] ]
  end
  
  def self.in_bounds?(point)
    x,y = point
    return false if x < 0
    return false if x > 18
    return false if y < 0
    return false if y > 18
    
    return true
  end
  
  def self.bounded_neighbors(point)
    return self.neighbors(point).select do |pt|
      self.in_bounds?(pt)
    end
  end

  def initialize
    reset!
  end
  
  # Set up the game board and game conditions. This method is called from
  # initialize, and is the appropriate method for "New game" functionality.
  def reset!
   @turn = BLACK

    # The game board is  2D 19x19 array
    @gameboard = []
    19.times do
      @gameboard << Array.new(19, 0)
    end

    # Set all the initial white pieces
    @gameboard[6][0] = @gameboard[18][0] = @gameboard[0][6] =
    @gameboard[12][6] = @gameboard[6][12] = @gameboard[18][12] =
    @gameboard[0][18] = @gameboard[12][18] = 1

    # And all of the initial black ones
    @gameboard[0][0] = @gameboard[12][0] = @gameboard[6][6] =
    @gameboard[18][6] = @gameboard[12][12] = @gameboard[18][18] =
    @gameboard[6][18] = @gameboard[0][12] = -1

    # A root is a group of pieces of the same color, connected
    # Each of the initial pieces represents a root, and roots are
    # never added to the game, only removed
    # TODO : Need a better data structure...
    @roots = [
       Root.new([6 , 0 ],  1, self),
       Root.new([18, 0 ],  1, self),
       Root.new([0 , 6 ],  1, self),
       Root.new([12, 6 ],  1, self),
       Root.new([6 , 12],  1, self),
       Root.new([18, 12],  1, self),
       Root.new([0 , 18],  1, self),
       Root.new([12, 18],  1, self),
       Root.new([0 , 0 ], -1, self),
       Root.new([12, 0 ], -1, self),
       Root.new([6 , 6 ], -1, self),
       Root.new([18, 6 ], -1, self),
       Root.new([12, 12], -1, self),
       Root.new([18, 18], -1, self),
       Root.new([6 , 18], -1, self),
       Root.new([0 , 12], -1, self)
    ]
    @pts_to_root = {
       [6 , 0 ] => @roots[0],
       [18, 0 ] => @roots[1],
       [0 , 6 ] => @roots[2],
       [12, 6 ] => @roots[3],
       [6 , 12] => @roots[4],
       [18, 12] => @roots[5],
       [0 , 18] => @roots[6],
       [12, 18] => @roots[7],
       [0 , 0 ] => @roots[8],
       [12, 0 ] => @roots[9],
       [6 , 6 ] => @roots[10],
       [18, 6 ] => @roots[11],
       [12, 12] => @roots[12],
       [18, 18] => @roots[13],
       [6 , 18] => @roots[14],
       [0 , 12] => @roots[15],
    }
  end
  
  def set_board(board)
    @board = board
  end
  
  def get_board
    @gameboard
  end
  
  def get_color(point)
    if self.class.in_bounds?(point)
      @gameboard[point[0]][point[1]]
    else
      nil
    end
  end
  
  def get_all_moves(color=nil)
    color = whose_turn? unless color
    
    ans = {}
    0.upto(18) {|x|
      0.upto(18) {|y|
        test = valid_move?([x, y], color)
        ans[[x, y]] = test if test
      }
    }
    return ans
  end
  
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
        return nil if winning_color != root.color
      else
        winning_color = root.color
      end
    end
    # If we got here, every root in the array matches the color of the first root
    return winning_color
  end
  
  def blank?(point)
    return @gameboard[point[0]][point[1]] == 0
  end
  
  # Check if the given board location is a valid move for the given color.
  # If no color is given, the check is performed for the whichever color
  # currently has control of the board.
  #
  # Returns an array [x, y] of the board location of the piece that makes
  # this a valid move, or nil if there is no such piece. Always returns nil
  # when the game is in the BLACK_WINS or WHITE_WINS state.
  def valid_move?(point, color=nil)
    return nil if game_over?
    
    x,y = point
    color = whose_turn? unless color
    
    # Valid moves are in within the bounds of the board
    return nil if x < 0 || y < 0 || x > 18 || y > 18
    
    # The location must be blank for the move to be valid
    return nil unless blank?(point)
    
    adjacent = false
    answer = nil
    if x-1 >= 0 #Check the location to the west
      if @gameboard[x-1][y] == color
        # The west location is the same color as the queried location.
        # For now, this is the answer, unless there are other adjacent
        # pieces, in which case this ceases to be a valid move
        answer = [x-1, y]
        adjacent = true
      end
    end
    if y-1 >= 0 #North location
      if @gameboard[x][y-1] == color
        # This is the answer, unless we have already found an adajcent piece
        answer = (adjacent ? nil : [x, y-1])
        adjacent = true
      end
    end
    if x+1 < 19 #East location
      if @gameboard[x+1][y] == color
        # Ditto
        answer = (adjacent ? nil : [x+1, y])
        adjacent = true
      end
    end
    if y+1 < 19 #South location
      if @gameboard[x][y+1] == color
        # Ditto
        answer = (adjacent ? nil : [x, y+1])
        adjacent = true
      end
    end
    
    return answer
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
    cur_root = @pts_to_root[adj]
    unless cur_root 
      #puts "@pts_to_root: #{@pts_to_root.inspect}"
      raise "Could not find root for pt: " + adj.inspect 
    end
    
    # Set the give location to the current turn's color
    @gameboard[x][y] = @turn
    
    # Switch turn control
    mover = @turn
    @turn = (@turn == BLACK ? WHITE : BLACK)
    
    # Add the point to the root, which causes the root's "valid moves" to be
    # recalculated
    cur_root.add_point(point)
    
    #Make this board location hash to the root it's in, for later lookups
    @pts_to_root[point] = cur_root
    
    other_bounded = []
    # Get the new piece's neighbor's neighbors. If they contain roots,
    # let those roots recalculate if their liberties are still valid.
    for neighbor in self.class.neighbors(point)
      # Skip the neighbor that allowed us to place the piece, and any
      # non-empty points. The status of filled points doesn't change
      # by placing a piece.    
      next if neighbor == adj || get_color(neighbor) != BLANK
      
      for next_neighbor in self.class.neighbors(neighbor)
        next_root = @pts_to_root[next_neighbor]
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
      cur_root.remove!
      @roots.delete(cur_root)
    else
      # Otherwise, similarly delete any other roots that have been bounded    
      if not other_bounded.empty?
        for root in other_bounded
          root.remove!
          @roots.delete(root)
        end
      end
    end
    
    # There can be only one...
    if winning_color = game_over? #Intentional assignment, returns nil if no one has won
      event = (winning_color == WHITE ? WHITE_WINS_EVENT : BLACK_WINS_EVENT)
      changed
      notify_observers(event)
    end
  end
  
  def remove!(point)
    @modified = true
    @gameboard[point[0]][point[1]] = 0
  end
  
  def random_move
    return if game_over?
    
    moves = get_all_moves
    return if moves.empty? #Guard against race conditions
    chosen = moves.keys[rand(moves.keys.size)]
    make_move(chosen, moves[chosen])
  end
  
  def debug
    require 'pp'
    
    @pts_to_root.values.uniq.each do |r|
      puts r.inspect
      puts "=========="
    end

    puts "-"*10
    puts output_board
    puts "-"*10
    pp @pts_to_root.keys
    
    output_board
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
    0.upto(@gameboard.size-1) do |x|
      0.upto(@gameboard[x].size-1) do |y|
        case @gameboard[y][x]
          when 1
            ans += 'w'
          when -1
            ans += 'b'
          when
            ans += '.'
        end
      end
      ans += "\n"
    end
    ans += (@turn == WHITE ? "WHITE" : "BLACK")
    ans += "\n"
    return ans
  end
  
  # Parse a string in the above format (including newlines) and set the state
  # of the game board accordingly
  def parse_board(str)
    return unless str
    
    chars = str.split(/\n/).collect { |line|
      line.scan(/WHITE|BLACK|./m)
    }.flatten
    
    @gameboard = []
    19.times do
      @gameboard << Array.new(19, 0)
    end
    
    0.upto(@gameboard.size-1) do |x|
      0.upto(@gameboard[x].size-1) do |y|
        c = chars.shift
        case c
          when 'w'
            @gameboard[y][x] = 1
          when 'b'
            @gameboard[y][x] = -1
          when '.'
            @gameboard[y][x] = 0
        end
      end
    end
    
    if(chars.shift == "WHITE")
      @turn = WHITE
    else
      @turn = BLACK
    end
    
    reset_roots
  end
  
  def reset_roots
    @pts_to_root = {}
    
    visited = []
    0.upto(@gameboard.size-1) do |x|
      0.upto(@gameboard[x].size-1) do |y|
        color = @gameboard[x][y]
        visited << [x,y]
        case color
          when WHITE
            
          when BLACK
            
          when '.'
            
        end
      end
    end
   
    @pts_to_root.values.each do |r|
      r.recalculate!.each do |point|
        @pts_to_root[point] = r
      end
    end
  end

end