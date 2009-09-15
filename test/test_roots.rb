require 'test/ruby_tanbo_test.rb'
require 'main_controller.rb'

class RootTest < Test::Unit::TestCase
  include RubyTanboTest

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