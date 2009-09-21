require 'test/ruby_tanbo_test.rb'
require 'main_controller.rb'

class MovesTest < Test::Unit::TestCase
  include RubyTanboTest

  def test_turn_change
    msg = "Should be WHITE's move after single black move at: "
    point = @main_controller.get_board[0, 1]
    assert @main_controller.valid_move?(point, TanboBoard::BLACK), ("Expected valid move reported invalid at: " + point.inspect)
    @main_controller.make_move(point, @main_controller.get_board[0, 0])
    assert_equal TanboBoard::WHITE, @main_controller.whose_turn?, (msg + point.inspect)
  
  
    msg = "Should be BLACK's move after WHITE move at: "
    point = @main_controller.get_board[7, 12]
    assert @main_controller.valid_move?(point, TanboBoard::WHITE), ("Expected valid move reported invalid at: " + point.inspect)
    @main_controller.make_move(point, @main_controller.get_board[6, 12])
    assert_equal TanboBoard::BLACK, @main_controller.whose_turn?, (msg + point.inspect)
  end

  def test_move_effects
    require 'pp'
    
    puts "="*10
    pp @main_controller.roots
    puts "="*10
    
    point = @main_controller.get_board[11, 12]
    assert @main_controller.valid_move?(point), ("Expected BLACK valid move reported invalid at: " + point.inspect)
    @main_controller.make_move(point, @main_controller.get_board[12, 12])
    # puts "="*10
    # pp @main_controller.roots
    # puts "="*10
    assert_equal TanboBoard::BLACK, @main_controller.get_color(point), ("Point should be BLACK after single black move at: " + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), ("Move reported valid for BLACK after already being made at: " + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), ("Move reported valid for WHITE after already being made at: " + point.inspect)
    next_move = @main_controller.get_board[10, 12]
    assert @main_controller.valid_move?(next_move, TanboBoard::BLACK), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
    next_move = @main_controller.get_board[11, 13]
    assert @main_controller.valid_move?(next_move, TanboBoard::BLACK), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
    next_move = @main_controller.get_board[11, 11]
    assert @main_controller.valid_move?(next_move, TanboBoard::BLACK), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
  
  
    point = @main_controller.get_board[0, 5]
    assert @main_controller.valid_move?(point), ("Expected WHITE valid move reported invalid at: " + point.inspect)
    @main_controller.make_move(point, @main_controller.get_board[0, 6])
    assert_equal TanboBoard::WHITE, @main_controller.get_color(point), ("Point should be WHITE after single black move at: " + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), ("Move reported valid for BLACK after already being made at: " + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), ("Move reported valid for WHITE after already being made at: " + point.inspect)
    next_move = @main_controller.get_board[0, 4]
    assert @main_controller.valid_move?(next_move, TanboBoard::WHITE), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
    next_move = @main_controller.get_board[1, 5]
    assert @main_controller.valid_move?(next_move, TanboBoard::WHITE), ("Making move at: " + point.inspect + " should enable move at: " + next_move.inspect)
    next_move = @main_controller.get_board[-1, 5]
    assert ! @main_controller.valid_move?(next_move, TanboBoard::WHITE), ("Making move at: " + point.inspect + " should *not* enable move at: " + next_move.inspect)
  end
end