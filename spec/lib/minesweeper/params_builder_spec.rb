require 'spec_helper'
require 'pry'

RSpec.describe Minesweeper::ParamsBuilder do
  let(:flush_params) { true }
  let(:terminal_ui) { double(:terminal_ui).as_null_object }

  subject { described_class.new(flush_params) }

  before do
    allow(subject).to receive(:ui) { terminal_ui }
  end

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
        allow(terminal_ui).to receive(:getstr) { 'N' }
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

  # one should not test private methods!!!
  describe '#validate_and_save' do
    let(:board_params) do
      ::Minesweeper::BoardParams.new(height: 'y', width: 'x', level: 'z')
    end

    it 'add errors to board_params & build' do
      expect_any_instance_of(described_class).to receive(:build).once
      subject.send(:validate_and_save, board_params)
      expect(board_params.errors[:height]).not_to be_nil
      expect(board_params.errors[:width]).not_to be_nil
      expect(board_params.errors[:level]).not_to be_nil
    end
  end
end
