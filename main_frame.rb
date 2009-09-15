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
      controller.debug
    } 	
    
    @save_button = Button.new(self, :label=>"Save Game")
    button_sizer.add(@save_button, 0, FIXED_MINSIZE|ALIGN_CENTER, 20)
    button_sizer.add_spacer(22)
    
    @load_button = Button.new(self, :label=>"Load Game")
    button_sizer.add(@load_button, 0, FIXED_MINSIZE|ALIGN_CENTER, 20)
    button_sizer.add_spacer(22)
    
    @about_button = Button.new(self, :label=>"About")
    button_sizer.add(@about_button, 0, FIXED_MINSIZE|ALIGN_CENTER, 20)
    button_sizer.add_stretch_spacer(1)
  end
  
  def set_controller(controller)
    @main_controller = controller
  end
  
end