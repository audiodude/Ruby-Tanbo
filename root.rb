require 'pp'

class Root

  def initialize(x, y, color, controller)
    @controller  = controller
    @points = [ [x, y] ]
    @color = color
    @moves = neighbors(x, y)
  end
  
  def in_bounds?(x, y)
    return false if x < 0
    return false if x > 18
    return false if y < 0
    return false if y > 18
    
    return true
  end
  
  def neighbors(x, y)
    ans = []
    ans << [x+1, y] if in_bounds?(x+1, y) && @controller.valid_move?(x+1, y, @color)
    ans << [x, y+1] if in_bounds?(x, y+1) && @controller.valid_move?(x, y+1, @color)
    ans << [x-1, y] if in_bounds?(x-1, y) && @controller.valid_move?(x-1, y, @color)
    ans << [x, y-1] if in_bounds?(x, y-1) && @controller.valid_move?(x, y-1, @color)
    return ans
  end
  
  def add_point(x, y)
    @points << [x, y]
    @moves.delete([x, y])
    @moves += neighbors(x, y)
  end
  
  def remove_point(x, y)
    @moves.delete([x,y])
  end
  
  def remove!
    #puts "Remove called for:"
    #pp @moves
    #pp @points
    #puts "="*10
    for pt in @points
      @controller.remove(pt)
    end
  end
  
  def bounded?
    @moves.empty?
  end
  
end