module Minesweeper
  class BombCell < BaseCell
    def bomb?
      true
    end

    def open!(*)
      state.view = '*'
      state.color = state.marked_as_bomb? ? COLOR_WHITE : COLOR_RED
      state.status = :opened
    end
  end
end
