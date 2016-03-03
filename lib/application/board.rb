module Minesweeper
  class Board
    attr_reader :height, :width, :level, :board

    def initialize(height: 9, width: 9, level: :beginner)
      @height = height
      @width  = width
      @level  = level
      @board  = []
    end

    def fill_board
      (0..height).each do
        board << Array.new(width) { Cell.new }
      end
      self
    end

    def draw
      # board
    end

    protected

    def number_of_cells
      height * width
    end
  end
end