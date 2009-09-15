require 'test/unit'
require 'main_controller.rb'

class MainControllerTest < Test::Unit::TestCase
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
  
  def test_simple_white_bounded
    seq = [
      [5, 6], [5, 12], [4, 6], [4, 12], [3, 6], [3, 12], [2, 6],
      [2, 12], [1, 6], [1, 12], [1, 5], [1, 11], [0, 5], [0, 11],
      [1, 7], [1, 13], [0, 7]
    ]
    do_move_sequence(seq)
    
    assert_equal MainController::WHITE, @main_controller.whose_turn?, "Should be WHITE's turn after BLACK bounds WHITE root."
    assert_equal MainController::BLANK, @main_controller.get_color([0, 6]), "Square containg removed root should be BLANK."
    
    black_points = [
      [5, 6], [4, 6], [3, 6], [2, 6], [1, 6], [1, 5], [0, 5], [1, 7], [0, 7]  
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end
    
    white_points = [
      [5, 12], [4, 12], [3, 12], [2, 12], [1, 12], [1, 11], [0, 11], [1, 13]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_simple_white_two_bounded
    seq = [
      [5, 6], [0, 5], [4, 6], [5, 0], [3, 6], [11, 6], [2, 6],
      [13, 18], [1, 6], [0, 17], [1, 7], [5, 12], [0, 7], [17, 12],
      [1, 5], [17, 0], [1, 4], [7, 0], [0, 4]
    ]
    do_move_sequence(seq)
    
    assert_equal MainController::WHITE, @main_controller.whose_turn?, "Should be WHITE's turn after BLACK bounds WHITE root."

    point = [0, 6]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [0, 5]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    
    black_points = [
      [5, 6], [4, 6], [3, 6], [2, 6], [1, 6], [1, 7], [0, 7], [1, 5], [1, 4], [0, 4] 
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end
    
    white_points = [
      [5, 0], [11, 6], [13, 18], [0, 17], [5, 12], [17, 12], [17, 0], [7, 0]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_simple_black_two_bounded
    seq = [
      [5, 6], [5, 12], [4, 6], [4, 12], [3, 6], [3, 12], [11, 0], [2, 12],
      [1, 0], [1, 12], [5, 18], [1, 11], [11, 12], [1, 13], [17, 18],
      [0, 13], [17, 6], [1, 10], [0, 11], [0, 10]
    ]
    do_move_sequence(seq)

    assert_equal MainController::BLACK, @main_controller.whose_turn?, "Should be BLACK's turn after WHITE bounds BLACK root."

    point = [0, 12]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      [5, 6], [4, 6], [3, 6], [11, 0], [1, 0], [5, 18], [11, 12], [17, 18], [17, 6] 
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
      [5, 12], [4, 12], [3, 12], [2, 12], [1, 12], [1, 11], [1, 13], [0, 13], [1, 10], [0, 10]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_white_self_bound_no_blank
    seq = [
      [5, 6], [0, 7], [4, 6], [5, 12], [3, 6], [11, 18], [2, 6],
      [11, 6], [1, 6], [7, 0], [1, 5], [17, 0], [0, 5], [17, 1],
      [1, 7], [17, 12], [1, 8], [0, 17], [1, 9], [12, 7], [0, 9],
      [4, 12], [2, 8], [0, 8]
    ]
    do_move_sequence(seq)

    assert_equal MainController::BLACK, @main_controller.whose_turn?, "Should be BLACK's turn after WHITE bounds itself."

    point = [0, 6]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [0, 7]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [0, 8]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      [5, 6], [4, 6], [3, 6], [2, 6], [1, 6], [1, 5], [0, 5], [1, 7], [1, 8], [1, 9], [0, 9], [2, 8]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
      [5, 12], [11, 18], [11, 6], [7, 0], [17, 0], [17, 1], [17, 12], [0, 17], [12, 7], [4, 12]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_white_bounded_two_blanks
    seq = [
      [5, 6], [5, 12], [4, 6], [1, 6], [3, 6], [1, 5], [2, 6],
      [11, 18], [2, 5], [5, 0], [2, 4], [11, 6], [2, 7], [0, 7],
      [2, 8], [1, 18], [1, 8], [17, 12], [0, 8], [18, 1], [1, 4]
    ]
    do_move_sequence(seq)

    assert_equal MainController::WHITE, @main_controller.whose_turn?, "Should be WHITE's turn after BLACK bounds WHITE root."

    point = [0, 6]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [1, 6]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [1, 5]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [0, 7]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      [5, 6], [4, 6], [3, 6], [2, 6], [2, 5], [2, 4], [2, 7], [2, 8], [1, 8], [0, 8], [1, 4]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
      [5, 12], [11, 18], [5, 0], [11, 6], [1, 18], [17, 12], [18, 1]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_white_self_bound_one_blank
    seq = [
      [5, 6], [1, 6], [4, 6], [1, 7], [3, 6], [5, 0], [2, 6],
      [11, 6], [2, 5], [4, 0], [1, 5], [13, 6], [0, 5], [10, 6],
      [2, 7], [5, 12], [2, 8], [11, 7], [2, 9], [1, 8], [1, 9],
      [9, 6], [0, 9], [0, 8]
    ]
    do_move_sequence(seq)

    assert_equal MainController::BLACK, @main_controller.whose_turn?, "Should be BLACK's turn after WHITE bounds itself."

    point = [0, 6]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [1, 6]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [1, 7]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [1, 8]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [0, 8]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      [5, 6], [4, 6], [3, 6], [2, 6], [2, 5], [1, 5], [0, 5], [2, 7], [2, 8], [2, 9], [1, 9], [0, 9]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
     [5, 0], [11, 6], [4, 0], [13, 6], [10, 6], [5, 12], [11, 7], [9, 6]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_bound_one_each_color
    seq = [
      [1, 0], [5, 0], [2, 0], [4, 0], [6, 5], [0, 5], [6, 4], [0, 4],
      [6, 3], [0, 3], [6, 2], [0, 2], [6, 1], [0, 1], [7, 1], [1, 1],
      [7, 0], [3, 0], [5, 1], [1, 3], [4, 1], [2, 1] 
    ]
    do_move_sequence(seq)

    @main_controller.debug

    assert_equal MainController::BLACK, @main_controller.whose_turn?, "Should be BLACK's turn after WHITE bounds two roots."

    point = [0, 0]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [1, 0]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [2, 0]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [3, 0]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [4, 0]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [5, 0]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = [6, 0]
    assert_equal MainController::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect

    black_points = [
     [6, 5], [6, 4], [6, 3], [6, 2], [6, 1], [7, 1], [7, 0], [5, 1], [4, 1]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal MainController::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
     [0, 5], [0, 4], [0, 3], [0, 2], [0, 1], [1, 1], [1, 3], [2, 1]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal MainController::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
end
