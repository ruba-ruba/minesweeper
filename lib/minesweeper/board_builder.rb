# frozen_string_literal: true

module Minesweeper
  # create empty instance of board
  # fill it with cells & bomb cells
  # return assembled instance of board
  class BoardBuilder
    extend Forwardable

    def initialize(flush_params)
      @flush_params = flush_params
    end

    def build
      @board_params = params_builder.prepare
      @board = create_board
      fill_with_cells
      inject_bombs
      board
    end

    private

    attr_reader :window, :flush_params, :board_params, :board

    def_delegators :board_params, :height, :width, :level

    def create_board
      Minesweeper::Board.new(board_params)
    end

    def fill_with_cells
      height.times do
        board.cells << Array.new(width) { Cell.new }
      end
    end

    def inject_bombs
      bomb_injector.inject(board, level)
    end

    def bomb_injector
      @bomb_injector ||= BombInjector.new
    end

    def params_builder
      Minesweeper::ParamsBuilder.new(flush_params)
    end
  end
end
