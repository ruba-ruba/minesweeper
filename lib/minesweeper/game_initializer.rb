# frozen_string_literal: true

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
      window.addch("\n")
      window.addstr("Welcome to Minesweeper \n")
      window.addstr("screen size: rows: #{window.maxy}; columns: #{window.maxx / Minesweeper::Board::STEP} \n")
      window.addstr("controls: `space` to mark/unmark cell as bomb, `arrow keys` to navigate \n")
      play
    rescue SystemExit, Interrupt
    ensure
      close_screen
      at_exit { puts 'good bye' }
    end

    def restart
      play(false)
    end

    private

    def play(flush_params = true)
      Minesweeper::BoardBuilder
        .new(window, flush_params: flush_params)
        .build
        .play
    end

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
