# frozen_string_literal: true

if ENV['TRAVIS'] == 'true'
  require 'coveralls'
  Coveralls.wear!
end
