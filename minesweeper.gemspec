# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minesweeper/version'

Gem::Specification.new do |spec|
  spec.name          = 'minesweeper'
  spec.version       = Minesweeper::VERSION
  spec.authors       = ['Mykhailo Rybak']
  spec.email         = ['mykhailo.rybak.if@gmail.com']

  spec.summary       = %q{Minesweeper CLI game using curses}
  spec.description   = %q{Minesweeper CLI game using curses}
  spec.homepage      = "https://github.com/ruba-ruba/minesweeper"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = ['minesweeper']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',  '~> 1.14'
  spec.add_development_dependency 'rake',     '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'curses',   '~> 1.0.2'
  spec.add_development_dependency 'sequel'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'rspec',    '~> 3.6.0'
end
