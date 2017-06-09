require 'simplecov'
require 'sequel'
require 'pry'

require 'coveralls'
Coveralls.wear!

require_relative '../lib/minesweeper/cell'
require_relative '../lib/minesweeper/board'
require_relative '../lib/minesweeper/board_builder'
require_relative '../lib/minesweeper/board_params'
require_relative '../lib/minesweeper/bomb_cell'
require_relative '../lib/minesweeper/bomb_injector'

RSpec.configure do |config|
  if ENV['COVERAGE'] == 'true'
    SimpleCov.start
  end
end
