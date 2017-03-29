module Minesweeper
  class Cell
    attr_accessor :status, :pointer

    def initialize(status: :initial)
      @status = status
      @pointer = nil
    end

    def bomb?
      false
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
      return if opened?
      self.status = marked_as_bomb? ? :initial : :marked_as_bomb
    end

    # remove zero stub
    def open!(number_of_boms_nearby = 0)
      return if opened?
      self.pointer =
        if marked_as_bomb?
          '*'
        else
          number_of_boms_nearby
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
        COLOR_CYAN
      end
    end
  end
end
