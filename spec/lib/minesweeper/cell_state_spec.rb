require 'spec_helper'

RSpec.describe Minesweeper::CellState do
  let(:cell_state) { described_class.new(color: nil, status: nil, view: nil) }

  context 'opened?' do
    it 'is falsey' do
      expect(cell_state.opened?).to be_falsey
    end

    it 'is truthy' do
      cell_state.status = :opened
      expect(cell_state.opened?).to be_truthy
    end
  end

  context 'marked_as_bomb?' do
    it 'is falsey' do
      expect(cell_state.marked_as_bomb?).to be_falsey
    end

    it 'is truthy' do
      cell_state.status = :marked_as_bomb
      expect(cell_state.marked_as_bomb?).to be_truthy
    end
  end
end
