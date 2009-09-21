class TanboBoard
  attr_accessor :points, :turn
  
  WHITE = 1
  EMPTY = BLANK = 0
  BLACK = -1
  
  # Points only exist within Tanbo Boards. You can never construct a Point
  # directly, you access them through the TanboBoard's [] factory method.
  # So my_board[3, 2] gives you the Point at 3, 2. It will always return the
  # same point for the same TanboBoard instance.
  class Point
    attr_reader :x, :y
    attr_accessor :root, :color
    
    # Use this pointer to implement convenience methods on the point object
    def initialize(x, y, board)
      @x, @y, @board = x, y, board
      @color = BLANK
    end
    
    def neighbors
      @board.neighbors(self)
    end

    def in_bounds?
      @board.in_bounds?(self)
    end

    def bounded_neighbors
      @board.bounded_neighbors(self)
    end
    
    def inspect
      "pt[#{x}, #{y}]"
    end
    
    def deep_copy(board)
      copy = Point.new(@x, @y, board)
      copy.color = @color
      copy.root = @root.deep_copy(board) if @root
      
      return copy
    end
  end
  
  def initialize
    @points = {}
  end
  
  def [](x, y)
    ans = @points[[x, y]]
    if not ans
      ans = Point.new(x, y, self)
      @points[[x,y]] = ans
      #puts "#Created " + ans.inspect + " #{ans.color}"
    end
    return ans
  end
  
  def change_turns
   @turn = (@turn == BLACK ? WHITE : BLACK)
  end
  
  def neighbors(point)
    x,y = point.x, point.y
    return [ self[x+1, y], self[x, y+1], self[x-1, y], self[x, y-1] ]
  end

  def in_bounds?(point)
    return false if point.x < 0
    return false if point.x > 18
    return false if point.y < 0
    return false if point.y > 18
  
    return true
  end

  def bounded_neighbors(point)
    if in_bounds?(point)
      x, y = point.x, point.y
      ans = []
      # If the point is in bounds, we only have to check what we're modifiying
      ans << self[x+1, y] if x+1 <= 18
      ans << self[x, y+1] if y+1 <= 18
      ans << self[x-1, y] if x-1 >= 0
      ans << self[x, y-1] if y-1 >= 0
      return ans
    else
      # Otherwise, generate all the neihbors and check them all
      return self.neighbors(point).select do |pt|
        self.in_bounds?(pt)
      end
    end
  end
  
  def deep_copy
    copy = TanboBoard.new
    copy.points = {}
    @points.each do |k, v|
      # Put a copy of each point, deep_copylicated using the new board, at all of the
      # used indices
      copy.points[k] = v.deep_copy(copy)
    end
    
    return copy
  end
end