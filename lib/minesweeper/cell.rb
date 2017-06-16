module Minesweeper
  class Cell < BaseCell
    def bomb?
      false
    end

    def open!(number_of_boms_nearby)
      state.view = number_of_boms_nearby.to_s
      state.color = COLOR_CYAN
      state.status = :opened
    end
  end
end
