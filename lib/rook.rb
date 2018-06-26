class Rook
  attr_accessor :position, :player
  
  def initialize(position, player)
    @position = position
    @player = player
  end
  
  def valid_move?(new_position)
    position.first == new_position.first || position.last == new_position.last
  end
  
  def move(new_position)
    return false unless valid_move?(new_position)
    @position = new_position
  end
end