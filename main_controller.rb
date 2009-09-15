require 'root.rb'

# The conroller, which stores the state of the game, calculates
# valid moves, and calculates the effects of moves.
class MainController

  WHITE = 1
  EMPTY = BLANK = 0
  BLACK = -1

  def self.neighbors(point)
    x,y = point
    return [ [x+1, y], [x, y+1], [x-1, y], [x, y-1] ]
  end

  def initialize
    @turn = -1
    
    # The game board is  2D 20x20 array
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
    # Each of the initial pieces represents a roots, and roots are
    # never added to the game, only removed
    @roots = { [6 , 0 ] => Root.new([6, 0], 1, self),
               [18, 0 ] => Root.new([18, 0], 1, self),
               [0 , 6 ] => Root.new([0, 6], 1, self),
               [12, 6 ] => Root.new([12, 6], 1, self),
               [6 , 12] => Root.new([6, 12], 1, self),
               [18, 12] => Root.new([18, 12], 1, self),
               [0 , 18] => Root.new([0, 18], 1, self),
               [12, 18] => Root.new([12, 18], 1, self),
    
               [0 , 0 ] => Root.new([0, 0], -1, self),
               [12, 0 ] => Root.new([12, 0], -1, self),
               [6 , 6 ] => Root.new([6, 6], -1, self),
               [18, 6 ] => Root.new([18, 6], -1, self),
               [12, 12] => Root.new([12, 12], -1, self),
               [18, 18] => Root.new([18, 18], -1, self),
               [6 , 18] => Root.new([6, 18], -1, self),
               [0 , 12] => Root.new([0, 12], -1, self)
             }
    @debug_root = @roots[[0,6]]
  end
  
  def set_board(board)
    @board = board
  end
  
  def get_board
    @gameboard
  end
  
  def get_color(point)
    return @gameboard[point[0]][point[1]]
  end
  
  def whose_turn?
    return @turn
  end
  
  def blank?(point)
    return @gameboard[point[0]][point[1]] == 0
  end
  
  # Check if the given board location is a valid move for the given color.
  # If no color is given, the check is performed for the whichever color
  # currently has control of the board.
  #
  # Returns an array [x, y] of the board location of the piece that makes
  # this a valid move, or nil if there is no such piece.
  def valid_move?(point, color=nil)
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
  def make_move(point, adj)
    #print point.inspect + ", "
    x,y = point
    # Set the give location to the current turn's color
    @gameboard[x][y] = @turn
    
    # Switch turn control
    @turn = (@turn == -1 ? 1 : -1)
    
    # Find the root that the newly placed piece is a part of
    cur_root = @roots[adj]
    cur_root.add_point(point)
    #Make this board location hash to the root it's in
    @roots[point] = cur_root 
    other_bounded = []
    
    # Get the new piece's neighbor's neighbors. If they contain roots,
    # let those roots recalculate if their liberties are still valid.
    for neighbor in self.class.neighbors(point)
      # Skip the neighbor that allowed us to place the piece, and any
      # non-empty points. The status of filled points doesn't change
      # by placing a piece.    
      next if neighbor == adj || get_color(neighbor) != BLANK
      
      for next_neighbor in self.class.neighbors(neighbor)
        next_root = @roots[next_neighbor]
        if next_root && next_root != cur_root && next_root.color == cur_root.color
          # There is a root next to one of the new pieces neighbors, and it is
          # the same color as the root of this piece. That neighbor, therefore,
          # is no longer a liberty for that root.
          next_root.remove_point(neighbor)
        end
      end
    end
    
    # Now check every root
    for root in @roots.values
      # The current move is no longer a valid liberty of any root
      root.remove_point(point)
      
      # If the root has become bounded, keep track of it.
      if root.bounded?
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
  end
  
  def remove!(point)
    @gameboard[point[0]][point[1]] = 0
  end
  
  def debug
    require 'pp'
    pp @gameboard
    puts "-"*10
    @roots.values.uniq.each do |r|
      puts r.inspect
      puts "=========="
    end
    
    puts output_board
    parse_board(output_board)
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
    return ans
  end
  
  # Parse a string in the above format (including newlines) and set the state
  # of the game board accordingly
  def parse_board(str)
    return unless str
    
    chars = str.split(/\n/).collect { |line|
      line.scan(/./m)
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
  end
  
  def reset_roots
    @roots = {}
                                       
    next_root = @roots[[6 , 0 ]] = Root.new([6 , 0 ], 1 , self) if \
                                                @gameboard[[6 , 0 ]] == 1   
    next_root = @roots[[18, 0 ]] = Root.new([18, 0 ], 1 , self) if \
                                                @gameboard[[18, 0 ]] == 1   
    next_root = @roots[[0 , 6 ]] = Root.new([0 , 6 ], 1 , self) if \
                                                @gameboard[[0 , 6 ]] == 1   
    next_root = @roots[[12, 6 ]] = Root.new([12, 6 ], 1 , self) if \
                                                @gameboard[[12, 6 ]] == 1   
    next_root = @roots[[6 , 12]] = Root.new([6 , 12], 1 , self) if \
                                                @gameboard[[6 , 12]] == 1   
    next_root = @roots[[18, 12]] = Root.new([18, 12], 1 , self) if \
                                                @gameboard[[18, 12]] == 1   
    next_root = @roots[[0 , 18]] = Root.new([0 , 18], 1 , self) if \
                                                @gameboard[[0 , 18]] == 1   
    next_root = @roots[[12, 18]] = Root.new([12, 18], 1 , self) if \
                                                @gameboard[[12, 18]] == 1   
    next_root = @roots[[0 , 0 ]] = Root.new([0 , 0 ], -1, self) if \
                                                @gameboard[[0 , 0 ]] == -1  
    next_root = @roots[[12, 0 ]] = Root.new([12, 0 ], -1, self) if \
                                                @gameboard[[12, 0 ]] == -1  
    next_root = @roots[[6 , 6 ]] = Root.new([6 , 6 ], -1, self) if \
                                                @gameboard[[6 , 6 ]] == -1  
    next_root = @roots[[18, 6 ]] = Root.new([18, 6 ], -1, self) if \
                                                @gameboard[[18, 6 ]] == -1  
    next_root = @roots[[12, 12]] = Root.new([12, 12], -1, self) if \
                                                @gameboard[[12, 12]] == -1  
    next_root = @roots[[18, 18]] = Root.new([18, 18], -1, self) if \
                                                @gameboard[[18, 18]] == -1  
    next_root = @roots[[6 , 18]] = Root.new([6 , 18], -1, self) if \
                                                @gameboard[[6 , 18]] == -1  
    next_root = @roots[[0 , 12]] = Root.new([0 , 12], -1, self) if \
                                                @gameboard[[0 , 12]] == -1
   
    @roots.values.each do |r|
      r.recalculate!
    end
    
    end

end