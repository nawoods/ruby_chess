require_relative './chessman'

class Pawn < Chessman
  def to_s
    @player == :white ? "P" : "p"
  end
  
  def valid_move?(old_sq, new_sq, capture = false)
    vert = vert_dist(old_sq, new_sq) * (@player == :white ? 1 : -1)
    horiz = horiz_dist(old_sq, new_sq)
    if capture
      vert == 1 && horiz.abs == 1
    else
      old_sq[0] == new_sq[0] &&
          (vert == 1 || (['2','7'].include?(old_sq[1]) && vert == 2))
    end
  end
  
  def intermediate_spaces(old_sq, new_sq)
    []
  end
end