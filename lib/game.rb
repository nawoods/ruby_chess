require_relative './board'

class Game
  attr_reader :current_player
  
  def initialize
    @board = Board.new
    @current_player = :white
    
    # if pawn moves 2 spaces, keep track of column for next turn
    @en_passant = nil 
  end
  
  def to_s
    @board.to_s
  end
  
  def move(old_sq, new_sq)
    return false if !@board.move(old_sq, new_sq, @current_player, @en_passant)
    @en_passant = (two_rank_pawn_move?(old_sq, new_sq) ? old_sq[0] : nil)
    @current_player = (@current_player == :white ? :black : :white)
    true
  end
  
  private
  
  def two_rank_pawn_move?(old_sq, new_sq)
    start_row = (@current_player == :white ? "2" : "7")
    end_row = (@current_player == :white ? "4" : "5")
    @board.piece_at_sq(new_sq).is_a?(Pawn) && old_sq[1] == start_row &&
        new_sq[1] == end_row
  end
end