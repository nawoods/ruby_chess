require_relative './board'

class Game
  attr_reader :current_player
  
  def initialize
    @board = Board.new
    @current_player = :white
    initialize_castle_variables
    
    # if pawn moves 2 spaces, keep track of column for next turn
    @en_passant = nil 
  end
  
  def to_s
    @board.to_s
  end
  
  def move(old_sq, new_sq)
    return false if !@board.move(old_sq, new_sq, @current_player, @en_passant)
    @en_passant = (two_rank_pawn_move?(old_sq, new_sq) ? old_sq[0] : nil)
    update_castle_variables(old_sq, new_sq)
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
  
  def initialize_castle_variables
    @white_k_castle = true
    @white_q_castle = true
    @black_k_castle = true
    @black_q_castle = true
  end
  
  def update_castle_variables(old_sq, new_sq)
    if @board.piece_at_sq(new_sq).is_a? King
      if @current_player == :white
        @white_k_castle = false
        @white_q_castle = false
      else
        @black_k_castle = false
        @black_q_castle = false
      end
    end
    
    if @board.piece_at_sq(new_sq).is_a? Rook
      @white_k_castle = false if old_sq == 'h1'
      @white_q_castle = false if old_sq == 'a1'
      @black_k_castle = false if old_sq == 'h8'
      @black_q_castle = false if old_sq == 'a8'
    end
  end
  
end