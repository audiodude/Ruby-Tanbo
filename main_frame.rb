require 'board_panel.rb'

class MainFrame < Frame

  def initialize(controller)
    super(nil,  :title => "Tanbo", 
                :pos => [100, 25],  
                :size => [450, 500],
                :style => DEFAULT_FRAME_STYLE | FULL_REPAINT_ON_RESIZE
    )
    
    self.set_min_size([450,500])
    
    sizer = Wx::BoxSizer.new(VERTICAL)
    set_sizer(sizer)
    
    @board = BoardPanel.new(self, controller)
    sizer.add(@board, 4, SHAPED|ALL, 10)
    
    button_sizer = BoxSizer.new(HORIZONTAL)
    button_sizer.set_min_size(470,80)
    sizer.add(button_sizer, 1, SHAPED|ALL, 10)
    
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
      if(controller.modified)
        MessageDialog.new(self, "Would you like to save your current game before loading a new one?", 
                          :style => NO_DEFAULT | ICON_QUESTION ).show_modal
      end
      
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
      controller.debug
    }
  end
  
  def set_controller(controller)
    @main_controller = controller
  end
  
end