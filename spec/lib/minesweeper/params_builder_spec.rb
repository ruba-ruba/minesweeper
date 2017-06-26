require 'spec_helper'

RSpec.describe Minesweeper::ParamsBuilder do
  let(:flush_params) { true }
  let(:window) { double(:fake_window).as_null_object }

  subject { described_class.new(window, flush_params) }

  describe '#prepare' do
    context 'with default params' do
      it 'return board params instance' do
        expect(subject.prepare).to be_a Minesweeper::BoardParams
      end

      it 'set default params' do
        board_params = subject.prepare
        %i[height width level].each do |param|
          expect(board_params.send(param)).to eq described_class::DEFAULTS.fetch(param)
        end
      end
    end

    context 'with custom params' do
      before do
        allow(window).to receive(:getstr) { 'N' }
        allow_any_instance_of(described_class).to receive(:ask_y) { 20 }
        allow_any_instance_of(described_class).to receive(:ask_x) { 20 }
        allow_any_instance_of(described_class).to receive(:ask_level) { 'expert' }
      end

      it 'use user provided for params' do
        board_params = subject.prepare
        expect(board_params.height).to eq 20
        expect(board_params.width).to eq 20
        expect(board_params.level).to eq 'expert'
      end
    end
  end
end
