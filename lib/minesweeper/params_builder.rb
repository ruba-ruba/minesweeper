module Minesweeper
  class ParamsBuilder
    extend Forwardable
    DEFAULTS = { height: 10, width: 10, level: 'advanced' }.freeze

    attr_reader :window, :flush_params

    def initialize(window, flush_params)
      @window = window
      @flush_params = flush_params
    end

    def_delegators :entry, :height, :width, :level

    def prepare
      entry && entry.delete if flush_params
      entry || build
    end

    private

    def entry
      ::Minesweeper::BoardParams.first
    end

    def build(pos = 4)
      window.addstr('Start game with default parameters? (Y/N)')
      window.setpos(pos, 42)
      str = window.getstr
      instance =
        if str.casecmp('y').zero?
          ::Minesweeper::BoardParams.new(DEFAULTS)
        else
          ::Minesweeper::BoardParams.new(height: ask_y, width: ask_x, level: ask_level)
        end
      validate(instance)
    end

    def validate(instance)
      if instance.valid?
        instance.save
        instance
      else
        window.clear
        window.addstr("Some of the parameters were invalid \n")
        window.addstr(instance.errors.full_messages.join("\n"))
        window.addstr("\n")
        build(instance.errors.count + 1)
      end
    end

    def ask_x
      window.addstr('Number of columns: ')
      x = window.getstr
      x = window.maxx - 1 if x.to_i > window.maxx
      x
    end

    def ask_y
      window.addstr('Number of rows: ')
      y = window.getstr
      y = window.maxy - 1 if y.to_i > window.maxy
      y
    end

    def ask_level
      window.addstr('Your Level (beginner/advanced/expert): ')
      window.getstr
    end
  end
end
