# frozen_string_literal: true

require 'curses'
include Curses

require 'forwardable'
require 'sequel'
require_relative 'minesweeper/exceptions'
require_relative 'minesweeper/ui'
require_relative 'minesweeper/board_params'
require_relative 'minesweeper/board'
require_relative 'minesweeper/board_builder'
require_relative 'minesweeper/params_builder'
require_relative 'minesweeper/cells/base'
require_relative 'minesweeper/cells/cell'
require_relative 'minesweeper/cells/bomb'
require_relative 'minesweeper/bomb_injector'
require_relative 'minesweeper/game_initializer'
require_relative 'minesweeper/cells/state'

module Minesweeper
end
