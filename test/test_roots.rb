require 'test/ruby_tanbo_test.rb'
require 'main_controller.rb'
require 'test/unit/testsuite'


class RootTest < Test::Unit::TestCase
  include RubyTanboTest

  def test_simple_white_bounded
    seq = [
      @gameboard[5, 6], @gameboard[5, 12], @gameboard[4, 6], @gameboard[4, 12], @gameboard[3, 6], @gameboard[3, 12], @gameboard[2, 6],
      @gameboard[2, 12], @gameboard[1, 6], @gameboard[1, 12], @gameboard[1, 5], @gameboard[1, 11], @gameboard[0, 5], @gameboard[0, 11],
      @gameboard[1, 7], @gameboard[1, 13], @gameboard[0, 7]
    ]
    require 'pp'
    do_move_sequence(seq)
    
    assert_equal TanboBoard::WHITE, @gameboard.turn, "Should be WHITE's turn after BLACK bounds WHITE root."
    assert_equal TanboBoard::BLANK, @main_controller.get_color(@gameboard[0, 6]), "Square containing removed root should be BLANK."
    
    black_points = [
      @gameboard[5, 6], @gameboard[4, 6], @gameboard[3, 6], @gameboard[2, 6], @gameboard[1, 6], @gameboard[1, 5], @gameboard[0, 5], @gameboard[1, 7], @gameboard[0, 7]  
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end
    
    white_points = [
      @gameboard[5, 12], @gameboard[4, 12], @gameboard[3, 12], @gameboard[2, 12], @gameboard[1, 12], @gameboard[1, 11], @gameboard[0, 11], @gameboard[1, 13]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_simple_white_two_bounded
    seq = [
      @gameboard[5, 6], @gameboard[0, 5], @gameboard[4, 6], @gameboard[5, 0], @gameboard[3, 6], @gameboard[11, 6], @gameboard[2, 6],
      @gameboard[13, 18], @gameboard[1, 6], @gameboard[0, 17], @gameboard[1, 7], @gameboard[5, 12], @gameboard[0, 7], @gameboard[17, 12],
      @gameboard[1, 5], @gameboard[17, 0], @gameboard[1, 4], @gameboard[7, 0], @gameboard[0, 4]
    ]
    do_move_sequence(seq)
    
    assert_equal TanboBoard::WHITE, @gameboard.turn, "Should be WHITE's turn after BLACK bounds WHITE root."

    point = @gameboard[0, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[0, 5]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    
    black_points = [
      @gameboard[5, 6], @gameboard[4, 6], @gameboard[3, 6], @gameboard[2, 6], @gameboard[1, 6], @gameboard[1, 7], @gameboard[0, 7], @gameboard[1, 5], @gameboard[1, 4], @gameboard[0, 4] 
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end
    
    white_points = [
      @gameboard[5, 0], @gameboard[11, 6], @gameboard[13, 18], @gameboard[0, 17], @gameboard[5, 12], @gameboard[17, 12], @gameboard[17, 0], @gameboard[7, 0]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_simple_black_two_bounded
    seq = [
      @gameboard[5, 6], @gameboard[5, 12], @gameboard[4, 6], @gameboard[4, 12], @gameboard[3, 6], @gameboard[3, 12], @gameboard[11, 0], @gameboard[2, 12],
      @gameboard[1, 0], @gameboard[1, 12], @gameboard[5, 18], @gameboard[1, 11], @gameboard[11, 12], @gameboard[1, 13], @gameboard[17, 18],
      @gameboard[0, 13], @gameboard[17, 6], @gameboard[1, 10], @gameboard[0, 11], @gameboard[0, 10]
    ]
    do_move_sequence(seq)

    assert_equal TanboBoard::BLACK, @gameboard.turn, "Should be BLACK's turn after WHITE bounds BLACK root."

    point = @gameboard[0, 12]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      @gameboard[5, 6], @gameboard[4, 6], @gameboard[3, 6], @gameboard[11, 0], @gameboard[1, 0], @gameboard[5, 18], @gameboard[11, 12], @gameboard[17, 18], @gameboard[17, 6] 
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
      @gameboard[5, 12], @gameboard[4, 12], @gameboard[3, 12], @gameboard[2, 12], @gameboard[1, 12], @gameboard[1, 11], @gameboard[1, 13], @gameboard[0, 13], @gameboard[1, 10], @gameboard[0, 10]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_white_self_bound_no_blank
    seq = [
      @gameboard[5, 6], @gameboard[0, 7], @gameboard[4, 6], @gameboard[5, 12], @gameboard[3, 6], @gameboard[11, 18], @gameboard[2, 6],
      @gameboard[11, 6], @gameboard[1, 6], @gameboard[7, 0], @gameboard[1, 5], @gameboard[17, 0], @gameboard[0, 5], @gameboard[17, 1],
      @gameboard[1, 7], @gameboard[17, 12], @gameboard[1, 8], @gameboard[0, 17], @gameboard[1, 9], @gameboard[12, 7], @gameboard[0, 9],
      @gameboard[4, 12], @gameboard[2, 8], @gameboard[0, 8]
    ]
    do_move_sequence(seq)

    assert_equal TanboBoard::BLACK, @gameboard.turn, "Should be BLACK's turn after WHITE bounds itself."

    point = @gameboard[0, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[0, 7]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[0, 8]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      @gameboard[5, 6], @gameboard[4, 6], @gameboard[3, 6], @gameboard[2, 6], @gameboard[1, 6], @gameboard[1, 5], @gameboard[0, 5], @gameboard[1, 7], @gameboard[1, 8], @gameboard[1, 9], @gameboard[0, 9], @gameboard[2, 8]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
      @gameboard[5, 12], @gameboard[11, 18], @gameboard[11, 6], @gameboard[7, 0], @gameboard[17, 0], @gameboard[17, 1], @gameboard[17, 12], @gameboard[0, 17], @gameboard[12, 7], @gameboard[4, 12]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_white_bounded_two_blanks
    seq = [
      @gameboard[5, 6], @gameboard[5, 12], @gameboard[4, 6], @gameboard[1, 6], @gameboard[3, 6], @gameboard[1, 5], @gameboard[2, 6],
      @gameboard[11, 18], @gameboard[2, 5], @gameboard[5, 0], @gameboard[2, 4], @gameboard[11, 6], @gameboard[2, 7], @gameboard[0, 7],
      @gameboard[2, 8], @gameboard[1, 18], @gameboard[1, 8], @gameboard[17, 12], @gameboard[0, 8], @gameboard[18, 1], @gameboard[1, 4]
    ]
    do_move_sequence(seq)

    assert_equal TanboBoard::WHITE, @gameboard.turn, "Should be WHITE's turn after BLACK bounds WHITE root."

    point = @gameboard[0, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[1, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[1, 5]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[0, 7]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      @gameboard[5, 6], @gameboard[4, 6], @gameboard[3, 6], @gameboard[2, 6], @gameboard[2, 5], @gameboard[2, 4], @gameboard[2, 7], @gameboard[2, 8], @gameboard[1, 8], @gameboard[0, 8], @gameboard[1, 4]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
      @gameboard[5, 12], @gameboard[11, 18], @gameboard[5, 0], @gameboard[11, 6], @gameboard[1, 18], @gameboard[17, 12], @gameboard[18, 1]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_white_self_bound_one_blank
    seq = [
      @gameboard[5, 6], @gameboard[1, 6], @gameboard[4, 6], @gameboard[1, 7], @gameboard[3, 6], @gameboard[5, 0], @gameboard[2, 6],
      @gameboard[11, 6], @gameboard[2, 5], @gameboard[4, 0], @gameboard[1, 5], @gameboard[13, 6], @gameboard[0, 5], @gameboard[10, 6],
      @gameboard[2, 7], @gameboard[5, 12], @gameboard[2, 8], @gameboard[11, 7], @gameboard[2, 9], @gameboard[1, 8], @gameboard[1, 9],
      @gameboard[9, 6], @gameboard[0, 9], @gameboard[0, 8]
    ]
    do_move_sequence(seq)

    assert_equal TanboBoard::BLACK, @gameboard.turn, "Should be BLACK's turn after WHITE bounds itself."

    point = @gameboard[0, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[1, 6]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[1, 7]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[1, 8]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[0, 8]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect

    black_points = [
      @gameboard[5, 6], @gameboard[4, 6], @gameboard[3, 6], @gameboard[2, 6], @gameboard[2, 5], @gameboard[1, 5], @gameboard[0, 5], @gameboard[2, 7], @gameboard[2, 8], @gameboard[2, 9], @gameboard[1, 9], @gameboard[0, 9]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
     @gameboard[5, 0], @gameboard[11, 6], @gameboard[4, 0], @gameboard[13, 6], @gameboard[10, 6], @gameboard[5, 12], @gameboard[11, 7], @gameboard[9, 6]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
  
  def test_bound_one_each_color
    seq = [
      @gameboard[1, 0], @gameboard[5, 0], @gameboard[2, 0], @gameboard[4, 0], @gameboard[6, 5], @gameboard[0, 5], @gameboard[6, 4], @gameboard[0, 4],
      @gameboard[6, 3], @gameboard[0, 3], @gameboard[6, 2], @gameboard[0, 2], @gameboard[6, 1], @gameboard[0, 1], @gameboard[7, 1], @gameboard[1, 1],
      @gameboard[7, 0], @gameboard[3, 0], @gameboard[5, 1], @gameboard[1, 3], @gameboard[4, 1], @gameboard[2, 1] 
    ]
    do_move_sequence(seq)

    assert_equal TanboBoard::BLACK, @gameboard.turn, "Should be BLACK's turn after WHITE bounds two roots."

    point = @gameboard[0, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[1, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[2, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[3, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[4, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[5, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect
    point = @gameboard[6, 0]
    assert_equal TanboBoard::BLANK, @main_controller.get_color(point), "Squares containing removed root pieces should be BLANK at: " + point.inspect

    black_points = [
     @gameboard[6, 5], @gameboard[6, 4], @gameboard[6, 3], @gameboard[6, 2], @gameboard[6, 1], @gameboard[7, 1], @gameboard[7, 0], @gameboard[5, 1], @gameboard[4, 1]
    ]
    msg = "Expected point to be BLACK after black move sequence at: "
    for point in black_points
      assert_equal TanboBoard::BLACK, @main_controller.get_color(point), (msg + point.inspect)
    end

    white_points = [
     @gameboard[0, 5], @gameboard[0, 4], @gameboard[0, 3], @gameboard[0, 2], @gameboard[0, 1], @gameboard[1, 1], @gameboard[1, 3], @gameboard[2, 1]
    ]
    msg = "Expected point to be WHITE after white move sequence at: "
    for point in white_points
      assert_equal TanboBoard::WHITE, @main_controller.get_color(point), (msg + point.inspect)
    end
  end
end