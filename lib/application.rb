require 'pry'

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
      puts "Please provide number of cols, rows and your level beginner / advanced / expert"
      puts "by hitting enter defaule game is started as 9x9 and beginner level"
      ARGF.each do |line|
        if line.strip.empty?
          Minesweeper::MineBoard.new.fill_board.draw
        end
        if line.strip.split.any?
          # create custom game
        end
        if line.strip.match(/exit|end/)
          puts 'good bye!'
          break
        end
        capture_coordinates
      end
    end
  end

  def capture_coordinates
  end
end

Minesweeper::Application.new