class BoardPanel < Panel
  BG_BRUSH = Brush.new(Colour.new(232, 232, 160))
  BG_PEN = Pen.new(Colour.new(232, 232, 160))
  
  def initialize(parent, controller)
    super(parent, :size => [parent.get_client_size.get_width-20, parent.get_client_size.get_height/1.25])
    @controller = controller
    evt_paint() {|event|
      do_paint
    }
    
    evt_motion() {|event|
      do_hover(event)
    }
    
    evt_left_down() {| event|
      do_click(event)
    }
  end
  
  def get_board_loc(point)
    x,y = point
    x_loc = x - get_origin[0]
    return nil if x_loc < 0 || x_loc > get_square_width*18
    x_loc = x_loc.to_f/get_square_width
    xdec = x_loc - x_loc.to_i
    x_loc = x_loc.to_i
    if xdec > 0.3
      if xdec < 0.7
        return nil
      else
        x_loc += 1
      end
    end
    
    y_loc = y- get_origin[1]
    return nil if y_loc < 0 || y_loc > get_square_height*18
    y_loc = y_loc.to_f/get_square_height
    ydec = y_loc - y_loc.to_i
    y_loc = y_loc.to_i
    if ydec > 0.3
      if ydec < 0.7
        return nil
      else
        y_loc += 1
      end
    end
    
    return @controller.get_board[x_loc, y_loc]
  end
  
  def do_paint
    paint { |dc|
      dc.set_brush(BG_BRUSH)
      dc.set_pen(TRANSPARENT_PEN)
      dc.draw_rectangle(0, 0, self.get_client_size.get_width, self.get_client_size.get_height)
      
      draw_board(dc)
      draw_stones(dc)
    }
  end
  
  def do_hover(event)
    w = get_square_width
    h = get_square_height
    x0, y0 = get_origin
  
    if @last_hover && @controller.blank?(@controller.get_board[@last_hover[0], @last_hover[1]])
      x, y = @last_hover
      paint { |dc|
        dc.set_brush(BG_BRUSH)
        dc.set_pen(BG_PEN)
        dc.draw_rectangle(((x-0.5)*w + x0).to_i, ((y-0.5)*h + y0).to_i, w, h)
        
        dc.set_pen(BLACK_PEN)
        dc.draw_line(([(x-0.5), 0].max*w).to_i + x0, y*h + y0, ([(x+0.5),18].min*w).to_i + x0, y*h + y0)
        dc.draw_line(x*w + x0, ([(y-0.5),0].max*h).to_i + y0, x*w + x0, ([(y+0.5),18].min*h).to_i + y0)
      }
    end
  
    hover_loc = get_board_loc([event.get_x, event.get_y])
    return unless hover_loc
    
    x_loc, y_loc = hover_loc.x, hover_loc.y
    @last_hover = [x_loc, y_loc]
    
    if @controller.valid_move?(hover_loc)
      paint { |dc|
        dc.set_pen(BLACK_PEN)
        
        if @controller.whose_turn? == -1
          dc.set_brush(BLACK_BRUSH)
        else
          dc.set_brush(BG_BRUSH)
        end
        
        dc.draw_circle(x_loc*w + x0, y_loc*h + y0, w/3)
      }
    end
  end
  
  def do_click(event)
    black_turn = @controller.whose_turn? == -1
    point = get_board_loc([event.get_x, event.get_y])
    return unless point
    move = @controller.valid_move?(point)
    if move
      @controller.make_move(point, move)
      
      # Refresh the board after doing the move
      do_paint
      
      # If the root got removed, try to hover over for the opposing player
      do_hover(event)
    end
  end
  
  def get_square_width
    (self.get_client_size.get_width/19).to_i  
  end
  
  def get_square_height
    (self.get_client_size.get_height/19).to_i
  end
  
  def get_origin
    [(get_square_width*0.5 + self.get_client_size.get_width%19/2).to_i,
     (get_square_height*0.5 + self.get_client_size.get_height%19/2).to_i]
  end
  
  def draw_board(dc)
    w = get_square_width
    h = get_square_height
    lx = w*18
    ly = h*18
    
    dc.set_pen(BLACK_PEN)
    x, y = get_origin

    20.times do
      dc.draw_line(x, y, x+lx, y)
      y += h
    end

    y = (h*0.5 + self.get_client_size.get_height%19/2).to_i
    20.times do
      dc.draw_line(x, y, x, y+ly)
      x += w
    end
  end
  
  def draw_stones(dc)
    dc.set_pen(BLACK_PEN)
    w = get_square_width
    h = get_square_height
    
    x0, y0 = get_origin
    
    board = @controller.get_board
    0.upto 18 do |x|
      0.upto 18 do |y|
        c = board[x, y].color
        if c != TanboBoard::BLANK
          if c == TanboBoard::BLACK
            dc.set_brush(BLACK_BRUSH)
          elsif c == TanboBoard::WHITE
            dc.set_brush(BG_BRUSH)
          else
            raise "Point: " + board[x, y] + " was unrecognized color: " + c
          end
          dc.draw_circle(x*w + x0, y*h + y0, w/3)
        end
      end
    end
  end
end