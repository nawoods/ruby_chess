require_relative './rook'
require_relative './pawn'
require_relative './bishop'
require_relative './knight'
require_relative './queen'
require_relative './king'

class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    place_chessmen
  end
  
  def to_s
    result = ''
    (1..8).to_a.reverse.each do |number|
      result += number.to_s
      ('a'..'h').to_a.each do |letter|
        piece = piece_at_sq(letter + number.to_s)
        if piece.nil?
          result += " "
        else
          result += piece.to_s
        end
      end
      result += "\n"
    end
    result + " abcdefgh"
  end
  
  def piece_at_sq(sq)
    @grid[sq[0].ord - 97][sq[1].to_i]
  end
  
  def move(old_sq, new_sq, player, en_passant)
    return false unless valid_move?(old_sq, new_sq, player, en_passant)
    reassign_pieces(old_sq, new_sq, player, en_passant)
    true
  end
  
  private
  
  def reassign_pieces(old_sq, new_sq, player, en_passant)
    if valid_en_passant_capture?(old_sq, new_sq, player, en_passant)
      assign_piece(nil, en_passant_victim(new_sq))
    end
    assign_piece(piece_at_sq(old_sq), new_sq)
    assign_piece(nil, old_sq)
  end
  
  def valid_move?(old_sq, new_sq, player, en_passant)
    valid_normal_move?(old_sq, new_sq, player) ||
        valid_en_passant_capture?(old_sq, new_sq, player, en_passant)
  end
  
  def valid_normal_move?(old_sq, new_sq, player)
    piece = piece_at_sq(old_sq)
    capture = !piece_at_sq(new_sq).nil?
    !piece.nil? && piece.valid_move?(old_sq, new_sq, capture) &&
        player == piece.player && !capture_own_piece(old_sq, new_sq, capture) && 
        clear_path(old_sq, new_sq, piece)
  end
  
  def valid_en_passant_capture?(old_sq, new_sq, player, en_passant)
    piece = piece_at_sq(old_sq)
    piece.is_a?(Pawn) && piece_at_sq(new_sq).nil? &&
        piece.valid_move?(old_sq, new_sq, true) && en_passant == new_sq[0] &&
        piece.player != piece_at_sq(en_passant_victim(new_sq)).player
  end
  
  def en_passant_victim(new_sq)
    new_sq[0] + (new_sq[1] == "3" ? "4" : "5")
  end
  
  def capture_own_piece(old_sq, new_sq, capture)
    capture && piece_at_sq(old_sq).player == piece_at_sq(new_sq).player
  end
  
  def clear_path(old_sq, new_sq, piece)
    piece.intermediate_spaces(old_sq, new_sq)
        .map { |i| piece_at_sq(i).nil? }.reduce(true, &:&)
  end
  
  def assign_piece(piece, sq)
    @grid[sq[0].ord - 97][sq[1].to_i] = piece
  end
  
  def place_chessmen
    back_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    8.times { |i| assign_piece(back_row[i].new(:black), "#{(i+97).chr}8") }
    8.times { |i| assign_piece(Pawn.new(:black), "#{(i+97).chr}7") }
    8.times { |i| assign_piece(Pawn.new(:white), "#{(i+97).chr}2") }
    8.times { |i| assign_piece(back_row[i].new(:white), "#{(i+97).chr}1") }
  end
end