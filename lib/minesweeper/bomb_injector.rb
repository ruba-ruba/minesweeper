# frozen_string_literal: true

module Minesweeper
  class BombInjector
    def inject(board, level)
      @board = board
      @level = level
      add_bombs
    end

    private

    attr_reader :board, :level

    def add_bombs(number = number_of_bombs)
      return if number.zero?
      row_index = random_row
      cell_index = random_cell
      cell = board.cells[row_index][cell_index]
      unless cell.bomb?
        board.cells[row_index][cell_index] = Cells::Bomb.new
        number -= 1
      end
      add_bombs(number)
    end

    def number_of_bombs
      (bomb_percent * board.number_of_cells).ceil
    end

    def bomb_percent
      case level.to_sym
      when :beginner then 0.05
      when :advanced then 0.15
      when :expert   then 0.25
      end
    end

    def random_row
      Random.rand(board.height)
    end

    def random_cell
      Random.rand(board.width)
    end
  end
end
