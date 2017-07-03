# frozen_string_literal: true

require 'singleton'
require 'forwardable'

module Minesweeper
  class Ui
    include ::Singleton
    extend Forwardable

    def self.method_missing(method_name, *arguments, &block)
      if instance.respond_to?(method_name)
        instance.send(method_name, *arguments, &block)
      else
        super
      end
    end

    def self.respond_to_missing?(method_name, include_private = false)
      instance.respond_to?(:method_name) || super
    end

    def_delegators :window,
                   :clear,
                   :addch,
                   :addstr,
                   :refresh,
                   :maxy,
                   :maxx,
                   :getstr,
                   :setpos,
                   :attron,
                   :getch,
                   :curx,
                   :cury

    def greeting_message
      clear
      enable_keypad
      refresh
      addch("\n")
      addstr("Welcome to Minesweeper \n")
      addstr("screen size: rows: #{window.maxy}; columns: #{window.maxx / Minesweeper::Board::STEP} \n")
      addstr("controls: `space` to mark/unmark cell as bomb, `arrow keys` to navigate \n")
    end

    def params_message
      addstr('Start game with default parameters? (Y/N)')
    end

    def col_num
      addstr('Number of columns: ')
    end

    def row_num
      addstr('Number of rows: ')
    end

    def level
      addstr('Your Level (beginner/advanced/expert): ')
    end

    def validation_errors(errors)
      clear
      addstr("Some of the parameters were invalid \n")
      addstr(errors.full_messages.join("\n"))
      addstr("\n")
    end

    def window
      @window ||= Window.new(0, 0, 0, 0)
    end

    private

    def enable_keypad
      window.keypad = true
    end
  end
end
