module Minesweeper
  class GameInitializer
    def initialize
      @window = Window.new(0, 0, 0, 0)
    end    

    def start
      init_screen
      init_colors

      cbreak
      window.keypad = true

      window.refresh

      window.addch ?\n
      window.addstr("Initializing New Game \n")
      window.addstr("Recomended screen size: rows: #{window.maxy}; columns: #{window.maxx} \n")
      window.addstr("hint: use `space` to mark/unmark cell as bomb \n")
      y, x, level = Minesweeper::BoardParams.new(window).board_params
      board = Minesweeper::BoardBuilder.new(height: y, width: x, level: level, window: window).build
      board.play
    ensure
      close_screen
      at_exit { puts 'good bye' }
    end

    private

    attr_reader :window

    def init_colors
      Curses.start_color
      Curses.init_pair(COLOR_RED,     COLOR_RED,     COLOR_BLACK)
      Curses.init_pair(COLOR_BLUE,    COLOR_BLUE,    COLOR_BLACK)
      Curses.init_pair(COLOR_CYAN,    COLOR_CYAN,    COLOR_BLACK)
      Curses.init_pair(COLOR_WHITE,   COLOR_WHITE,   COLOR_BLACK)
      Curses.init_pair(COLOR_MAGENTA, COLOR_MAGENTA, COLOR_BLACK)
    end
  end
end
