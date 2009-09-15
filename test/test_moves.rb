require 'test/ruby_tanbo_test.rb'
require 'main_controller.rb'

class MovesTest < Test::Unit::TestCase
  include RubyTanboTest

  def test_turn_change
    msg = "Should be WHITE's move after single black move at: "
    point = [0, 1]
    assert @main_controller.valid_move?(point, MainController::BLACK), ("Expected valid move reported invalid at: " + point.inspect)
    @main_controller.make_move(point, [0, 0])
    assert_equal MainController::WHITE, @main_controller.whose_turn?, (msg + point.inspect)
  
  
    msg = "Should be BLACK's move after WHITE move at: "
    point = [7, 12]
    assert @main_controller.valid_move?(point, MainController::WHITE), ("Expected valid move reported invalid at: " + point.inspect)
    @main_controller.make_move(point, [6, 12])
    assert_equal MainController::BLACK, @main_controller.whose_turn?, (msg + point.inspect)
  end

  def test_move_effects
    point = [11, 12]
    assert @main_controller.valid_move?(point), ("Expected BLACK valid move reported invalid at: " + point.inspect)
    @main_controller.make_move(point, [12, 12])
    assert_equal MainController::BLACK, @main_controller.get_color(point), ("Point should be BLACK after single black move at: " + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::BLACK), ("Move reported valid for BLACK after already being made at: " + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), ("Move reported valid for WHITE after already being made at: " + point.inspect)
    next_move = [10, 12]
    assert @main_controller.valid_move?(next_move, MainController::BLACK), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
    next_move = [11, 13]
    assert @main_controller.valid_move?(next_move, MainController::BLACK), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
    next_move = [11, 11]
    assert @main_controller.valid_move?(next_move, MainController::BLACK), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
  
    point = [0, 5]
    assert @main_controller.valid_move?(point), ("Expected WHITE valid move reported invalid at: " + point.inspect)
    @main_controller.make_move(point, [0, 6])
    assert_equal MainController::WHITE, @main_controller.get_color(point), ("Point should be WHITE after single black move at: " + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::BLACK), ("Move reported valid for BLACK after already being made at: " + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), ("Move reported valid for WHITE after already being made at: " + point.inspect)
    next_move = [0, 4]
    assert @main_controller.valid_move?(next_move, MainController::WHITE), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
    next_move = [1, 5]
    assert @main_controller.valid_move?(next_move, MainController::WHITE), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
    next_move = [-1, 5]
    assert ! @main_controller.valid_move?(next_move, MainController::WHITE), ("Making move at: " + point.inspect + " should *not* enable move at: " + next_move.inspect)
  end
end