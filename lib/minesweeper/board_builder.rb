module Minesweeper
  class BoardBuilder
    extend Forwardable

    def initialize(window, flush_params:)
      @window = window
      @params_builder = Minesweeper::BoardParams.new(window, flush_params)
      @bomb_injector = BombInjector.new(level: level)
    end

    def build
      board = Minesweeper::Board.new(height: height, width: width, window: window)
      fill_with_cells(board)
      inject_bombs(board)
      board
    end

    private

    attr_reader :window, :bomb_injector, :params_builder

    def_delegators :params_builder, :height, :width, :level

    def fill_with_cells(board)
      height.times do
        board.cells << Array.new(width) { Cell.new }
      end
    end

    def inject_bombs(board)
      bomb_injector.inject(board)
    end
  end
end
