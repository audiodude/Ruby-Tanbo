#!/usr/bin/env ruby

Thread.abort_on_exception = true

if ARGV[0] =~ /nohead/i
  require 'board_cli.rb'
  require 'ai/human_player.rb'
  
  main_controller = MainController.new
  board = BoardCLI.new(main_controller)
  main_controller.player1 = @player1 = HumanPlayer.new(board)
  main_controller.player2 = @player2 = AIRandbo.new(main_controller.get_board, TanboBoard::WHITE)    
  main_controller.start!
  
  board.do_paint
  board.input_loop
else
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
  MainApp.new.main_loop
end