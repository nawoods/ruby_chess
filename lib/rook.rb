class Rook
  attr_accessor :player
  
  def initialize(player)
    @player = player
  end
  
  def to_s
    if @player == :white
      "\u2656"
    else
      "\u265c"
    end
  end
  
  def valid_move?(old_position, new_position)
    old_position[0] == new_position[0] || old_position[1] == new_position[1]
  end
end