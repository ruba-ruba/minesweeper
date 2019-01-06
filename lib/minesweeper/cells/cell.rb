# frozen_string_literal: true

module Minesweeper
  module Cells
    class Cell < Base
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
end
