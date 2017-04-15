module Minesweeper
  class CommandReader
    def initialize
      @window  = Window.new(0, 0, 0, 0)
    end

    private

    attr_reader :window

    def ask_x
      window.addstr("Number of columns: ")
      x = window.getstr
      x = window.maxx-1 if x.to_i > window.maxx
      x
    end

    def ask_y
      window.addstr("Number of rows: ")
      y = window.getstr
      y = window.maxy-1 if y.to_i > window.maxy
      y
    end

    def ask_level
      window.addstr("Your Level (beginner/advanced/expert): ")
      window.getstr
    end

    def ask_for_board_options
      [ask_y, ask_x, ask_level]
    end

    def board_options
      window.addstr("Start game with default parameters? (Y/N)  \n")
      window.setpos(4,42)
      str = window.getstr
      if str.casecmp('y').zero?
        [10, 10, 'advanced']
      else
        ask_for_board_options
      end
    end

    def init_colors
      Curses.start_color
      Curses.init_pair(COLOR_RED,     COLOR_RED,     COLOR_BLACK)
      Curses.init_pair(COLOR_BLUE,    COLOR_BLUE,    COLOR_BLACK)
      Curses.init_pair(COLOR_CYAN,    COLOR_CYAN,    COLOR_BLACK)
      Curses.init_pair(COLOR_WHITE,   COLOR_WHITE,   COLOR_BLACK)
      Curses.init_pair(COLOR_MAGENTA, COLOR_MAGENTA, COLOR_BLACK)
    end

    public

    def create_new_game
      init_screen
      init_colors

      cbreak
      window.keypad = true

      window.refresh

      window.addch ?\n
      window.addstr("Initializing New Game \n")
      window.addstr("Recomended screen size: rows: #{window.maxy}; columns: #{window.maxx} \n")
      window.addstr("hint: use `b` to mark/unmark cell as bomb \n")
      y, x, level = board_options
      board = Minesweeper::BoardBuilder.new(height: y, width: x, level: level, window: window).build
      board.play
    ensure
      close_screen
      at_exit { puts 'good bye' }
    end
  end
end
