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

class Root
  attr_reader :color
  attr_accessor :points, :liberties

  def initialize(color)
    @points = []
    @color = color
    @liberties = []
    # The controller should call its own add_point_to_root method to
    # add the initial point
  end
  
  def remove_point(point)
    @liberties.delete(point)
  end
  
  def bounded?
    @liberties.empty?
  end
  
  def inspect
    "root{" + @liberties.inspect + "-" + @points.inspect + "}"
  end
  
  def deep_copy(board)
    copy = Root.new(@color)
    copy.points = points.dup
    copy.liberties = liberties.dup
    copy.associate_with(board)
    
    return copy
  end
  
  # Replaces the points and liberties in this root with ones
  # representing the same point, but sourced from the given board.
  # Used for object copying
  def associate_with(board)
    @points.map! do |point|
      point = board[point.x, point.y]
      point.root = self
      point
    end
    
    @liberties.map! do |point|
      board[point.x, point.y]
    end
  end
end