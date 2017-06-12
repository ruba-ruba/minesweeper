module Minesweeper
  class BoardBuilder
    extend Forwardable

    def initialize(window, flush_params:)
      @window = window
      @flush_params = flush_params
    end

    def build
      params_builder.prepare
      board = create_board
      fill_with_cells(board)
      inject_bombs(board)
      board
    end

    private

    attr_reader :window, :flush_params

    def_delegators :params_builder, :height, :width, :level

    def create_board
      Minesweeper::Board.new(height: height, width: width, window: window)
    end

    def fill_with_cells(board)
      height.times do
        board.cells << Array.new(width) { Cell.new }
      end
    end

    def inject_bombs(board)
      bomb_injector.inject(board, level)
    end

    def bomb_injector
      @bomb_injector ||= BombInjector.new
    end

    def params_builder
      @params_builder ||= Minesweeper::ParamsBuilder.new(window, flush_params)
    end
  end
end
