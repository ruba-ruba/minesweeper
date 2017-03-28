require 'spec_helper'

RSpec.describe Minesweeper::Board do
  let(:board) { Minesweeper::Board.new(height: 2, width: 3, level: :expert, window: nil) }

  context "#fill_board" do
    subject(:fill_board) { board }

    it 'return Board instance' do
      expect(fill_board).to be_a Minesweeper::Board
    end

    it 'create 2 rows each with 3 cells' do
      expect(fill_board.board.count).to eq 2
      expect(fill_board.board.flatten(1).count).to eq 2*3
    end

    it 'fill all elements with Minesweeper::Cell' do
      expect(fill_board.board.flatten(1).all?{|cell| cell.is_a?(Minesweeper::Cell)}).to be_truthy
    end
  end
end
