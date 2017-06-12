require 'spec_helper'

RSpec.describe Minesweeper::BoardParams do
  describe '#validate' do
    context 'when params valid' do
      let(:params) { { height: 20, width: 20, level: 'expert' } }

      it 'has no errors' do
        expect(described_class.new(params)).to be_valid
      end
    end

    context 'when params are invalid' do
      let(:params) { { height: 'x', width: 'y', level: 'whatever' } }

      it 'not valid' do
        expect(described_class.new(params)).not_to be_valid
      end
    end
  end
end
