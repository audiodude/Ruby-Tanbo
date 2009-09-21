require 'test/ruby_tanbo_test.rb'
require 'main_controller.rb'

class RootTest < Test::Unit::TestCase
  include RubyTanboTest

  def test_simple_white_bounded
    seq = [
      @main_controller.get_board[5, 6], @main_controller.get_board[5, 12], @main_controller.get_board[4, 6], @main_controller.get_board[4, 12], @main_controller.get_board[3, 6], @main_controller.get_board[3, 12], @main_controller.get_board[2, 6],
      @main_controller.get_board[2, 12], @main_controller.get_board[1, 6], @main_controller.get_board[1, 12], @main_controller.get_board[1, 5], @main_controller.get_board[1, 11], @main_controller.get_board[0, 5], @main_controller.get_board[0, 11],
      @main_controller.get_board[1, 7], @main_controller.get_board[1, 13], @main_controller.get_board[0, 7]
    ]
    require 'pp'
    do_move_sequence(seq)
    
    assert_equal TanboBoard::WHITE, @main_controller.whose_turn?, "Should be WHITE's turn after BLACK bounds WHITE root."
    assert_equal TanboBoard::BLANK, @main_controller.get_color(@main_controller.get_board[0, 6]), "Square containg removed root should be BLANK."
    
    black_points = [
      @main_controller.get_board[5, 6], @main_controller.get_board[4, 6], @main_controller.get_board[3, 6], @main_controller.get_board[2, 6], @main_controller.get_board[1, 6], @main_controller.get_board[1, 5], @main_controller.get_board[0, 5], @main_controller.get_board[1, 7], @main_controller.get_board[0, 7]  
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end
    
    white_points = [
      @main_controller.get_board[5, 12], @main_controller.get_board[4, 12], @main_controller.get_board[3, 12], @main_controller.get_board[2, 12], @main_controller.get_board[1, 12], @main_controller.get_board[1, 11], @main_controller.get_board[0, 11], @main_controller.get_board[1, 13]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_simple_white_two_bounded
    seq = [
      @main_controller.get_board[5, 6], @main_controller.get_board[0, 5], @main_controller.get_board[4, 6], @main_controller.get_board[5, 0], @main_controller.get_board[3, 6], @main_controller.get_board[11, 6], @main_controller.get_board[2, 6],
      @main_controller.get_board[13, 18], @main_controller.get_board[1, 6], @main_controller.get_board[0, 17], @main_controller.get_board[1, 7], @main_controller.get_board[5, 12], @main_controller.get_board[0, 7], @main_controller.get_board[17, 12],
      @main_controller.get_board[1, 5], @main_controller.get_board[17, 0], @main_controller.get_board[1, 4], @main_controller.get_board[7, 0], @main_controller.get_board[0, 4]
    ]
    do_move_sequence(seq)
    
    assert_equal TanboBoard::WHITE, @main_controller.whose_turn?, "Should be WHITE's turn after BLACK bounds WHITE root."

    point = @main_controller.get_board[0, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[0, 5]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    
    black_points = [
      @main_controller.get_board[5, 6], @main_controller.get_board[4, 6], @main_controller.get_board[3, 6], @main_controller.get_board[2, 6], @main_controller.get_board[1, 6], @main_controller.get_board[1, 7], @main_controller.get_board[0, 7], @main_controller.get_board[1, 5], @main_controller.get_board[1, 4], @main_controller.get_board[0, 4] 
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end
    
    white_points = [
      @main_controller.get_board[5, 0], @main_controller.get_board[11, 6], @main_controller.get_board[13, 18], @main_controller.get_board[0, 17], @main_controller.get_board[5, 12], @main_controller.get_board[17, 12], @main_controller.get_board[17, 0], @main_controller.get_board[7, 0]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_simple_black_two_bounded
    seq = [
      @main_controller.get_board[5, 6], @main_controller.get_board[5, 12], @main_controller.get_board[4, 6], @main_controller.get_board[4, 12], @main_controller.get_board[3, 6], @main_controller.get_board[3, 12], @main_controller.get_board[11, 0], @main_controller.get_board[2, 12],
      @main_controller.get_board[1, 0], @main_controller.get_board[1, 12], @main_controller.get_board[5, 18], @main_controller.get_board[1, 11], @main_controller.get_board[11, 12], @main_controller.get_board[1, 13], @main_controller.get_board[17, 18],
      @main_controller.get_board[0, 13], @main_controller.get_board[17, 6], @main_controller.get_board[1, 10], @main_controller.get_board[0, 11], @main_controller.get_board[0, 10]
    ]
    do_move_sequence(seq)

    assert_equal TanboBoard::BLACK, @main_controller.whose_turn?, "Should be BLACK's turn after WHITE bounds BLACK root."

    point = @main_controller.get_board[0, 12]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      @main_controller.get_board[5, 6], @main_controller.get_board[4, 6], @main_controller.get_board[3, 6], @main_controller.get_board[11, 0], @main_controller.get_board[1, 0], @main_controller.get_board[5, 18], @main_controller.get_board[11, 12], @main_controller.get_board[17, 18], @main_controller.get_board[17, 6] 
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
      @main_controller.get_board[5, 12], @main_controller.get_board[4, 12], @main_controller.get_board[3, 12], @main_controller.get_board[2, 12], @main_controller.get_board[1, 12], @main_controller.get_board[1, 11], @main_controller.get_board[1, 13], @main_controller.get_board[0, 13], @main_controller.get_board[1, 10], @main_controller.get_board[0, 10]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_white_self_bound_no_blank
    seq = [
      @main_controller.get_board[5, 6], @main_controller.get_board[0, 7], @main_controller.get_board[4, 6], @main_controller.get_board[5, 12], @main_controller.get_board[3, 6], @main_controller.get_board[11, 18], @main_controller.get_board[2, 6],
      @main_controller.get_board[11, 6], @main_controller.get_board[1, 6], @main_controller.get_board[7, 0], @main_controller.get_board[1, 5], @main_controller.get_board[17, 0], @main_controller.get_board[0, 5], @main_controller.get_board[17, 1],
      @main_controller.get_board[1, 7], @main_controller.get_board[17, 12], @main_controller.get_board[1, 8], @main_controller.get_board[0, 17], @main_controller.get_board[1, 9], @main_controller.get_board[12, 7], @main_controller.get_board[0, 9],
      @main_controller.get_board[4, 12], @main_controller.get_board[2, 8], @main_controller.get_board[0, 8]
    ]
    do_move_sequence(seq)

    assert_equal TanboBoard::BLACK, @main_controller.whose_turn?, "Should be BLACK's turn after WHITE bounds itself."

    point = @main_controller.get_board[0, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[0, 7]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[0, 8]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      @main_controller.get_board[5, 6], @main_controller.get_board[4, 6], @main_controller.get_board[3, 6], @main_controller.get_board[2, 6], @main_controller.get_board[1, 6], @main_controller.get_board[1, 5], @main_controller.get_board[0, 5], @main_controller.get_board[1, 7], @main_controller.get_board[1, 8], @main_controller.get_board[1, 9], @main_controller.get_board[0, 9], @main_controller.get_board[2, 8]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
      @main_controller.get_board[5, 12], @main_controller.get_board[11, 18], @main_controller.get_board[11, 6], @main_controller.get_board[7, 0], @main_controller.get_board[17, 0], @main_controller.get_board[17, 1], @main_controller.get_board[17, 12], @main_controller.get_board[0, 17], @main_controller.get_board[12, 7], @main_controller.get_board[4, 12]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_white_bounded_two_blanks
    seq = [
      @main_controller.get_board[5, 6], @main_controller.get_board[5, 12], @main_controller.get_board[4, 6], @main_controller.get_board[1, 6], @main_controller.get_board[3, 6], @main_controller.get_board[1, 5], @main_controller.get_board[2, 6],
      @main_controller.get_board[11, 18], @main_controller.get_board[2, 5], @main_controller.get_board[5, 0], @main_controller.get_board[2, 4], @main_controller.get_board[11, 6], @main_controller.get_board[2, 7], @main_controller.get_board[0, 7],
      @main_controller.get_board[2, 8], @main_controller.get_board[1, 18], @main_controller.get_board[1, 8], @main_controller.get_board[17, 12], @main_controller.get_board[0, 8], @main_controller.get_board[18, 1], @main_controller.get_board[1, 4]
    ]
    do_move_sequence(seq)

    assert_equal TanboBoard::WHITE, @main_controller.whose_turn?, "Should be WHITE's turn after BLACK bounds WHITE root."

    point = @main_controller.get_board[0, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[1, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[1, 5]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[0, 7]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      @main_controller.get_board[5, 6], @main_controller.get_board[4, 6], @main_controller.get_board[3, 6], @main_controller.get_board[2, 6], @main_controller.get_board[2, 5], @main_controller.get_board[2, 4], @main_controller.get_board[2, 7], @main_controller.get_board[2, 8], @main_controller.get_board[1, 8], @main_controller.get_board[0, 8], @main_controller.get_board[1, 4]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
      @main_controller.get_board[5, 12], @main_controller.get_board[11, 18], @main_controller.get_board[5, 0], @main_controller.get_board[11, 6], @main_controller.get_board[1, 18], @main_controller.get_board[17, 12], @main_controller.get_board[18, 1]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_white_self_bound_one_blank
    seq = [
      @main_controller.get_board[5, 6], @main_controller.get_board[1, 6], @main_controller.get_board[4, 6], @main_controller.get_board[1, 7], @main_controller.get_board[3, 6], @main_controller.get_board[5, 0], @main_controller.get_board[2, 6],
      @main_controller.get_board[11, 6], @main_controller.get_board[2, 5], @main_controller.get_board[4, 0], @main_controller.get_board[1, 5], @main_controller.get_board[13, 6], @main_controller.get_board[0, 5], @main_controller.get_board[10, 6],
      @main_controller.get_board[2, 7], @main_controller.get_board[5, 12], @main_controller.get_board[2, 8], @main_controller.get_board[11, 7], @main_controller.get_board[2, 9], @main_controller.get_board[1, 8], @main_controller.get_board[1, 9],
      @main_controller.get_board[9, 6], @main_controller.get_board[0, 9], @main_controller.get_board[0, 8]
    ]
    do_move_sequence(seq)

    assert_equal TanboBoard::BLACK, @main_controller.whose_turn?, "Should be BLACK's turn after WHITE bounds itself."

    point = @main_controller.get_board[0, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[1, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[1, 7]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[1, 8]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[0, 8]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      @main_controller.get_board[5, 6], @main_controller.get_board[4, 6], @main_controller.get_board[3, 6], @main_controller.get_board[2, 6], @main_controller.get_board[2, 5], @main_controller.get_board[1, 5], @main_controller.get_board[0, 5], @main_controller.get_board[2, 7], @main_controller.get_board[2, 8], @main_controller.get_board[2, 9], @main_controller.get_board[1, 9], @main_controller.get_board[0, 9]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
     @main_controller.get_board[5, 0], @main_controller.get_board[11, 6], @main_controller.get_board[4, 0], @main_controller.get_board[13, 6], @main_controller.get_board[10, 6], @main_controller.get_board[5, 12], @main_controller.get_board[11, 7], @main_controller.get_board[9, 6]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_bound_one_each_color
    seq = [
      @main_controller.get_board[1, 0], @main_controller.get_board[5, 0], @main_controller.get_board[2, 0], @main_controller.get_board[4, 0], @main_controller.get_board[6, 5], @main_controller.get_board[0, 5], @main_controller.get_board[6, 4], @main_controller.get_board[0, 4],
      @main_controller.get_board[6, 3], @main_controller.get_board[0, 3], @main_controller.get_board[6, 2], @main_controller.get_board[0, 2], @main_controller.get_board[6, 1], @main_controller.get_board[0, 1], @main_controller.get_board[7, 1], @main_controller.get_board[1, 1],
      @main_controller.get_board[7, 0], @main_controller.get_board[3, 0], @main_controller.get_board[5, 1], @main_controller.get_board[1, 3], @main_controller.get_board[4, 1], @main_controller.get_board[2, 1] 
    ]
    do_move_sequence(seq)

    assert_equal TanboBoard::BLACK, @main_controller.whose_turn?, "Should be BLACK's turn after WHITE bounds two roots."

    point = @main_controller.get_board[0, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[1, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[2, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[3, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[4, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[5, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect
    point = @main_controller.get_board[6, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containg removed root pieces should be BLANK at: " + point.inspect

    black_points = [
     @main_controller.get_board[6, 5], @main_controller.get_board[6, 4], @main_controller.get_board[6, 3], @main_controller.get_board[6, 2], @main_controller.get_board[6, 1], @main_controller.get_board[7, 1], @main_controller.get_board[7, 0], @main_controller.get_board[5, 1], @main_controller.get_board[4, 1]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
     @main_controller.get_board[0, 5], @main_controller.get_board[0, 4], @main_controller.get_board[0, 3], @main_controller.get_board[0, 2], @main_controller.get_board[0, 1], @main_controller.get_board[1, 1], @main_controller.get_board[1, 3], @main_controller.get_board[2, 1]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
end