require_relative './chessman'

class Pawn < Chessman
  def to_s
    @player == :white ? "\u2659" : "\u265f"
  end
  
  def valid_move?(old_sq, new_sq, capture = false)
    if capture
      vert_dist(old_sq, new_sq) == 1 && horiz_dist(old_sq, new_sq).abs == 1
    else
      old_sq[1] == new_sq[1] && (vert_dist(old_sq, new_sq) == 1 ||
          (old_sq[0] == 'b' && vert_dist(old_sq, new_sq) == 2))
    end
  end
  
  def intermediate_spaces(old_sq, new_sq)
    []
  end
  
  private
  
  def vert_dist(old_sq, new_sq)
    dist = new_sq[0].ord - old_sq[0].ord
    @player == :white ? dist : dist * -1
  end
  
  def horiz_dist(old_sq, new_sq)
    new_sq[1].to_i - old_sq[1].to_i
  end
end