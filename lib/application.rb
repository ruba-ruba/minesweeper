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
        window.addstr("Initializing New Game \n")
        window.addstr("Enter game parameters. hint: (press enter to start default game) \n \n")
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

        mine_board = Minesweeper::MineBoard.new(height: y, width: x, level: level, window: window)
        mine_board.play

      ensure
        close_screen
      end
    end
  end

end

Minesweeper::Application.new
