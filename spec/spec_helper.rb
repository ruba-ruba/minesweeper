require 'simplecov'
require 'sequel'
require 'pry'

require 'coveralls'
Coveralls.wear!

require_relative '../lib/minesweeper'

RSpec.configure do |config|
  if ENV['COVERAGE'] == 'true'
    SimpleCov.start
  end
end
