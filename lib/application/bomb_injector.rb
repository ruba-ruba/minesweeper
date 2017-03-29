module Minesweeper
  class BombInjector
    attr_reader :board, :level

    def initialize(level:)
      @level = level
    end

    def inject(board)
      @board = board
      add_bombs
    end

    private

    def add_bombs(number = number_of_bombs)
      if number > 0
        cell = board.board[random_row][random_cell]
        cell.make_it_bomb! && number -= 1
        add_bombs(number)
      end
    end

    def number_of_bombs
      bomb_percent =
        case level.to_sym
        when :beginner
          0.05
        when :advanced
          0.15
        when :expert
          0.25
        else
          raise NotImplementedError, 'unknown level'
        end
      (bomb_percent * board.number_of_cells).ceil
    end

    def random_row
      Random.rand(board.height)
    end

    def random_cell
      Random.rand(board.width)
    end
  end
end
