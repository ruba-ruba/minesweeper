# frozen_string_literal: true

module Minesweeper
  module Cells
    class Bomb < Base
      def bomb?
        true
      end

      def open!(*)
        state.view = '*'
        state.color = marked_as_bomb? ? COLOR_WHITE : COLOR_RED
        state.status = :opened
      end
    end
  end
end
