require 'pry'
require 'curses'
include  Curses

require_relative 'application/board'
require_relative 'application/mine_board'
require_relative 'application/cell'

module Minesweeper
  require 'forwardable'

  class Application
    def initialize
      CommandReader.new.create_game
    end
  end

  class CommandReader
    def initialize
      @commands = ARGV.first
    end

    def create_game
      window = Window.new(0,0,0,0)

      begin
        init_screen
        start_color
        cbreak
        window.keypad = true

        window.refresh
        window.addch ?\n
        window.addstr("Initializing New Game \nEnter game parameters.")
        window.addstr("Hint: press enter to start default game \n")
        window.addstr("Screen Size: max row number is: #{window.maxy}; max col number is: #{window.maxx}  \n")
        window.addstr("Keyboard: use 'b' to mark cell as bomb \n")
        window.addstr("Number of rows: ")
        y = window.getstr
        if y.empty?
          x = 10
          y = 10
          level = :advanced
        else
          window.addstr("Number of columns: ")
          x = window.getstr
          window.addstr("Your Level (beginner/advanced/expert): ")
          level = window.getstr
        end

        y = window.maxy-1 if y.to_i > window.maxy
        x = window.maxx-1 if x.to_i > window.maxx

        mine_board = Minesweeper::MineBoard.new(height: y, width: x, level: level, window: window)
        mine_board.play

      ensure
        close_screen
      end
    end
  end

end

Minesweeper::Application.new
