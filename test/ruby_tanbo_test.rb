require 'test/unit'
require 'main_controller.rb'

module RubyTanboTest 
  def setup
    @main_controller = MainController.new
  end

  # def teardown
  # end

  # Perform a sequence of moves, first asserting that the move is valid
  def do_move_sequence(moves)
    for move in moves
      adj = @main_controller.valid_move?(move)
      assert adj, ("Move in sequence was not valid: " + move.inspect)
      @main_controller.make_move(move, adj)
    end
  end
end

#Collect tests for automatic test suite
require 'test/test_board.rb'
require 'test/test_moves.rb'
require 'test/test_roots.rb'
