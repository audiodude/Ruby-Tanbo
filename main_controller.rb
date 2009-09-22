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

require 'root.rb'
require 'tanbo_board.rb'
require 'observer'

# The conroller, which stores the state of the game, calculates
# valid moves, and calculates the effects of moves.
class MainController
  # The controller observes the gameboard, and everyone else observes the controller
  include Observable
  
  attr_reader :roots
  attr_accessor :modified, :player1, :player2

  RUN = 1
  PAUSE = 0
  STOP = nil

  def initialize
    @run_mutex = Mutex.new
    reset!
  end
  
  # Set up the game board and game conditions. This method is called from
  # initialize, and is the appropriate method for "New game" functionality.
  def reset!
    # The game board is a 19x19 2D grid of intersections (a Go board)
    @gameboard = TanboBoard.new

    @gameboard.add_observer(self)

    @gameboard.turn = TanboBoard::BLACK

    # Set all the initial white pieces
    init_white = [
      @gameboard[6 ,0 ], @gameboard[18,0 ],
      @gameboard[0 ,6 ], @gameboard[12,6 ],
      @gameboard[6 ,12], @gameboard[18,12],
      @gameboard[0 ,18], @gameboard[12,18]
    ]
    init_white.each do |point|
      point.color = TanboBoard::WHITE
      @gameboard.roots << @gameboard.add_point_to_root(point, Root.new(TanboBoard::WHITE))
    end
    
    # And all of the initial black ones
    init_black = [
      @gameboard[0 ,0 ], @gameboard[12,0 ],
      @gameboard[6 ,6 ], @gameboard[18,6 ],
      @gameboard[12,12], @gameboard[18,18],
      @gameboard[6 ,18], @gameboard[0 ,12]
    ]
    init_black.each do |point|
      point.color = TanboBoard::BLACK
      @gameboard.roots << @gameboard.add_point_to_root(point, Root.new(TanboBoard::BLACK))
    end
  end
  
  def start!
    @running = true
    Thread.new {
        raise "Player 1 not set!" unless @player1
        raise "Player 2 not set!" unless @player2
  
        last_move = nil
        while not @gameboard.game_over?
          value = RUN
          @run_mutex.synchronize do
            value = @running
          end
          
          case value
            when STOP
              break
            when PAUSE
              next
          end
          
          if @gameboard.turn == TanboBoard::BLACK
            next_move = @player1.move(@gameboard, last_move)
          else
            next_move = @player2.move(@gameboard, last_move)
          end
          next unless next_move
    
          move_point = @gameboard[next_move[0], next_move[1]]
          adj = @gameboard.valid_move?(move_point)
          raise "Invalid move returned from player" unless adj
    
          @gameboard.make_move(move_point, adj)
          last_move = move_point
        end
    }
  end
  
  def stop!
    @run_mutex.synchronize do
      @running = STOP
    end
  end
  
  def pause!
    @run_mutex.synchronize do
      @running = PAUSE
    end
  end
  
  def unpause!
    @run_mutex.synchronize do
      @running = RUN
    end
  end
  
  def running?
    @running
  end
  
  def update(event)
    changed
    notify_observers(event)
  end
  
  def set_board(board)
    @gameboard = board
    @gameboard.add_observer(self)
  end
  
  def get_board
    @gameboard
  end
  
  def get_color(point)
    if point.in_bounds?
      point.color
    else
      nil
    end
  end
  
  ## Convenience for auto-playing for debug. This is the same logic as
  ## Randbo, but this is NOT the code that Randbo runs. See ai/randbo.rb
  def random_move
    return if @gameboard.game_over?
    
    moves = @gameboard.get_all_moves
    return if moves.empty? #Guard against race conditions
    chosen = moves.keys[rand(moves.keys.size)]
    @gameboard.make_move(chosen, moves[chosen])
  end
  ## End convenience auto-play code
  
  def blank?(point)
    return point && point.color == TanboBoard::BLANK
  end
  
  alias :empty? :blank?
  
  def debug
    require 'pp'
    
    @gameboard.roots.each do |r|
      puts r.inspect
      puts "=========="
    end

    puts "-"*10
    puts output_board
  end
  
  # Return the text representation of the gameboard
  def output_board
    return @gameboard.inspect
  end
  
  # Parse a string in the above format (including newlines) and set the state
  # of the game board accordingly
  def parse_board(str)
    return unless str
    @gameboard = TanboBoard.new
    @gameboard.add_observer(self)
    @roots = []
    
    chars = str.split(/\n/).collect { |line|
      line.scan(/WHITE|BLACK|./m)
    }.flatten
    
    0.upto(18) do |x|
      0.upto(18) do |y|
        c = chars.shift
        case c
          when 'w'
            @gameboard[y, x].color = TanboBoard::WHITE
          when 'b'
            @gameboard[y, x].color = TanboBoard::BLACK
          when '.'
            @gameboard[y, x].color = TanboBoard::BLANK
        end
      end
    end
    
    if(chars.shift == "WHITE")
      @gameboard.turn = TanboBoard::WHITE
    else
      @gameboard.turn = TanboBoard::BLACK
    end
    
    create_roots
  end
  
  def create_roots
    visited = {}
    0.upto(18) do |x|
      0.upto(18) do |y|
        point = @gameboard[x, y]
        # Skip this square if it's already been visited by one of the dfs runs
        next if visited[point]
        
        # Mark as visited, but skip if its empty
        if point.color == TanboBoard::BLANK
          visited[point] = true
          next
        end
        
        # Create a new root for this square and add it to @pts_to_root and @roots
        # The point is marked as visited in this method
        new_root = Root.new(point.color)
        @gameboard.roots << new_root
        dfs_add_to_root(point, new_root, visited)
      end
    end
  end
  
  # Add
  def dfs_add_to_root(point, root, visited)
    visited[point] = true
    if(point.color == root.color)
      add_point_to_root(point, root)
    end
    point.bounded_neighbors.each do |neighbor|
      if (! visited.include?(neighbor)) and neighbor.color == root.color
        dfs_add_to_root(neighbor, root, visited)
      end
    end
  end

end