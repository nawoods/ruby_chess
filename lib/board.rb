require_relative './rook'
require_relative './pawn'

class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    place_chessmen
  end
  
  def to_s
    result = ''
    ("a".."g").to_a.reverse.each do |letter|
      result += letter
      (1..8).to_a.each do |number|
        piece = piece_at_sq(letter + number.to_s)
        if piece.nil?
          result += " "
        else
          result += piece.to_s
        end
      end
      result += "\n"
    end
    result += " 12345678"
  end
  
  def move(old_sq, new_sq)
    piece = piece_at_sq(old_sq)
    return false unless valid_move?(piece, old_sq, new_sq)
    assign_piece(piece, new_sq)
    assign_piece(nil, old_sq)
  end
  
  # private
  
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
    assign_piece(Rook.new(:white), "a1")
    assign_piece(Rook.new(:white), "a8")
    8.times { |i| assign_piece(Pawn.new(:white), "b#{i+1}") }
    assign_piece(Rook.new(:black), "g1")
    assign_piece(Rook.new(:black), "g8")
    8.times { |i| assign_piece(Pawn.new(:black), "f#{i+1}") }
  end
end