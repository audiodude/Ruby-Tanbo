require 'root.rb'

class MainController

  def initialize
    @turn = -1
    
    @gameboard = []
    19.times do
      @gameboard << Array.new(19, 0)
    end
    
    # Set all the initial white pieces
    @gameboard[6][0] = @gameboard[18][0] = @gameboard[0][6] =
    @gameboard[12][6] = @gameboard[6][12] = @gameboard[18][12] =
    @gameboard[0][18] = @gameboard[12][18] = 1
                 
    # And all of the initial black ones
    @gameboard[0][0] = @gameboard[12][0] = @gameboard[6][6] =
    @gameboard[18][6] = @gameboard[12][12] = @gameboard[18][18] =
    @gameboard[6][18] = @gameboard[0][12] = -1
    
    @roots = { [6, 0] => Root.new(6, 0, 1, self),
               [18, 0] => Root.new(18, 0, 1, self),
               [0, 6] => Root.new(0, 6, 1, self),
               [12, 6] => Root.new(12, 6, 1, self),
               [6, 12] => Root.new(6, 12, 1, self),
               [18, 12] => Root.new(18, 12, 1, self),
               [0, 18] => Root.new(0, 18, 1, self),
               [12, 18] => Root.new(12, 18, 1, self),
    
               [0, 0] => Root.new(0, 0, -1, self),
               [12, 0] => Root.new(12, 0, -1, self),
               [6, 6] => Root.new(6, 6, -1, self),
               [18, 6] => Root.new(18, 6, -1, self),
               [12, 12] => Root.new(12, 12, -1, self),
               [18, 18] => Root.new(18, 18, -1, self),
               [6, 18] => Root.new(6, 18, -1, self),
               [0, 12] => Root.new(0, 12, -1, self)
             }
  end
  
  def set_board(board)
    @board = board
  end
  
  def get_board
    @gameboard
  end
  
  def whose_turn?
    return @turn
  end
  
  def blank?(x, y)
    return @gameboard[x][y] == 0
  end
  
  def valid_move?(x, y, color=nil)
    color = whose_turn? unless color
    return nil if x < 0 || y < 0 || x > 18 || y > 18
    return nil unless blank?(x, y)
    
    answer = nil
    if x-1 >= 0
      if @gameboard[x-1][y] == color
        answer = [x-1, y]
      end
    end
    if y-1 >= 0
      if @gameboard[x][y-1] == color
        answer = (answer ? nil : [x, y-1])
      end
    end
    if x+1 < 19
      if @gameboard[x+1][y] == color
        answer = (answer ? nil : [x+1, y])
      end
    end
    if y+1 < 19
      if @gameboard[x][y+1] == color
        answer = (answer ? nil : [x, y+1])
      end
    end
    
    return answer
  end
  
  def make_move(x, y, adj)
    @gameboard[x][y] = @turn
    @turn = (@turn == -1 ? 1 : -1)
    
    cur_root = @roots[adj]
    cur_root.add_point(x, y)
    @roots[[x,y]] = cur_root
    other_bounded = []
    for root in @roots.values
      root.remove_point(x, y)
      if root.bounded?
        other_bounded << root
        puts 'bounded'
      end
    end
    if cur_root.bounded?
      cur_root.remove!
      @roots.delete(cur_root)
    else
      if not other_bounded.empty?
        for root in other_bounded
          root.remove!
          @roots.delete(root)
        end
      end
    end
    @board.do_paint
  end
  
  def remove(*args)
    if args.length == 1
      @gameboard[args[0][0]][args[0][1]] = 0
    else
      @gameboard[args[0]][args[1]] = 0
    end
  end

end