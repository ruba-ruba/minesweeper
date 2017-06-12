if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    add_group 'lib', 'lib'
  end
end