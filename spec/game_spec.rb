require_relative '../lib/game.rb'

describe Game do
  describe "#castle_move" do
    subject { Game.new }
    
    context "when castling king-side" do
      context "when pieces have been moved out of the way" do
        before(:each) do
          subject.move('e2', 'e4')
          subject.move('e7', 'e5')
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
      
      context "when pieces haven't been moved out of the way" do
        it "does not allow king to move" do
          subject.move('e1', 'g1')
          expect(subject.board.piece_at_sq('g1')).to be_instance_of(Knight)
        end
        
        it "returns false" do
          expect(subject.move('e1', 'g1')).to eq(false)
        end
      end
      
      context "when king would move through space under attack" do
        before(:each) do
          subject.move('d2', 'd3')
          subject.move('e7', 'e5')
          subject.move('c1', 'e3')
          subject.move('f8', 'c5')
          subject.move('e3', 'c5')
          subject.move('g8', 'f6')
          subject.move('a2', 'a3')
        end
          
        it "does not allow king to move" do
          subject.move('e8', 'g8')
          expect(subject.board.piece_at_sq('e8')).to be_instance_of(King)
        end
        
        it "returns false" do
          expect(subject.move('e8', 'g8')).to eq(false)
        end
      end
    end
    
    context "when castling queen-side" do
      context "when pieces have been moved out of the way" do
        before(:each) do
          subject.move('d2', 'd4')
          subject.move('d7', 'd5')
          subject.move('c1', 'f4')
          subject.move('c8', 'f5')
          subject.move('d1', 'd3')
          subject.move('d8', 'd6')
          subject.move('b1', 'c3')
          subject.move('b8', 'c6')
        end
        
        it "returns true" do
          expect(subject.move('e1', 'c1')).to eq(true)
        end
        
        it "moves pieces correctly" do
          subject.move('e1', 'c1')
          subject.move('e8', 'c8')
          
          expect(subject.board.piece_at_sq('c1')).to be_instance_of(King)
          expect(subject.board.piece_at_sq('c8')).to be_instance_of(King)
          expect(subject.board.piece_at_sq('d1')).to be_instance_of(Rook)
          expect(subject.board.piece_at_sq('d8')).to be_instance_of(Rook)
        end
      end
    end
  end
end