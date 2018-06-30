require_relative './chessman'

class King < Chessman
  def to_s
    @player == :white ? "K" : "k"
  end
  
  def valid_move?(old_sq, new_sq, capture = false)
    vert = vert_dist(old_sq, new_sq).abs 
    horiz = horiz_dist(old_sq, new_sq).abs
    [vert, horiz].max == 1
  end
  
  def intermediate_spaces(old_sq, new_sq)
    []
  end
end