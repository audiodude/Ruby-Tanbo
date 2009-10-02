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

class AISelectDialog < Dialog
  HUMAN = -10
  AI_RANDBO = -20
  AI_ULYSSES = -30
  
  def initialize(parent)
    super(parent,  :title => "New Game - Choose Your AI", 
               :pos => [110, 35],  
               :size => [400, 190],
               :style => DEFAULT_DIALOG_STYLE | STAY_ON_TOP
    )

    self.set_min_size([400, 190])
    @sizer = Wx::BoxSizer.new(VERTICAL)

    @choices_sizer = Wx::BoxSizer.new(HORIZONTAL)
    
    @names = ["Human", "Randolph (Random AI)", "Ulysses (UCT algorithm)"]

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