module Minesweeper
  class BoardParams
    DEFAULTS = [10, 10, 'advanced'].freeze

    attr_reader :window

    def initialize(window)
      @window = window
    end

    def board_params
      window.addstr('Start game with default parameters? (Y/N)')
      window.setpos(4,42)
      str = window.getstr
      if str.casecmp('y').zero?
        DEFAULTS
      else
        [ask_y, ask_x, ask_level]
      end
    end

    private

    def ask_x
      window.addstr('Number of columns: ')
      x = window.getstr
      x = window.maxx-1 if x.to_i > window.maxx
      x
    end

    def ask_y
      window.addstr('Number of rows: ')
      y = window.getstr
      y = window.maxy-1 if y.to_i > window.maxy
      y
    end

    def ask_level
      window.addstr('Your Level (beginner/advanced/expert): ')
      window.getstr
    end
  end
end
