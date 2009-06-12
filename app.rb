require 'wx'
include Wx

require 'main_frame.rb'
require 'main_controller.rb'

class MainApp < App
  def on_init
    main_controller = MainController.new
    main_frame = MainFrame.new(main_controller)
    main_frame.show
  end
end
 

MainApp.new.main_loop