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

    def draw
      case status
      when :initial
        ' '
      when :marked_as_bomb
        '*'
      when :opened
        pointer.to_s
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

    def color
      case status
      when :initial
        COLOR_MAGENTA
      when :marked_as_bomb
        COLOR_MAGENTA
      when :opened
        COLOR_CYAN
      end
    end
  end
end
