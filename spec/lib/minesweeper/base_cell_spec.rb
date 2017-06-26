require 'spec_helper'

RSpec.describe Minesweeper::BaseCell do
  let(:cell) { described_class.new }

  describe '#toggle_bomb_flag!' do
    it 'does nothing if cell is opened' do
      allow(cell).to receive(:opened?) { true }
      expect { cell.toggle_bomb_flag! }.not_to change { cell.view }
    end

    context 'when marked as bomb' do
      before do
        cell.toggle_bomb_flag!
      end

      it 'change view to default' do
        expect { cell.toggle_bomb_flag! }.to change { cell.view }.from('*').to(' ')
      end

      it 'keeps color' do
        expect { cell.toggle_bomb_flag! }.not_to change { cell.color }
      end

      it 'change state' do
        expect { cell.toggle_bomb_flag! }.to change { cell.state.status }.from(:marked_as_bomb).to(:initial)
      end
    end

    context 'when initial' do
      it 'change view to default' do
        expect { cell.toggle_bomb_flag! }.to change { cell.view }.from(' ').to('*')
      end

      it 'keeps color' do
        expect { cell.toggle_bomb_flag! }.not_to change { cell.color }
      end

      it 'change state' do
        expect { cell.toggle_bomb_flag! }.to change { cell.state.status }.from(:initial).to(:marked_as_bomb)
      end
    end
  end

  describe 'bomb?' do
    it 'raise' do
      expect { cell.bomb? }.to raise_error NotImplementedError
    end
  end

  describe '#open' do
    it 'raise' do
      expect { cell.open! }.to raise_error NotImplementedError
    end
  end
end
