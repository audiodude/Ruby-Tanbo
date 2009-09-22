require 'main_controller.rb'
require 'monitor.rb'

class BoardCLI
  include MonitorMixin
  
  attr_reader :move_queue, :input_ready_cond
  
  def initialize(controller)
    @controller = controller
    @move_queue = []
    @move_queue.extend(MonitorMixin)
    @input_ready_cond = @move_queue.new_cond
    @painting_mutex = Mutex.new
  end
  
  def do_paint
    if @painting_mutex.try_lock
      puts @controller.output_board
      @painting_mutex.unlock
    end
  end
  
  def update(event)
    case event
      when TanboBoard::BOARD_UPDATE_EVENT        
        do_paint
        Thread.pass
    end
  end
  
  def input_loop
    while true
      line = STDIN.gets
      line =~ /(\d+).*?(\d+)/
      x, y = $1.to_i, $2.to_i
      
      @move_queue.synchronize do
        break unless @controller.valid_move?(@controller.get_board[x, y])
        @move_queue << [x, y] 
        @input_ready_cond.signal
      end
    
      # Let whoever is interested process the new data
      Thread.pass
    end
  end
  
end