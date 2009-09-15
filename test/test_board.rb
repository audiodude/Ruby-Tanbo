require 'test/ruby_tanbo_test.rb'
require 'main_controller.rb'

class BoardTest < Test::Unit::TestCase
  include RubyTanboTest

  def test_start_position
    msg = "Starting position was found invalid, wrong moves for WHITE at: "
    point = [6, 0]
    assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = [18, 0]
    assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = [0, 6]
    assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = [12, 6]
    assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = [6, 12]
    assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = [18, 12]
    assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = [0, 18]
    assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = [12, 18]
    assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
               
    msg = "Starting position was found invalid, wrong moves for BLACK at: "
    point = [0, 0]
    assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = [12, 0]
    assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = [6, 6]
    assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = [18, 6]
    assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = [12, 12]
    assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = [18, 18]
    assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = [6, 18]
    assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = [0, 12]
    assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
  
    msg = "Starting position was found invalid, expected EMPTY point not empty at: "
    0.upto(18) do |x|
      0.upto(18) do |y|
        unless x%6 == 0 && y%6 == 0
          point = [x, y]
          assert_equal MainController::EMPTY, @main_controller.get_color(point), (msg + point.inspect)
        end
      end
    end
  end

  def test_black_starts
    assert_equal MainController::BLACK, @main_controller.whose_turn?
  end

  def test_valid_move
    msg = "Valid WHITE starting move reported as invalid at: "
    point = [0, 7]
    assert @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [0, 5]
    assert @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [1, 18]
    assert @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [0, 17]
    assert @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [5, 12]
    assert @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [6, 13]
    assert @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
  
    msg = "Valid BLACK starting move reported as invalid at: "
    point = [0, 1]
    assert @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    point = [1, 0]
    assert @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    point = [17, 18]
    assert @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    point = [18, 17]
    assert @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    point = [7, 6]
    assert @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    point = [6, 7]
    assert @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
  end

  def test_no_invalid_move
    msg = "Invalid move from starting position reported as valid at: "
    point = [-1,-1]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [19,19]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [-1,19]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [19,-1]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [-532,1087]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [7734,-1985]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [3,4]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [4,4]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [5,4]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [9,0]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [0,10]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [10,0]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [0,18]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [6,6]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [10,18]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
    point = [18,10]
    assert ! @main_controller.valid_move?(point, MainController::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, MainController::WHITE), (msg + point.inspect)
  end
end