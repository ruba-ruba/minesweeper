module Minesweeper
  class BoardParams
    DEFAULTS = { height: 10, width: 10, level: 'advanced' }.freeze

    attr_reader :window, :flush_params

    def initialize(window, flush_params)
      @window = window
      @flush_params = flush_params
      prepare
    end

    def height
      storage.read[:height]
    end

    def width
      storage.read[:width]
    end

    def level
      storage.read[:level]
    end

    private

    def prepare
      storage.flush if flush_params
      storage.read || build
    end

    def storage
      ::Minesweeper::Storage.instance
    end

    def build
      window.addstr('Start game with default parameters? (Y/N)')
      window.setpos(4, 42)
      str = window.getstr
      if str.casecmp('y').zero?
        storage.insert(DEFAULTS)
      else
        storage.insert(height: ask_y, width: ask_x, level: ask_level)
      end
      storage.read
    end

    def ask_x
      window.addstr('Number of columns: ')
      x = window.getstr
      x = window.maxx - 1 if x.to_i > window.maxx
      x
    end

    def ask_y
      window.addstr('Number of rows: ')
      y = window.getstr
      y = window.maxy - 1 if y.to_i > window.maxy
      y
    end

    def ask_level
      window.addstr('Your Level (beginner/advanced/expert): ')
      window.getstr
    end
  end
end
