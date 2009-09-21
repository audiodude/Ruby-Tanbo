require 'ai/ai_base.rb'

class AIRandbo < AIBase
  def move
    begin_busy_cursor
    return if game_over?
    
    moves = available_moves
    return if moves.empty? #can't make a move if there are no moves to make!
    chosen = moves.keys[rand(moves.keys.size)]
    end_busy_cursor
    return [chosen.x, chosen.y]
  end
end