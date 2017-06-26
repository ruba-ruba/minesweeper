require 'spec_helper'

RSpec.describe Minesweeper::BombInjector do
  let(:height) { 10 }
  let(:width)  { 10 }
  let(:board_params) do
    Minesweeper::BoardParams.new(height: height, width: width, level: 'expert')
  end

  let(:board) do
    board = Minesweeper::Board.new(
      board_params: board_params,
      window: nil
    )
    height.times do
      board.cells << Array.new(width) { Minesweeper::Cell.new }
    end
    board
  end

  let(:bomb_injector) do
    described_class.new
  end

  context 'level' do
    it 'spread bombs around board' do
      bomb_injector.inject(board, :expert)
      expect(board.bombs.count).to eq 25
    end

    it 'spread bombs around board' do
      bomb_injector.inject(board, :advanced)
      expect(board.bombs.count).to eq 15
    end

    it 'spread bombs around board' do
      bomb_injector.inject(board, :beginner)
      expect(board.bombs.count).to eq 5
    end
  end

  describe 'number of bombs' do
    let(:height) { 1 }
    let(:width)  { 1 }

    it 'return at least 1 bomb' do
      bomb_injector.inject(board, :expert)
      expect(board.bombs.count).to eq 1
    end
  end
end
