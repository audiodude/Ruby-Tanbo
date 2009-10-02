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

class AIRandbo
  
  def initialize(color, board_ui)
    @color = color
    @board_ui = board_ui
  end
  
  def move(board, last_move)
    return if board.game_over?
    
    if $HEADLESS_MODE
      puts "Picking random move..."
    else
      @board_ui.enable(false)
      begin_busy_cursor
    end
    
    moves = board.get_all_moves(@color)
    return nil if moves.empty? #can't make a move if there are no moves to make!
    chosen = moves.keys[rand(moves.keys.size)]
    
    if $HEADLESS_MODE
      puts "Making move"
    else
      end_busy_cursor
      @board_ui.enable
    end
    
    return [chosen.x, chosen.y]
  end
end