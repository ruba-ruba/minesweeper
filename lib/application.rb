module Minesweeper
  class Application
  end

  class Reader
    def initialize
      @commands = ARGV.first
    end

    def read_commands
      puts "New game started"
        ARGF.each do |line|
        next  if line.strip.empty?
        break if line.strip.match(/exit|end/)
        run_commands(line)
      end
    end
  end
end