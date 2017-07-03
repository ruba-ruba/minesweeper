# frozen_string_literal: true

module Minesweeper
  class GameInitializer
    def start
      init_curses
      Ui.greeting_message
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
        .new(flush_params)
        .build
        .play
    end

    def init_curses
      init_screen
      init_colors
      cbreak
    end

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
