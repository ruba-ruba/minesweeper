module Minesweeper
  class BoardBuilder
    # replay
    def self.from_board(board)
      new(
        height: board.height,
        width:  board.width,
        level:  board.bomb_injector.level,
        window: Window.new(0, 0, 0, 0)
      )
    end

    def initialize(height:, width:, level:, window:)
      @height = height.to_i
      @width  = width.to_i
      @level  = level
      @window = window
    end

    def build
      bomb_injector = BombInjector.new(level: level)
      board = Minesweeper::Board.new(height: height, width: width, bomb_injector: bomb_injector, window: window)
      board.fill_with_cells
      board.inject_bombs
      board
    end

    private

    attr_reader :height, :width, :level, :window
  end
end
