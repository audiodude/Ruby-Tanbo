require 'board_panel.rb'

class MainFrame < Frame
  
  MSG_FONT = Font.new(26, FONTFAMILY_SWISS, FONTSTYLE_NORMAL, FONTWEIGHT_BOLD)
  AUTOPLAY_INTERVAL = 0.020  #Interval to make auto moves, in seconds
  
  def initialize(controller)
    super(nil,  :title => "Tanbo", 
                :pos => [100, 25],  
                :size => [450, 640],
                :style => DEFAULT_FRAME_STYLE | FULL_REPAINT_ON_RESIZE
    )
    
    controller.add_observer(self)
    @auto_move_timer = Wx::Timer.new(self)
    evt_timer(@auto_move_timer.id) {
      controller.random_move
      @board.do_paint
    }
    
    self.set_min_size([450,640])
    
    sizer = Wx::BoxSizer.new(VERTICAL)
    
    @board = BoardPanel.new(self, controller)
    sizer.add(@board, 40, SHAPED|LEFT|RIGHT|TOP|ALIGN_CENTER_HORIZONTAL, 10)
    
    button_sizer = BoxSizer.new(HORIZONTAL)
    button_sizer.set_min_size(470, 60)
    sizer.add(button_sizer, 4, SHAPED|LEFT|RIGHT|ALIGN_CENTER_HORIZONTAL, 10)
    
    @msg_area = StaticText.new(self, :label => "", :size => [400, 30], :style=>ALIGN_CENTRE)
    sizer.add(@msg_area, 3, SHAPED|ALIGN_CENTER|ALIGN_CENTER_HORIZONTAL|LEFT|RIGHT|BOTTOM, 10)
    @msg_area.set_font(MSG_FONT)
    
    @new_button = Button.new(self, :label=>"New Game")
    button_sizer.add_stretch_spacer(1)
    button_sizer.add(@new_button, 0, FIXED_MINSIZE|ALIGN_CENTER, 20)
    button_sizer.add_spacer(22)
    
    evt_button(@new_button.id) { |event|
      controller.reset!
      @board.do_paint
    }
    
    @save_button = Button.new(self, :label=>"Save Game")
    button_sizer.add(@save_button, 0, FIXED_MINSIZE|ALIGN_CENTER, 20)
    button_sizer.add_spacer(22)
    
    evt_button(@save_button.id) { |event|
      picker = FileDialog.new(self, :style => FD_SAVE | FD_OVERWRITE_PROMPT)
      picker.set_filename("Tanbo_#{Time.new.strftime('%Y.%m.%d-%H.%M')}.tan")
      picker.show_modal
      begin
        save_file = File.new(picker.get_path, 'w')
        save_file.puts(controller.output_board)
        controller.modified = false
      rescue SystemCallError, IOError=>e
        MessageDialog.new(self, "The file you specified could not be created. Your game was not saved! Check file system permissions and try again.", 
                          "Problem saving file", 
                          OK | ICON_EXCLAMATION ).show_modal
      ensure
        save_file.close if save_file
      end
    }
    
    @load_button = Button.new(self, :label=>"Load Game")
    button_sizer.add(@load_button, 0, FIXED_MINSIZE|ALIGN_CENTER, 20)
    button_sizer.add_spacer(22)
    
    evt_button(@load_button.id) { |event|
      next # not working atm
      
      # if(controller.modified)
      #         MessageDialog.new(self, "If you load a game now, your current game will be lost. Abort game in progress?", 
      #                           :style => NO_DEFAULT | ICON_QUESTION ).show_modal
      #       end
      
      picker = FileDialog.new(self, :style => FD_OPEN | FD_FILE_MUST_EXIST)
      picker.show_modal
      begin
        load_file = File.new(picker.get_path, 'r')
        controller.parse_board(load_file.read)
        @board.do_paint
      rescue SystemCallError, IOError=>e
        unless ID_YES == MessageDialog.new(self, "The file you specified could not be opened", 
                          :style => OK | ICON_EXCLAMATION ).show_modal
          next
        end
      ensure
        load_file.close if load_file
      end
    }
    
    @about_button = Button.new(self, :label=>"Debug")
    button_sizer.add(@about_button, 0, FIXED_MINSIZE|ALIGN_CENTER, 20)
    button_sizer.add_stretch_spacer(1)
    
    evt_button(@about_button.id) { |event|
      # Output state info
      controller.debug
      
      # Toggle auto playing
      if (not controller.game_over?) && @auto_move_timer.is_running
        @auto_move_timer.stop
      else
        @auto_move_timer.start((AUTOPLAY_INTERVAL*1000).to_i)
      end
    }
    
    set_sizer(sizer)
  end
  
  def set_controller(controller)
    @main_controller = controller
  end
  
  def update(event)
    #Game's over dude. Stop doing auto moves
    @auto_move_timer.stop
    
    if event == MainController::WHITE_WINS_EVENT
      @msg_area.set_label("White wins!")
    elsif event == MainController::BLACK_WINS_EVENT
      @msg_area.set_label("Black wins!")
    end
  end
  
end