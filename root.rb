class Root
  attr_reader :color


  def initialize(point, color, controller)
    @controller  = controller
    @points = [ point ]
    @color = color
    @moves = []
    calc_valid_moves(point)
  end
  
  def in_bounds?(point)
    x,y = point
    return false if x < 0
    return false if x > 18
    return false if y < 0
    return false if y > 18
    
    return true
  end
  
  def edit_moves_for(point)
    if in_bounds?(point)
      if @controller.valid_move?(point, @color)
        @moves << point
      else
        @moves.delete(point)
      end
    end
  end
  
  def calc_valid_moves(point)
    MainController.neighbors(point).each do |pair|
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
  
  def recalculate!
    seen = @points.dup
    dfs(@points[0], [])
  end
  
  def dfs(node, visited)
    visited << node
    if(@controller.get_color(node) == @color)
      calc_valid_moves(node)
    end
    MainController.neighbors(node).each do |neighbor|
      unless visited.include?(neighbor)
        dfs(neighbor, visited)
      end
    end
  end
  
end