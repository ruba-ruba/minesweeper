module Minesweeper
  class MineBoard < Board
    def fill_board
      super
      add_bombs
      self
    end

    private

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
      number = (bomb_percent * number_of_cells).to_i
      number.zero? ? 1 : number
    end

    def add_bombs(number = number_of_bombs)
      if number > 0
        cell = board[random_row][random_cell]
        cell.make_it_bomb && number -= 1
        add_bombs(number)
      end
    end

    def random_row
      Random.rand(height)
    end

    def random_cell
      Random.rand(width)
    end
  end
end