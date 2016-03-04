require 'pry'
require 'matrix'

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

    def create_game
      puts "New session has been started."
      puts "_____________________________"
      puts "Please provide number of rows, cols and choose your level: beginner / advanced / expert"
      puts "by hitting enter defaule game is started as 9x9 and beginner level"
      ARGF.each do |line|
        if line.strip.empty?
          board = Minesweeper::MineBoard.new
        end
        if line.strip.split.any?
          args = line.strip.split
          height = args[0]
          width  = args[1]
          level  = args[2]
          board = Minesweeper::MineBoard.new(height: height, width: width, level: level)
        end
        if line.strip.match(/exit|end/)
          puts 'good bye!'
          break
        end
        board.fill_board.draw
        board.play
      end
    end
  end

end

Minesweeper::Application.new