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
  
  def valid_move?(old_sq, new_sq)
    old_sq[0] == new_sq[0] || old_sq[1] == new_sq[1]
  end
  
  def intermediate_spaces(old_sq, new_sq)
    result = []
    if old_sq[0] == new_sq[0]
      chars_between(old_sq[1], new_sq[1]).each { |i| result << old_sq[0] + i }
    elsif old_sq[1] == new_sq[1]
      chars_between(old_sq[0], new_sq[0]).each { |i| result << i + old_sq[1] }
    end
    result
  end
  
  private
      
  def chars_between(char1, char2)
    char1, char2 = char2, char1 if char1 > char2
    (char1..char2).to_a[1..-2]
  end
end