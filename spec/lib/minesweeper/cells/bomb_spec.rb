require 'spec_helper'

RSpec.describe Minesweeper::Cells::Bomb do
  let(:cell) { described_class.new }

  describe '#open' do
    it 'set cell view' do
      expect { cell.open! }.to change { cell.view }.from(' ').to('*')
    end

    it 'set cell color' do
      expect { cell.open! }.to change { cell.color }.from(COLOR_MAGENTA).to(COLOR_RED)
    end

    it 'set cell status' do
      expect { cell.open! }.to change { cell.state.status }.from(:initial).to(:opened)
    end
  end
end
