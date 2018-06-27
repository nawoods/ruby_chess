require_relative './rook'

class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    
    assign_piece(Rook.new(:white), "a1")
    assign_piece(Rook.new(:white), "a8")
    assign_piece(Rook.new(:black), "g1")
    assign_piece(Rook.new(:black), "g8")
  end
  
  def to_s
    result = ''
    ("a".."g").to_a.reverse.each do |letter|
      result += letter
      (1..8).to_a.each do |number|
        piece = piece_at_square(letter + number.to_s)
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
  
  def move(old_position, new_position)
    piece = piece_at_square(old_position)
    return false if piece.nil? || !piece.valid_move?(old_position, new_position)
    assign_piece(piece, new_position)
    assign_piece(nil, old_position)
  end
  
  # private
  
  def piece_at_square(position)
    @grid[position[0].ord - 97][position[1].to_i]
  end
  
  def assign_piece(piece, position)
    @grid[position[0].ord - 97][position[1].to_i] = piece
  end
end