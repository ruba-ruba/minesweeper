require 'curses'
include Curses

require 'pry'
require 'forwardable'

require_relative 'minesweeper/board'
require_relative 'minesweeper/board_builder'
require_relative 'minesweeper/bomb_cell'
require_relative 'minesweeper/bomb_injector'
require_relative 'minesweeper/cell'
require_relative 'minesweeper/command_reader'

module Minesweeper
  class Application
    def initialize
      CommandReader.new.create_new_game
    end
  end
end

Minesweeper::Application.new
