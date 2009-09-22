# Author: Travis Briggs, briggs.travis (at) gmail.com
# ===================================================
# Copyright (C) 2009 Travis Briggs
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. See the COPYING file. If not, see
# <http://www.gnu.org/licenses/>.

require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'main_controller.rb'

module RubyTanboTest 
  def setup
    # The original test. The gameboard is the gameboard that the controller
    # created for itself
    @main_controller = MainController.new
    @gameboard = @main_controller.get_board
  end

  # def teardown
  # end

  # Perform a sequence of moves, first asserting that the move is valid
  def do_move_sequence(moves)
    for move in moves
      adj = @gameboard.valid_move?(move)
      assert adj, ("Move in sequence was not valid: " + move.inspect)
      @gameboard.make_move(move, adj)
    end
  end
end

#Collect tests for automatic test suite
require 'test/test_board.rb'
require 'test/test_moves.rb'
require 'test/test_roots.rb'

  suite = Test::Unit::TestSuite.new("All Tests")
  suite << BoardTest.suite
  suite << MovesTest.suite
  suite << RootTest.suite
  
Test::Unit::UI::Console::TestRunner.run(suite)


puts "Re-running tests, with copied @gameboard..."
# Let's get tricky! We're going to run the same test suite, but we're going
# to replace the board in the setup method with a copy of itself! YOWZA!

module RubyTanboTest 
  def setup
    # Modified test. We create a copy of the @gameboard, and re-assign it to
    # the controller. If copying is working properly, this should make no
    # difference (including for tests that copy inside themselves!)
    @main_controller = MainController.new
    @gameboard = @main_controller.get_board.deep_copy
    @main_controller.set_board(@gameboard)
  end
end

Test::Unit::UI::Console::TestRunner.run(suite)
