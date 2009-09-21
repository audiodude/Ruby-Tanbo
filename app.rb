#!/usr/bin/env ruby
require 'wx'
include Wx

require 'main_frame.rb'
require 'main_controller.rb'

# The wx application root
class MainApp < App
  def on_init
    main_controller = MainController.new
    main_frame = MainFrame.new(main_controller)
    main_frame.show
    
    # Don't let the GUI hang....this lets the bots play each other
    t = Wx::Timer.new(main_frame)
    evt_timer(t.id) { Thread.pass }
    t.start(10)
  end
  
end
 
# Run the application
Thread.abort_on_exception = true
MainApp.new.main_loop