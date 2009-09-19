class Root
  attr_reader :color


  def initialize(point, color, controller)
    @controller  = controller
    @points = [ point ]
    @color = color
    @moves = []
    calc_valid_moves(point)
  end
  
  def edit_moves_for(point)
    if @controller.valid_move?(point, @color)
      @moves << point
    else
      @moves.delete(point)
    end
  end
  
  def calc_valid_moves(point)
    MainController.bounded_neighbors(point).each do |pair|
      edit_moves_for(pair)
    end
  end
  
  def add_point(point)
    @points << point
    @moves.delete(point)
    calc_valid_moves(point)
  end
  
  def remove_point(point)
    @moves.delete(point)
  end
  
  def remove!
    for point in @points
      @controller.remove!(point)
    end
  end
  
  def bounded?
    @moves.empty?
  end
  
  def inspect
    @moves.inspect + "\n" + @points.inspect
  end
  
  def recalculate!(visited)
    seen = @points.dup
    dfs(@points[0], visited)
    @moves.uniq!
    return @points
  end
  
  def dfs(node, visited)
    visited << node
    if(@controller.get_color(node) == @color)
      @points << node
      calc_valid_moves(node)
    end
    MainController.bounded_neighbors(node).each do |neighbor|
      if (! visited.include?(neighbor)) and @controller.get_color(node) == @color
        dfs(neighbor, visited)
      end
    end
  end
  
end