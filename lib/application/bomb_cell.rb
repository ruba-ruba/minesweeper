module Minesweeper
  class BombCell
    attr_accessor :status, :pointer

    def initialize(status: :initial)
      @status = status
      @pointer = nil
    end

    def bomb?
      true
    end

    def draw(window)
      case status
      when :initial
        window.addstr(' ')
      when :marked_as_bomb
        window.attron(color_pair(color)) { window.addstr '*' }
      when :opened
        window.attron(color_pair(color)) { window.addstr pointer.to_s }
      else
        raise NotImplementedError
      end
    end

    def toggle_bomb_flag!
      self.status = marked_as_bomb? ? :initial : :marked_as_bomb
    end

    def open!(_)
      return if opened?
      self.pointer =
        if marked_as_bomb?
          '+'
        else
          '*'
        end
      self.status = :opened
    end

    %i(initial marked_as_bomb opened).each do |method|
      define_method("#{method}?") do
        status == method
      end
    end

    private

    def color
      case status
      when :marked_as_bomb
        COLOR_MAGENTA
      when :opened
        COLOR_RED
      end
    end
  end
end