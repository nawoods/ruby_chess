require_relative './chessman'

class Rook < Chessman
  def to_s
    @player == :white ? "R" : "r"
  end
  
  def valid_move?(old_sq, new_sq, capture = false)
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
end