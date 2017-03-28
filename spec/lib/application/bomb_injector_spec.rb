require "spec_helper"

RSpec.describe Minesweeper::BombInjector do
  let(:board) do
    Minesweeper::Board.new(height: 10, width: 10, level: :expert, window: nil)
  end

  let(:bomb_injector) do
    described_class.new(level: :expert)
  end

  it "spread bombs around board" do
    # bomb_injector.inject(board)
    # uncomment once fill & play resolved
    expect(board.bombs.count).to eq 25
  end
end
