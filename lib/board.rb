require_relative './rook'
require_relative './pawn'
require_relative './bishop'
require_relative './knight'
require_relative './queen'
require_relative './king'

class Board
  attr_reader :pinned
  
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @pinned = []
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
  
  def castle(old_sq, new_sq, player)
    row = (player == :white ? '1' : '8')
    return false unless new_sq[0] == 'g' ? 
        king_side_castle(row, player) : queen_side_castle(row, player)
    reassign_pieces(old_sq, new_sq, player, nil)
    true
  end
  
  def promote(sq, piece, player)
    assign_piece(piece.new(player), sq)
  end
  
  private
  
  def king_side_castle(row, player)
    return false unless ['e', 'f', 'g']
        .map { |i| pieces_attacking_sq(i+row, opponent(player)) }
        .flatten.length == 0
    return false unless ['f', 'g'].map { |i| piece_at_sq(i+row).nil? }
        .reduce(:&)
    reassign_pieces('h' + row, 'f' + row, player, nil)
    true
  end
  
  def queen_side_castle(row, player)
    return false unless ['c', 'd', 'e']
        .map { |i| pieces_attacking_sq(i+row, opponent(player)) }
        .flatten.length == 0
    return false unless ['b', 'c', 'd'].map { |i| piece_at_sq(i+row).nil? }
        .reduce(:&)
    reassign_pieces('a' + row, 'd' + row, player, nil)
    true
  end
  
  def threatening_sq(sq, player)
    result = []
    ('a'..'h').each do |i|
      (1..8).each do |j|
        old_sq = i.to_s + j.to_s
        piece = piece_at_sq(old_sq)
        next if piece.nil? or piece.player != player
        next unless piece.valid_move?(old_sq, sq, true)
        next unless piece.intermediate_spaces(old_sq, sq)
            .map { |k| piece_at_sq(k).nil? }.reduce(true, :&)
        result << piece
      end
    end
    result
  end
  
  def reassign_pieces(old_sq, new_sq, player, en_passant)
    if valid_en_passant_capture?(old_sq, new_sq, player, en_passant)
      assign_piece(nil, en_passant_victim(new_sq))
    end
    assign_piece(piece_at_sq(old_sq), new_sq)
    assign_piece(nil, old_sq)
  end
  
  def valid_move?(old_sq, new_sq, player, en_passant)
    if pieces_attacking_sq(king_sq(player), opponent(player)).length > 0
      valid_move_out_of_check?(old_sq, new_sq, player)
    else
      valid_normal_move?(old_sq, new_sq, player) ||
          valid_en_passant_capture?(old_sq, new_sq, player, en_passant)
    end
  end
  
  def valid_move_out_of_check?(old_sq, new_sq, player)
    update_pinned(player)
    pieces_attacking_king = pieces_attacking_sq(king_sq(player), opponent(player)) 
    if piece_at_sq(old_sq).is_a?(King)
      pieces_attacking_sq(new_sq, opponent(player)).length == 0
    else
      return false unless pieces_attacking_king.length == 1 && 
          valid_normal_move?(old_sq, new_sq, player) && !@pinned.include?(old_sq)
      attacker = pieces_attacking_king[0]
      mid = piece_at_sq(attacker).intermediate_spaces(attacker, king_sq(player))
      (mid + [attacker]).include?(new_sq)
    end
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
  
  def all_squares
    ('a'..'h').map { |i| ('1'..'8').map { |j| i + j } }.flatten
  end
  
  def opponent(player)
    player == :white ? :black : :white
  end
  
  def players_pieces(player)
    all_squares.select do |i|
      !piece_at_sq(i).nil? && piece_at_sq(i).player == player
    end
  end
  
  def pieces_attacking_sq(sq, player)
    players_pieces(player).select { |i| valid_normal_move?(i, sq, player) }
  end
  
  def update_pinned(player)
    @pinned = []
    players_pieces(opponent(player)).each do |i|
      king = king_sq(player)
      next unless piece_at_sq(i).valid_move?(i, king)
      mid = piece_at_sq(i).intermediate_spaces(i, king)
          .reject { |j| piece_at_sq(j).nil? }
      if mid.length == 1 && piece_at_sq(mid[0]).player == player
        @pinned << mid[0]
      end
    end
  end
  
  def king_sq(player)
    players_pieces(player).select { |i| piece_at_sq(i).is_a?(King) }.first
  end
end