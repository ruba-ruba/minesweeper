require 'spec_helper'

RSpec.describe Minesweeper::Board do
  let(:board) do
    Minesweeper::Board.new(height: 2, width: 3, bomb_injector: Minesweeper::BombInjector.new(level: :expert), window: nil)
  end

  context '#fill_board' do
    it 'create 2 rows each with 3 cells' do
      board.fill_with_cells
      expect(board.board.count).to eq 2
      expect(board.board.flatten(1).count).to eq 2*3
    end
  end
end
