require_relative './board'

class Game
  attr_reader :current_player
  
  def initialize
    @board = Board.new
    @current_player = :white
  end
  
  def to_s
    @board.to_s
  end
  
  def move(old_sq, new_sq)
    if @board.move(@current_player, old_sq, new_sq)
      @current_player = (@current_player == :white ? :black : :white)
      return true
    end
    false
  end
end