# frozen_string_literal: true

module Minesweeper
  class GameOver < StandardError
    def message
      'You Lost'
    end
  end

  class GameWon < StandardError
    def message
      'You Won'
    end
  end
end
