require 'spec_helper'

RSpec.describe Minesweeper::Storage do
  let(:db) { Minesweeper::Storage::DB[:board_params] }

  describe 'read' do
    context 'with no data' do
      it 'returns nil' do
        expect(described_class.instance.read).to be_nil
      end
    end

    context 'with data' do
      before do
        db.insert(height: 10, width: 10, level: 'level')
      end

      it 'return data' do
        expect(described_class.instance.read).to eq({ height: 10, width: 10, level: 'level' })
      end

      it 'access specific column' do
        expect(described_class.instance[:level]).to eq 'level'
      end
    end
  end
end
