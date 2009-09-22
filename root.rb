class Root
  attr_reader :color
  attr_accessor :points, :liberties

  def initialize(color)
    @points = []
    @color = color
    @liberties = []
    # The controller should call its own add_point_to_root method to
    # add the initial point
  end
  
  def remove_point(point)
    @liberties.delete(point)
  end
  
  def bounded?
    @liberties.empty?
  end
  
  def inspect
    "root{" + @liberties.inspect + "-" + @points.inspect + "}"
  end
  
  def deep_copy(board)
    copy = Root.new(@color)
    copy.points = points.dup
    copy.liberties = liberties.dup
    copy.associate_with(board)
    
    return copy
  end
  
  # Replaces the points and liberties in this root with ones
  # representing the same point, but sourced from the given board.
  # Used for object copying
  def associate_with(board)
    @points.map! do |point|
      point = board[point.x, point.y]
      point.root = self
      point
    end
    
    @liberties.map! do |point|
      board[point.x, point.y]
    end
  end
end