require_relative './board'

class Game
  attr_reader :current_player, :board
  attr_reader :board
  
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
    if valid_castle?(old_sq, new_sq)
      return false unless castle_move(old_sq, new_sq)
    else
      return false unless non_castle_move(old_sq, new_sq)
    end
    @current_player = (@current_player == :white ? :black : :white)
    true
  end
  
  private
  
  def castle_move(old_sq, new_sq)
    return false unless @board.castle(old_sq, new_sq, @current_player)
    update_castle_variables(old_sq, new_sq)
    @en_passant = nil
    true
  end
  
  def non_castle_move(old_sq, new_sq)
    return false unless @board.move(old_sq, new_sq, @current_player, @en_passant)
    update_castle_variables(old_sq, new_sq)
    @en_passant = (two_rank_pawn_move?(old_sq, new_sq) ? old_sq[0] : nil)
    true
  end
  
  def valid_castle?(old_sq, new_sq)
    @board.piece_at_sq(old_sq).is_a?(King) && old_sq[1] == new_sq[1] &&
        ((@current_player == :white &&
            (@white_k_castle && new_sq[0] == 'g') ||
            (@white_q_castle && new_sq[0] == 'c')) ||
        (@current_player == :black &&
            (@black_k_castle && new_sq[0] == 'g') ||
            (@black_q_castle && new_sq[0] == 'c')))
  end
  
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
    if @board.piece_at_sq(new_sq).is_a?(King)
      if @current_player == :white
        @white_k_castle = false
        @white_q_castle = false
      else
        @black_k_castle = false
        @black_q_castle = false
      end
    end
    
    @white_k_castle = false unless @board.piece_at_sq('h1').is_a?(Rook) &&
        @board.piece_at_sq('h1').player == :white
    @white_q_castle = false unless @board.piece_at_sq('a1').is_a?(Rook) &&
        @board.piece_at_sq('a1').player == :white
    @black_k_castle = false unless @board.piece_at_sq('h8').is_a?(Rook) &&
        @board.piece_at_sq('h8').player == :black
    @black_q_castle = false unless @board.piece_at_sq('a8').is_a?(Rook) &&
        @board.piece_at_sq('a8').player == :black
  end
  
end