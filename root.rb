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
  
end