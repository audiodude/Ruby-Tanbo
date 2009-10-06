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

require 'board_panel.rb'
require 'ai_select_dialog.rb'
require 'ai/human_player.rb'
require 'ai/ai_randbo.rb'
require 'ai/ai_uct.rb'
require 'monitor.rb'

class MainFrame < Frame
  include MonitorMixin
  
  MSG_FONT = Font.new(26, SWISS, NORMAL, BOLD)
  ABOUT_FONT = Font.new(13, ROMAN, NORMAL, NORMAL)
  AUTOPLAY_INTERVAL = 0.020  #Interval to make auto moves, in seconds
  
  def initialize(controller)
    super(nil,  :title => "Tanbo", 
                :pos => [100, 25],  
                :size => [450, 550],
                :style => DEFAULT_FRAME_STYLE | FULL_REPAINT_ON_RESIZE
    )
    @controller = controller
    
    self.set_min_size([450,550])
    
    @snd_your_turn = Sound.new('./resources/your_turn.wav')
    
    @sizer = Wx::BoxSizer.new(VERTICAL)
    
    @board = BoardPanel.new(self, @controller)
    @sizer.add(@board, 40, SHAPED|LEFT|RIGHT|TOP|ALIGN_CENTER_HORIZONTAL, 10)
    
    @controller.add_observer(self)
    @controller.add_observer(@board)
    @auto_move_timer = Wx::Timer.new(self)
    evt_timer(@auto_move_timer.id) {
      @controller.random_move
      @board.do_paint
    }
    
    button_sizer = BoxSizer.new(HORIZONTAL)
    button_sizer.set_min_size(470, 60)
    @sizer.add(button_sizer, 4, SHAPED|LEFT|RIGHT|ALIGN_CENTER_HORIZONTAL, 10)
    
    @msg_area = StaticText.new(self, :label => "", :size => [400, 28], :style=>ALIGN_CENTRE)
    @sizer.add(@msg_area, 3, SHAPED|ALIGN_CENTER|ALIGN_CENTER_HORIZONTAL|LEFT|RIGHT|BOTTOM|ST_NO_AUTORESIZE, 10)
    @msg_area.set_font(MSG_FONT)
    
    @new_button = Button.new(self, :label=>"New Game")
    button_sizer.add_stretch_spacer(1)
    button_sizer.add(@new_button, 0, FIXED_MINSIZE|ALIGN_CENTER, 20)
    button_sizer.add_spacer(22)
    
    evt_button(@new_button.id) { |event|
      do_new_button
    }
    
    @save_button = Button.new(self, :label=>"Save Game")
    button_sizer.add(@save_button, 0, FIXED_MINSIZE|ALIGN_CENTER, 20)
    button_sizer.add_spacer(22)
    
    evt_button(@save_button.id) { |event|
      do_save_button
    }
    
    @load_button = Button.new(self, :label=>"Load Game")
    button_sizer.add(@load_button, 0, FIXED_MINSIZE|ALIGN_CENTER, 20)
    button_sizer.add_spacer(22)
    
    evt_button(@load_button.id) { |event|
      do_load_button
    }
    
    if $DEBUG_OUT
      @about_button = Button.new(self, :label=>"Debug") 
    else
      @about_button = Button.new(self, :label=>"About")
    end
     
    button_sizer.add(@about_button, 0, FIXED_MINSIZE|ALIGN_CENTER, 20)
    button_sizer.add_stretch_spacer(1)
    
    evt_button(@about_button.id) { |event|
      if $DEBUG_OUT
        do_debug_button
      else
        do_about_button
      end
    }
    
    set_sizer(@sizer)
    
    # Kick off a new game of HUMAN/HUMAN
    @controller.player1 = @player1 = HumanPlayer.new(@board)
    @controller.player2 = @player2 = HumanPlayer.new(@board)    
    @controller.start!
    
    # Event when the window is closed
    evt_close() {|event|
      @controller.delete_observers
      @controller.stop!
      self.destroy
      
      #I don't know why this is necessary (it shouldn't be)
      THE_APP.exit_main_loop #Force the close.
    }
  end
  
  def update(event)    
    case event
    when TanboBoard::WHITE_WINS_EVENT
      #Game's over dude. Stop doing auto moves
      @auto_move_timer.stop
      @msg_area.set_label("White wins!")
      @sizer.recalc_sizes
      
    when TanboBoard::BLACK_WINS_EVENT
      #Game's over dude. Stop doing auto moves
      @auto_move_timer.stop
      @msg_area.set_label("Black wins!")
      @sizer.recalc_sizes
      
    when MainController::BOARD_READY_EVENT
      self.synchronize do
        return unless @waiting_to_select_ai
      end
    
      begin
        ai_select = AISelectDialog.new(@parent)
        return unless ID_OK == ai_select.show_modal
        
        @board.do_paint
        
        @controller.player1 = @player1 = get_ai(ai_select.player1_choice, TanboBoard::BLACK)
        @controller.player2 = @player2 = get_ai(ai_select.player2_choice, TanboBoard::WHITE)    
        @controller.stop!
        begin_busy_cursor
        sleep 0.5
        end_busy_cursor
        @controller.start!
      ensure
        # Make sure this only happens once
        self.synchronize do
          @waiting_to_select_ai = false
        end
      end
    when MainController::TURN_CHANGE_READY_EVENT
      if ( # See if it is now a human's turn
          ( @controller.get_board.turn == TanboBoard::BLACK &&
            @player1.is_a?(HumanPlayer) ) ||
          ( @controller.get_board.turn == TanboBoard::WHITE &&
                @player2.is_a?(HumanPlayer) )
         )
           if @controller.last_turn_time > 6 # We've waited more than 6 seconds
             @snd_your_turn.play(SOUND_ASYNC) if @snd_your_turn.is_ok
           else
             puts @controller.last_turn_time
           end
      end
    end
  end
  
  private
  def dirty_check
    return ID_YES == MessageDialog.new(self,
        "If you load a game now, your current game will be lost. Abort game in progress?", 
        :style => YES_NO | NO_DEFAULT | ICON_EXCLAMATION ).show_modal
  end
  
  # Instantiate the proper Player based on which AI was chosen in the dialog
  def get_ai(choice, color)
    case choice
      when AISelectDialog::HUMAN
        return HumanPlayer.new(@board)
      when AISelectDialog::AI_RANDBO
        return AIRandbo.new(color, @board)
      when AISelectDialog::AI_ULYSSES
        return AIUlysses.new(color, @board)
    end
  end
  
  # Method run when debug button is pressed
  def do_debug_button
    @controller.pause!
    
    # Output state info
    @controller.debug
    
    # Toggle auto playing
    if (not @controller.get_board.game_over?) && @auto_move_timer.is_running
      @auto_move_timer.stop
    else
      @auto_move_timer.start((AUTOPLAY_INTERVAL*1000).to_i)
    end
  end
  
  # Method run when about button is pressed
  def do_about_button
    about_str = <<-ABOUT
    Ruby Tanbo:
    Copyright (C) 2009  Travis Briggs
                    <briggs.travis (at) gmail.com>
                    
    An implementation of the Mark Steere game Tanbo, using Ruby
    and wxRuby for the GUI.

    For more information on Tanbo, and the rules see:
        <http://www.marksteeregames.com/>
    
    Thanks to Pierre Gueth and Joel Schaerer for their C++ UCT
    implementation:
        <http://github.com/joelthelion/uct>

    And of course, thanks to Mark Steere for the game and his explicit
    permission for anyone to code it!
    
    This program comes with ABSOLUTELY NO WARRANTY;
    This is free software, and you are welcome to redistribute
    it under certain conditions. See the COPYING file for more information
    
    ABOUT
    
    about_dialog = Dialog.new(self, :title => "About Ruby Tanbo", 
                                    :pos => [110, 35],  
                                    :size => [400, 350],
                                    :style => DEFAULT_DIALOG_STYLE
    )
    
    about_sizer = Wx::BoxSizer.new(VERTICAL)
    about_text = StaticText.new(about_dialog, :label => about_str, :size => [400, 350], :style=>ALIGN_LEFT)
    about_text.set_font(ABOUT_FONT)
    about_sizer.add_spacer(10)
    about_sizer.add(about_text, 8, ALIGN_CENTER, 10)

    if btn_sizer = about_dialog.create_button_sizer(OK) #Intentional assignment
      about_sizer.add_spacer(5)
      about_sizer.add(btn_sizer, 1, ALIGN_RIGHT, 20)
    end
    
    about_dialog.set_sizer(about_sizer)
    about_dialog.show_modal
  end

  # Show an AISelectDialog, and set the selected AI on the controller. Then
  # start the controller. This method actually just attaches an observer
  # to the controller and actually displays the dialog and starts the
  # controller after it recieves a BOARD_READY_EVENT (to allow the controller
  # time to reset the board or load a saved state)
  def register_ai_select_action()
    @waiting_to_select_ai = true
  end

  # Method run when new button is pressed  
  def do_new_button
    begin
      @controller.pause!
      if(@controller.modified)
        # Return control, doing nothing, if the user says no to aborting the
        # current game
        return unless dirty_check          
      end
    
      register_ai_select_action
      @controller.reset!
    ensure
      @controller.unpause!
    end
  end
  
  # Method run when save button is pressed
  def do_save_button
    begin
      @controller.pause!
    
      picker = FileDialog.new(self, :style => FD_SAVE | FD_OVERWRITE_PROMPT)
      picker.set_filename("Tanbo_#{Time.new.strftime('%Y.%m.%d-%H.%M')}.tan")
      return unless ID_OK == picker.show_modal
      
      begin
        save_file = File.new(picker.get_path, 'w')
        save_file.puts(@controller.output_board)
        @controller.modified = false
      rescue SystemCallError, IOError=>e
        MessageDialog.new(self, "The file you specified could not be created. Your game was not saved! Check file system permissions and try again.", 
                          "Problem saving file", 
                          OK | ICON_EXCLAMATION).show_modal
      rescue Exception=>e
        MessageDialog.new(self, "An unkown error occurred. The file may not have been saved.", 
                          OK | ICON_EXCLAMATION).show_modal
      ensure
        save_file.close if save_file
      end
    ensure
      @controller.unpause!
    end
  end
  
  # Method run when load button is pressed
  def do_load_button
    begin
      @controller.pause!
      if(@controller.modified)
        # Return control, doing nothing, if the user says no to aborting the
        # current game
        return unless dirty_check          
      end
      
      register_ai_select_action
      
      picker = FileDialog.new(self, :style => FD_OPEN | FD_FILE_MUST_EXIST)
      return unless ID_OK == picker.show_modal
    
      begin
        load_file = File.new(picker.get_path, 'r')
        @controller.parse_board(load_file.read)
        @board.do_paint
      rescue SystemCallError, IOError=>e
        MessageDialog.new(self, "The file you specified could not be opened", 
                          :style => OK | ICON_EXCLAMATION ).show_modal
        return
      ensure
        load_file.close if load_file
      end
    ensure
      @controller.unpause!
    end
  end
  
end