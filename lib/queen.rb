require_relative './chessman'
require_relative './rook'
require_relative './bishop'

class Queen < Chessman
  def to_s
    @player == :white ? "Q" : "q"
  end
  
  def valid_move?(old_sq, new_sq, capture = false)
    Rook.new(player).valid_move?(old_sq, new_sq) ||
        Bishop.new(player).valid_move?(old_sq, new_sq)
  end
     
  def intermediate_spaces(old_sq, new_sq)
    if Rook.new(player).valid_move?(old_sq, new_sq)
      Rook.new(player).intermediate_spaces(old_sq, new_sq)
    else
      Bishop.new(player).intermediate_spaces(old_sq, new_sq)
    end
  end
end