class Chessman
  attr_accessor :player
  
  def initialize(player)
    @player = player
  end
  
  def to_s
    "?"
  end
  
  def intermediate_spaces(old_sq, new_sq)
    []
  end
  
  protected
  
  def chars_between(char1, char2)
    char1, char2 = char2, char1 if char1 > char2
    (char1..char2).to_a[1..-2]
  end
  
  def vert_dist(old_sq, new_sq)
    new_sq[1].to_i - old_sq[1].to_i
  end
  
  def horiz_dist(old_sq, new_sq)
    new_sq[0].ord - old_sq[0].ord
  end
  
  def diag(old_sq, horiz_coeff, vert_coeff)
    letter = (old_sq[0].ord + horiz_coeff).chr
    number = (old_sq[1].to_i + vert_coeff).to_s
    letter + number
  end
end