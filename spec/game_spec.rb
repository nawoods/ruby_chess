require_relative '../lib/game.rb'

describe Game do
  describe "#castle_move" do
    subject { Game.new }
    
    context "when castling king-side" do
      context "when pieces have been moved out of the way" do
        before(:each) do
          subject.move('e2', 'e4')
          subject.move('e8', 'e6')
          subject.move('f1', 'd3')
          subject.move('f8', 'd6')
          subject.move('g1', 'f3')
          subject.move('g8', 'f6')
        end
      
        it "returns true" do
          expect(subject.move('e1', 'g1')).to eq(true);
        end
      
        it "moves pieces correctly" do
          subject.move('e1', 'g1')
          subject.move('e8', 'g8')
        
          expect(subject.board.piece_at_sq('g1')).to be_instance_of(King)
          expect(subject.board.piece_at_sq('g8')).to be_instance_of(King)
          expect(subject.board.piece_at_sq('f1')).to be_instance_of(Rook)
          expect(subject.board.piece_at_sq('f8')).to be_instance_of(Rook)
        end
      end
    end
  end
end