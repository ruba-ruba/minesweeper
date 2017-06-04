module Minesweeper
  class BoardParams

    # how about more sophisticated solution
    DB = Sequel.sqlite
    DB.execute <<-SQL
      CREATE TABLE IF NOT EXISTS board_params (
        height integer,
        width integer,
        level varchar(255)
      );
    SQL

    DEFAULTS = { height: 10, width: 10, level: 'advanced' }.freeze

    attr_reader :window, :flush_params

    def initialize(window, flush_params)
      @window = window
      @flush_params = flush_params
      prepare
    end

    def height
      read[:height]
    end

    def width
      read[:width]
    end

    def level
      read[:level]
    end

    def prepare
      flush_storage if flush_params
      read || build
    end

    private

    def table
      DB[:board_params]
    end

    def read
      table.first
    end

    def flush_storage
      DB[:board_params].delete
    end

    def build
      window.addstr('Start game with default parameters? (Y/N)')
      window.setpos(4, 42)
      str = window.getstr
      if str.casecmp('y').zero?
        table.insert(DEFAULTS)
      else
        table.insert(height: ask_y, width: ask_x, level: ask_level)
      end
      read
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
