class HumanPlayer
  def initialize(board_ui)
    @board_ui = board_ui
  end
  
  def move(board, last_move)
    move = nil
    @board_ui.move_queue.synchronize do
      @board_ui.input_ready_cond.wait
      move = @board_ui.move_queue.pop
    end
    return move
  end
end