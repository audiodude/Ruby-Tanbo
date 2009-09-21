require 'test/ruby_tanbo_test.rb'
require 'main_controller.rb'

class BoardTest < Test::Unit::TestCase
  include RubyTanboTest

  def test_start_position
    msg = "Starting position was found invalid, wrong moves for WHITE at: "
    point = @main_controller.get_board[6, 0]
    assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[18, 0]
    assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[0, 6]
    assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[12, 6]
    assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[6, 12]
    assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[18, 12]
    assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[0, 18]
    assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[12, 18]
    assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
               
    msg = "Starting position was found invalid, wrong moves for BLACK at: "
    point = @main_controller.get_board[0, 0]
    assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[12, 0]
    assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[6, 6]
    assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[18, 6]
    assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[12, 12]
    assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[18, 18]
    assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[6, 18]
    assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    point = @main_controller.get_board[0, 12]
    assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
  
    msg = "Starting position was found invalid, expected EMPTY point not empty at: "
    0.upto(18) do |x|
      0.upto(18) do |y|
        unless x%6 == 0 && y%6 == 0
          point = @main_controller.get_board[x, y]
          assert_equal TanboBoard::BLANK, @main_controller.get_color(point), (msg + point.inspect)
        end
      end
    end
  end

  def test_black_starts
    assert_equal TanboBoard::BLACK, @main_controller.whose_turn?
  end

  def test_valid_move
    msg = "Valid WHITE starting move reported as invalid at: "
    point = @main_controller.get_board[0, 7]
    assert @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[0, 5]
    assert @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[1, 18]
    assert @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[0, 17]
    assert @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[5, 12]
    assert @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[6, 13]
    assert @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
  
    msg = "Valid BLACK starting move reported as invalid at: "
    point = @main_controller.get_board[0, 1]
    assert @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    point = @main_controller.get_board[1, 0]
    assert @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    point = @main_controller.get_board[17, 18]
    assert @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    point = @main_controller.get_board[18, 17]
    assert @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    point = @main_controller.get_board[7, 6]
    assert @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    point = @main_controller.get_board[6, 7]
    assert @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
  end

  def test_no_invalid_move
    msg = "Invalid move from starting position reported as valid at: "
    point = @main_controller.get_board[-1,-1]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[19,19]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[-1,19]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[19,-1]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[-532,1087]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[7734,-1985]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[3,4]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[4,4]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[5,4]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[9,0]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[0,10]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[10,0]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[0,18]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[6,6]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[10,18]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
    point = @main_controller.get_board[18,10]
    assert ! @main_controller.valid_move?(point, TanboBoard::BLACK), (msg + point.inspect)
    assert ! @main_controller.valid_move?(point, TanboBoard::WHITE), (msg + point.inspect)
  end
  
  def test_right_root_number
    assert_equal 16, @main_controller.roots.size
  end
  
  def test_root_points
    root_points = [
      @main_controller.get_board[6 ,0 ], @main_controller.get_board[18,0 ],
      @main_controller.get_board[0 ,6 ], @main_controller.get_board[12,6 ],
      @main_controller.get_board[6 ,12], @main_controller.get_board[18,12],
      @main_controller.get_board[0 ,18], @main_controller.get_board[12,18],
      @main_controller.get_board[0 ,0 ], @main_controller.get_board[12,0 ],
      @main_controller.get_board[6 ,6 ], @main_controller.get_board[18,6 ],
      @main_controller.get_board[12,12], @main_controller.get_board[18,18],
      @main_controller.get_board[6 ,18], @main_controller.get_board[0 ,12]
    ]
    
    for point in root_points
      found = []
      for root in @main_controller.roots
        deleted = root.points.delete(point)
        found << deleted if deleted
      end
      
      assert !found.empty?, "Couldn't find point in any root: " + point.inspect
      assert_equal 1, found.size, "More than one root had point: " + point.inspect
    end
  end
  
  def test_root_liberties
    root_points = [
      @main_controller.get_board[6 ,0 ], @main_controller.get_board[18,0 ],
      @main_controller.get_board[0 ,6 ], @main_controller.get_board[12,6 ],
      @main_controller.get_board[6 ,12], @main_controller.get_board[18,12],
      @main_controller.get_board[0 ,18], @main_controller.get_board[12,18],
      @main_controller.get_board[0 ,0 ], @main_controller.get_board[12,0 ],
      @main_controller.get_board[6 ,6 ], @main_controller.get_board[18,6 ],
      @main_controller.get_board[12,12], @main_controller.get_board[18,18],
      @main_controller.get_board[6 ,18], @main_controller.get_board[0 ,12]
    ]
    
    for point in root_points
      for root in @main_controller.roots
        if root.points.include?(point)
          point.bounded_neighbors.each do |lib|
            assert root.liberties.include?(lib), "Root: " + root.inspect + " should have had liberty: " + lib.inspect
          end
        end
      end
    end
  end
  
end