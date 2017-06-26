require 'spec_helper'

RSpec.describe Minesweeper::BoardBuilder do
  let(:window) { double(:window).as_null_object }
  let(:flush_params) { false }

  let(:board_builder) { described_class.new(window, flush_params: flush_params) }

  describe 'build' do
    it 'return instance of board' do
      expect(board_builder.build).to be_a Minesweeper::Board
    end

    it 'inject bombs onto board' do
      board = board_builder.build
      bomb_cells = board.cells.flatten(1).select(&:bomb?)
      expect(bomb_cells).not_to be_empty
    end
  end
end
