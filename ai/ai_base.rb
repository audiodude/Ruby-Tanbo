class AIBase
  
  def initialize(gameboard, color)
    @gameboard, @color = gameboard, color
  end
  
  def available_moves
    @gameboard.get_all_moves(@color)
  end
  
  def game_over?
    @gameboard.game_over?
  end
end