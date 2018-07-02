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
  
  def move(player, old_sq, new_sq)
    piece = piece_at_sq(old_sq)
    return false unless player == piece.player
    return false unless valid_move?(piece, old_sq, new_sq)
    assign_piece(piece, new_sq)
    assign_piece(nil, old_sq)
    true
  end
  
  private
  
  def valid_move?(piece, old_sq, new_sq)
    capture = !piece_at_sq(new_sq).nil?
    return false if piece.nil? || !piece.valid_move?(old_sq, new_sq, capture)
    return false if capture && 
        piece_at_sq(old_sq).player == piece_at_sq(new_sq).player
    return false unless piece.intermediate_spaces(old_sq, new_sq)
        .map { |i| piece_at_sq(i).nil? }.reduce(true, &:&)
    true
  end
  
  def piece_at_sq(sq)
    @grid[sq[0].ord - 97][sq[1].to_i]
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