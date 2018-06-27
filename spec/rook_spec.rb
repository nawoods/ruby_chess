# require_relative "../lib/rook.rb"
# 
# describe Rook do
#   describe "#move" do
#     subject { Rook.new([4,4], :white) }
#     
#     context "when move is valid" do
#       it "moves horizontally" do
#         subject.move([4,7])
#         expect(subject.position).to eq([4,7])
#       end
#       
#       it "moves vertically" do
#         subject.move([2,4])
#         expect(subject.position).to eq([2,4])
#       end
#     end
#     
#     context "when move is not valid" do
#       it "does not move" do
#         subject.move([3,8])
#         expect(subject.position).to eq([4,4])
#       end
#     end
#   end
# end