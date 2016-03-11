require 'pry'
require 'curses'
include  Curses

require_relative 'application/board'
require_relative 'application/mine_board'
require_relative 'application/cell'

module Minesweeper
  class Application
    def initialize
      CommandReader.new.create_game
    end
  end

  class CommandReader
    def initialize
      @commands = ARGV.first
    end

    # def create_game
    #   puts "New session has been started."
    #   puts "_____________________________"
    #   puts "Please provide number of rows, cols and choose your level: beginner / advanced / expert"
    #   puts "by hitting enter defaule game is started as 9x9 and beginner level"
    #   ARGF.each do |line|
    #     if line.strip.empty?
    #       board = Minesweeper::MineBoard.new
    #     end
    #     if line.strip.split.any?
    #       args = line.strip.split
    #       height = args[0]
    #       width  = args[1]
    #       level  = args[2]
    #       board = Minesweeper::MineBoard.new(height: height, width: width, level: level)
    #     end
    #     if line.strip.match(/exit|end/)
    #       puts 'good bye!'
    #       break
    #     end
    #     board.fill_board.draw
    #     board.play
    #   end
    # end

    def create_game
      window = Window.new(0,0,0,0)
      # start
      begin
        init_screen
        # start_color
        cbreak
        window.keypad = true
        # window.color_set(COLOR_RED)

        # window.addstr 'Check for up arrow or letter k.'
        window.refresh
        window.addch ?\n
        window.addstr("Add X: ")
        x = window.getstr
        window.addstr("Add Y: ")
        y = window.getstr

        mine_board = Minesweeper::MineBoard.new(height: y, width: x, level: :beginner, window: window)
        mine_board.play

        # draw_board(window)
        # while true
        #   x = window.curx
        #   y = window.cury
        #   ch =  window.getch
        #   case ch
        #   when KEY_UP
        #     window.addstr "up arrow \n"
        #   when KEY_DOWN
        #     window.addstr "down arrow \n"
        #   when KEY_LEFT
        #     # debug
        #     window.setpos(20,0)
        #     window.addstr "\n #{y} #{x} \n"
        #     # debug
        #     if x <= 2
        #       window.setpos(y-1,28)
        #       next
        #     end
        #     if x >= 30
        #       window.setpos(y,x-2)
        #     else
        #       window.setpos(y,x-3)
        #     end
        #   when ch.to_s
        #     # debug
        #     window.setpos(20,0)
        #     window.addstr "\n #{y} #{x} \n"
        #     # debug
        #     if x >= 27
        #       window.setpos(y+1,1)
        #     else
        #       window.setpos(y,x+3)
        #     end
        #   when 10
        #     window.setpos(18,0)
        #     window.addstr "open_cell"
        #   else
        #     window.addstr "%s\n" % ch
        #   end
        #   window.refresh
        # end

      ensure
        close_screen
      end
    end

    def draw_board(window, y = 9, x = 9)
      (0..9).each do |row|
        (0..(x*3)).each_slice(3) do |cell|
          window.setpos(row, cell[0])
          window.addstr "[ ]"
        end
      end
      window.refresh
    end

  end


end

Minesweeper::Application.new


