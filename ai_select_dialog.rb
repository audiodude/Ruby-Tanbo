class AISelectDialog < Dialog
  HUMAN = -10
  AI_RANDBO = -20
  AI_ULYSSES = -30
  
  def initialize(parent)
    super(parent,  :title => "New Game - Choose Your AI", 
               :pos => [110, 35],  
               :size => [400, 160],
               :style => DEFAULT_DIALOG_STYLE | STAY_ON_TOP
    )

    self.set_min_size([400, 160])
    @sizer = Wx::BoxSizer.new(VERTICAL)

    @choices_sizer = Wx::BoxSizer.new(HORIZONTAL)
    
    @names = ["Human", "Randbo (Random AI)", "Ulysses (UCT algorithm)"]

    @box_p1_choices = RadioBox.new(self, :label => "Player 1 (Black)", :size => [180, 100],
                                    :choices => @names, 
                                    :major_dimension => 3, 
                                    :style => RA_SPECIFY_ROWS,
                                    :name => "p1_box")
                                
    @box_p2_choices = RadioBox.new(self, :label => "Player 2 (White)", :size => [180, 100],
                                     :choices => @names, 
                                     :major_dimension => 3, 
                                     :style => RA_SPECIFY_ROWS,
                                     :name => "p2_box")
    
    @choices_sizer.add(@box_p1_choices, 7, ALIGN_LEFT, 0)
    @choices_sizer.add_stretch_spacer(1)
    @choices_sizer.add(@box_p2_choices, 7, ALIGN_RIGHT, 0)

    @sizer.add_spacer(5)

    @sizer.add(@choices_sizer, 2, ALIGN_CENTER, 5)

    if btn_sizer = create_button_sizer(OK | CANCEL) #Intentional assignment
      @sizer.add_spacer(5)
      @sizer.add(btn_sizer, 1, ALIGN_RIGHT, 20)
    end
    set_sizer(@sizer)
  end
  
  def player1_choice
    return get_choice(@box_p1_choices)
  end
  
  def player2_choice
    return get_choice(@box_p2_choices)
  end
  
  private
  def get_choice(box)
    case box.get_selection
      when 0
        return HUMAN
      when 1
        return AI_RANDBO
      when 2
        return AI_ULYSSES
    end
  end

end