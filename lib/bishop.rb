require_relative './chessman'

class Bishop < Chessman
  def to_s
    @player == :white ? "B" : "b"
  end
  
  def valid_move?(old_sq, new_sq, capture = false)
    horiz_dist(old_sq, new_sq).abs == vert_dist(old_sq, new_sq).abs
  end
  
  def intermediate_spaces(old_sq, new_sq)
    vert = vert_dist(old_sq, new_sq)
    vert_coeff = vert / vert.abs
    horiz_coeff = horiz_dist(old_sq, new_sq) / horiz_dist(old_sq, new_sq).abs
    result = [old_sq]
    (vert.abs - 1).times { result << diag(result[-1], horiz_coeff, vert_coeff) }
    result[1..-1]
  end
end