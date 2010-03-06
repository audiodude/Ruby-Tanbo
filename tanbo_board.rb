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

require 'observer'

class TanboBoard
  include Observable
  
  attr_reader :last_move
  attr_accessor :points, :turn, :roots, :modified
  
  BOARD_UPDATE_EVENT = -100
  BLACK_WINS_EVENT = -11
  WHITE_WINS_EVENT = -22
  
  WHITE = 1
  EMPTY = BLANK = 0
  BLACK = -1
  
  # Points only exist within Tanbo Boards. You can never construct a Point
  # directly, you access them through the TanboBoard's [] factory method.
  # So my_board[3, 2] gives you the Point at 3, 2. It will always return the
  # same point for the same TanboBoard instance.
  class Point  
    attr_reader :x, :y
    attr_accessor :root, :color
    
    # Use this pointer to implement convenience methods on the point object
    def initialize(x, y, board)
      @x, @y, @board = x, y, board
      @color = BLANK
    end
    
    # def neighbors
    #   return @neighbors if @neighbors
    #   @neighbors = @board.neighbors(self)
    #   return @neighbors
    # end

    def in_bounds?
      @board.in_bounds?(self)
    end
    
    def blank?
      @color == BLANK
    end

    def bounded_neighbors
      return @bounded_neighbors if @bounded_neighbors
      @bounded_neighbors = @board.bounded_neighbors(self)
      return @bounded_neighbors
    end
    
    def inspect
      "pt##{self.object_id}[#{x}, #{y}]"
    end
    
    def deep_copy(board)
      copy = Point.new(@x, @y, board)
      copy.color = @color
      copy.root = nil #Roots are set by the roots when the TanboBoard copies them
      
      return copy
    end
  end
  
  class OutOfBoundsPoint < Point
    @@instance = OutOfBoundsPoint.new(nil, nil, nil)
    
    def self.instance
      @@instance
    end

    def in_bounds?
      false
    end

    def blank?
      true
    end

    def bounded_neighbors
      return @@neighbors if @@neighbors
      @@neighbors = [OutOfBoundsPoint.instance, OutOfBoundsPoint.instance, OutOfBoundsPoint.instance, OutOfBoundsPoint.instance]
      return @@neighbors
    end

    def inspect
      "pt##{self.object_id}[OOB!]"
    end

    def deep_copy(board)
      raise "Cannot copy the out of bounds point!"
    end
  end
  
  def initialize
    # board = self
    # @points = Hash.new do |hash, key|
    #   hash[key] = Point.new(key/20, key%20, board)
    # end
    @points = Array.new(379)
    
    @modified = false
    
    # A root is a group of pieces of the same color, connected
    # Each of the initial pieces represents a root, and roots are
    # never added to the game, only removed.
    # A root is created for each of the initial pieces in the loops below,
    # and that piece is assigned to the root.
    @roots = []
  end
  
  def [](x, y)
    return OutOfBoundsPoint.instance if x < 0 || y < 0 || x > 18 || y > 18
    
    ans = @points[x*20 + y]
    unless ans
      ans = Point.new(x, y, self)
      @points[x*20 + y] = ans
    end
    return ans
  end
  
  def change_turns
   @turn = (@turn == BLACK ? WHITE : BLACK)
  end
  
  # If the game is not over, return nil
  # Otherwise, return the color constant (WHITE or BLACK) of the side that has
  # won the game
  def game_over?
    return nil unless @roots
    return @roots.first.color if @roots.size == 1
    winning_color = nil
    for root in @roots
      if winning_color 
        # There is no winner if we find a root with a different color than the
        # first color
        return nil if winning_color != root.color
      else
        # We haven't seen any colors yet. The first one we see is
        # the potential winner
        winning_color = root.color
      end
    end
    # If we got here, every root in the array matches the color of the first root
    return winning_color
  end
  
  # Adds the given point to the given root. This puts the point in the roots
  # points array, and calculates any liberties that should be added or removed
  # based on the value of the new point's neighbors.
  #
  # Returns the root, as a convenience for method chaining
  def add_point_to_root(point, root)
    # Add the point to the points, delete it from the available liberties
    point.root = root
    root.points << point
    root.liberties.delete(point)
    
    # Check each neighbor. If it's a valid move, it's a liberty. Otherwise,
    # it's not (remove it in case it was previously).
    bounded_neighbors(point).each do |pair|
      if valid_move?(pair, root.color)
        root.liberties << pair
      else
        root.liberties.delete(pair)
      end
    end
    
    return root
  end
  
  # Check if the given board location is a valid move for the given color.
   # If no color is given, the check is performed for the whichever color
   # currently has control of the board.
   #
   # Returns an array [x, y] of the board location of the piece that makes
   # this a valid move, or nil if there is no such piece. Always returns nil
   # when the game is in the BLACK_WINS or WHITE_WINS state.
   def valid_move?(point, color=nil)    
     return nil unless point
     return nil unless point.in_bounds?
     x,y = point.x, point.y
     color = @turn unless color

     # Valid moves are in within the bounds of the board
     return nil if x < 0 || y < 0 || x > 18 || y > 18

     # The location must be blank for the move to be valid
     return nil unless point.blank?

     adjacent = false
     answer = nil
     if x-1 >= 0 #Check the location to the west
       adj_point = self[x-1, y]
       if adj_point.color == color
         # The west location is the same color as the queried location.
         # For now, this is the answer, unless there are other adjacent
         # pieces, in which case this ceases to be a valid move
         answer = adj_point
         adjacent = true
       end
     end
     if y-1 >= 0 #North location
       adj_point = self[x, y-1]
       if adj_point.color == color
         # This is the answer, unless we have already found an adajcent piece
         if adjacent
           return nil
         else
           answer = adj_point
         end
         adjacent = true
       end
     end
     if x+1 < 19 #East location
       adj_point = self[x+1, y]
       if adj_point.color == color
         # Ditto
         if adjacent
           return nil
         else
           answer = adj_point
         end
         adjacent = true
       end
     end
     if y+1 < 19 #South location
       adj_point = self[x, y+1]
       if adj_point.color == color
         # Ditto
         if adjacent
           return nil
         else
           answer = adj_point
         end
         adjacent = true
       end
     end

     #puts "----#{point.inspect} -> #{answer.inspect}"
     return answer
   end
  
  # Remove the piece at the given point, setting it to BLANK
  def remove!(point)
    @modified = true
    self[point[0]][point[1]].color = TanboBoard::BLANK
  end
  
  # Remove all of the pieces from the board that are in the given root, setting
  # their color to BLANK
  def remove_root_pieces(root)
    for point in root.points
      point.color = TanboBoard::BLANK
    end
  end
  
  # Place a piece of the color of the current turn at the indicated x,y
  # location. 'adj' represents the piece that this piece will be adjacent
  # to, and allows us to calculate which root this piece is a part of.
  #
  # After the piece is place, calculations are done to see if any roots have
  # become bounded. If so, roots are immediately removed according to the
  # games bounding rules.
  #
  # If the BLACK_WINS or WHITE_WINS state is in effect, this is a no op.
  def make_move(point, adj)
    return if game_over?
    unless point
      #debug 
      raise ArgumentError, "nil value given for move"
    end
    
    @modified = true
    
    #print point.inspect + ", "
    x,y = point
    
    # Find the root that the newly placed piece is a part of
    cur_root = adj.root
    unless cur_root 
      #puts "@pts_to_root: #{@pts_to_root.inspect}"
      raise "Could not find root for pt: " + adj.inspect 
    end
    
    # Set the given location to the current turn's color
    point.color = self.turn
    @last_move = point
    
    # Switch turn control
    mover = self.turn
    self.change_turns
    
    # Add the point to the root, which causes the root's "valid moves" to be
    # recalculated
    add_point_to_root(point, cur_root)
    
    other_bounded = []
    # Get the new piece's neighbor's neighbors. If they contain roots,
    # let those roots recalculate if their liberties are still valid.
    for neighbor in point.bounded_neighbors
      # Skip the neighbor that allowed us to place the piece, and any
      # non-empty points. The status of filled points doesn't change
      # by placing a piece.    
      next if neighbor == adj || neighbor.color != TanboBoard::BLANK
      
      for next_neighbor in neighbor.bounded_neighbors
        next_root = next_neighbor.root
        if next_root && next_root != cur_root && next_root.color == cur_root.color
          # There is a root next to one of the new pieces neighbors, and it is
          # the same color as the root of this piece. That neighbor, therefore,
          # is no longer a liberty for that root.
          next_root.remove_point(neighbor)
        end
      end
    end
    
    # Now check every root
    for root in @roots
      # The current move is no longer a valid liberty of any root
      root.remove_point(point)
      
      # If the root has become bounded, keep track of it.
      if root.bounded? && root != cur_root
        other_bounded << root
      end
    end
    
    # If the current root is bounded, remove all of it's pieces and delete it
    # from the list of roots (effectively removing it from the board)
    if cur_root.bounded?
      remove_root_pieces(cur_root)
      @roots.delete(cur_root)
    else
      # Otherwise, similarly delete any other roots that have been bounded    
      if not other_bounded.empty?
        for root in other_bounded
          remove_root_pieces(root)
          @roots.delete(root)
        end
      end
    end
    
    changed
    notify_observers(BOARD_UPDATE_EVENT)
    
    # There can be only one...
    if winning_color = game_over? #Intentional assignment, returns nil if no one has won
      event = (winning_color == TanboBoard::WHITE ? WHITE_WINS_EVENT : BLACK_WINS_EVENT)
      changed
      notify_observers(event)
    end
  end
  
  # def neighbors(point)
  #   x,y = point.x, point.y
  #   return [ self[x+1, y], self[x, y+1], self[x-1, y], self[x, y-1] ]
  # end

  def in_bounds?(point)
    return false if point.x < 0
    return false if point.x > 18
    return false if point.y < 0
    return false if point.y > 18
  
    return true
  end

  def bounded_neighbors(point)
    if in_bounds?(point)
      x, y = point.x, point.y
      ans = []
      # If the point is in bounds, we only have to check what we're modifiying
      ans << self[x+1, y] if x+1 <= 18
      ans << self[x, y+1] if y+1 <= 18
      ans << self[x-1, y] if x-1 >= 0
      ans << self[x, y-1] if y-1 >= 0
      return ans
    end
  end
  
  # Copies the values of this TanboBoard to the given object (or a new TanboBoard
  # if no object is given) and returns it. As the name implies, everything is
  # deeply copied, so the returned object will be completely independent of
  # the object used to make the copy
  def deep_copy(copy = TanboBoard.new)
    copy.turn = @turn

    @points.each_with_index do |val, i|
      next unless val
      # Put a copy of each point, deep_copylicated using the new board, at all of the
      # used indices
      copy.points[i] = val.deep_copy(copy)
    end
    
    copy.roots = @roots.dup
    # puts @roots.size.to_s + " " + @roots.compact.size.to_s
    copy.roots.map! do |root|
      root.deep_copy(copy)
    end
    
    return copy
  end
  
  # A simple text representation of the game board. It looks like this:
  # b.....w.....b.....w
  # ...................
  # ...................
  # ...................
  # ...................
  # ...................
  # w.....b.....w.....b
  # ...................
  # ...................
  # ...................
  # ...................
  # ...................
  # b.....w.....b.....w
  # ...................
  # ...................
  # ...................
  # ...................
  # ...................
  # w.....b.....w.....b
  def inspect
    ans = ''
    0.upto(18) do |x|
      0.upto(18) do |y|
        case self[y, x].color
          when TanboBoard::WHITE
            ans += 'w'
          when TanboBoard::BLACK
            ans += 'b'
          when TanboBoard::BLANK
            ans += '.'
        end
      end
      ans += "\n"
    end
    ans += (@turn == TanboBoard::WHITE ? "WHITE" : "BLACK")
    ans += "\n"
    return ans
  end
  ## Convenience for auto-playing for debug. This is the same logic as
  ## Randbo, but this is NOT the code that Randbo runs. See ai/randbo.rb
  def get_all_moves(color=nil)
    color = @turn unless color
    
    ans = {}
    0.upto(18) {|x|
      0.upto(18) {|y|
        next_point = self[x, y]
        adj_point = valid_move?(next_point, color)
        ans[next_point] = adj_point if adj_point
      }
    }
    return ans
  end
  ## End convenience auto-play code
end