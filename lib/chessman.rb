class Chessman
  attr_accessor :player
  
  def initialize(player)
    @player = player
  end
  
  def to_s
    "?"
  end
  
  protected
  
  def chars_between(char1, char2)
    char1, char2 = char2, char1 if char1 > char2
    (char1..char2).to_a[1..-2]
  end
end