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
  end
  
end
 
# Run the application
MainApp.new.main_loop