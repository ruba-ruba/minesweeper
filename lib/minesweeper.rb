require 'curses'
include Curses

require 'pry'
require 'forwardable'

require_relative 'application/board'
require_relative 'application/board_builder'
require_relative 'application/bomb_cell'
require_relative 'application/bomb_injector'
require_relative 'application/cell'
require_relative 'application/command_reader'

module Minesweeper
  class Application
    def initialize
      CommandReader.new.create_new_game
    end
  end
end

Minesweeper::Application.new
