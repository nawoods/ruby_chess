require_relative './chessman'

class Knight < Chessman
  def to_s
    @player == :white ? "N" : "n"
  end
  
  def valid_move?(old_sq, new_sq, capture = false)
    vert = vert_dist(old_sq, new_sq).abs 
    horiz = horiz_dist(old_sq, new_sq).abs
    (vert == 2 && horiz == 1) || (vert == 1 && horiz == 2)
  end
end