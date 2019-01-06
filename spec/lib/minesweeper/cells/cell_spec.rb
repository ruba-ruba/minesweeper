require 'spec_helper'

RSpec.describe Minesweeper::Cells::Cell do
  let(:cell) { described_class.new }

  describe '#open' do
    it 'set cell view' do
      expect { cell.open!(4) }.to change { cell.view }.from(' ').to('4')
    end

    it 'set cell color' do
      expect { cell.open!(4) }.to change { cell.color }.from(COLOR_MAGENTA).to(COLOR_CYAN)
    end

    it 'set cell status' do
      expect { cell.open!(4) }.to change { cell.state.status }.from(:initial).to(:opened)
    end
  end
end
