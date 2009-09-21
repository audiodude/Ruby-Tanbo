class AIBase
  
  def initialize(controller, color)
    @controller, @color = controller, color
  end
  
  def available_moves
    @controller.get_all_moves(@color)
  end
  
  def game_over?
    @controller.game_over?
  end
end