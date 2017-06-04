require 'spec_helper'

RSpec.describe Minesweeper::BombInjector do
  let(:height) { 10 }
  let(:width)  { 10 }
  let(:board) do
    Minesweeper::Board.new(
      height: height,
      width: width,
      bomb_injector: nil,
      window: nil
    )
  end

  before { board.fill_with_cells }

  let(:bomb_injector) do
    described_class.new(level: :expert)
  end

  it 'spread bombs around board' do
    bomb_injector.inject(board)
    expect(board.bombs.count).to eq 25
  end

  describe 'number of bombs' do
    let(:height) { 1 }
    let(:width)  { 1 }

    it 'return at least 1 bomb' do
      bomb_injector.inject(board)
      expect(board.bombs.count).to eq 1
    end
  end
end
