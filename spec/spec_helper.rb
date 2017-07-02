require 'sequel'
require 'pry'
require 'support/coverage'
require 'support/coveralls'

require_relative '../lib/minesweeper'

RSpec.configure do |config|
  config.before(:each) do
    window = double(:window).as_null_object
    allow_any_instance_of(Minesweeper::Ui).to receive(:window) { window }
    allow(Minesweeper::Ui).to receive(:window) { window }
    close_screen
  end
end
