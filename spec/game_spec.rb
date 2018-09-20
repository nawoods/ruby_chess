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
  
  describe "#move" do
    subject { Game.new }
    
    context "when king is in check" do
      before(:each) do
        subject.move('b1', 'c3')
        subject.move('h7', 'h6')
        subject.move('c3', 'e4')
        subject.move('h6', 'h5')
        subject.move('e4', 'd6')
      end
      
      it "does not allow irrelevant pieces to move" do
        expect(subject.move('h5', 'h4')).to be(false)
      end
    end
    
    context "when promoting" do
      before(:each) do
        subject.move('d2', 'd3')
        subject.move('h7', 'h6')
        subject.move('c1', 'h6')
        subject.move('a7', 'a6')
        subject.move('h6', 'e3')
        subject.move('a6', 'a5')
        subject.move('h2', 'h4')
        subject.move('h8', 'h6')
        subject.move('h4', 'h5')
        subject.move('h6', 'a6')
        subject.move('h5', 'h6')
        subject.move('a5', 'a4')
        subject.move('h6', 'h7')
        subject.move('a4', 'a3')
        subject.move('h7', 'h8')
      end
      
      it "does not change the current player" do
        expect(subject.current_player).to eq(:white)
      end
      
      it "does not allow current player to make another move" do
        expect(subject.move('g2', 'g3')).to eq(false)
      end
    end
    
    context "when king is in check (but not checkmate)" do
      before(:each) do
        subject.move('f2', 'f3')
        subject.move('e7', 'e5')
        subject.move('e2', 'e4')
        subject.move('d8', 'h4')
      end
      
      it "does not allow irrelevant moves" do
        expect(subject.move('a2', 'a3')).to eq(false)
      end
      
      it "allows the king to move itself out of check" do
        expect(subject.move('e1', 'e2')).to eq(true)
      end
      
      it "does not allow the king to move itself into check" do
        expect(subject.move('e1', 'f2')).to eq(false)
      end
      
      it "allows another piece to move in the way" do
        expect(subject.move('g2', 'g3')).to eq(true)
      end
      
      it "does not allow pinned piece to move" do
        g = Game.new
        g.move('e2', 'e4')
        g.move('e7', 'e5')
        g.move('d2', 'd4')
        g.move('d7', 'd5')
        g.move('e4', 'd5')
        g.move('e5', 'd4')
        g.move('f1', 'b5')
        g.move('d8', 'd7')
        g.move('d1', 'e2')
        
        expect(g.move('d7', 'e7')).to eq(false)
      end
    end
  end
  
  describe "#promote" do
    subject { Game.new }
    
    context "when no piece to promote" do
      it "does nothing" do
        expect(subject.promote(Queen)).to eq(false)
      end
    end
    
    context "when there is a piece to promote" do
      before(:each) do
        subject.move('d2', 'd3')
        subject.move('h7', 'h6')
        subject.move('c1', 'h6')
        subject.move('a7', 'a6')
        subject.move('h6', 'e3')
        subject.move('a6', 'a5')
        subject.move('h2', 'h4')
        subject.move('h8', 'h6')
        subject.move('h4', 'h5')
        subject.move('h6', 'a6')
        subject.move('h5', 'h6')
        subject.move('a5', 'a4')
        subject.move('h6', 'h7')
        subject.move('a4', 'a3')
        subject.move('h7', 'h8')
      end
      
      it "returns true" do
        expect(subject.promote(Queen)).to eq(true)
      end
        
      it "replaces pawn with indicated piece" do
        subject.promote(Queen)
        expect(subject.board.piece_at_sq('h8')).to be_instance_of(Queen)
      end
      
      it "allows opponent to move afterward" do
        subject.promote(Queen)
        expect(subject.move('a3', 'b2')).to eq(true)
      end
    end
  end
end