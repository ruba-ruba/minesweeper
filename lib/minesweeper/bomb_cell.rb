module Minesweeper
  class BombCell
    attr_accessor :status, :pointer, :force_color

    def initialize(status: :initial)
      @status = status
      @pointer = nil
      @force_color = nil
    end

    def bomb?
      true
    end

    def draw
      case status
      when :initial
        ' '
      when :marked_as_bomb
        '*'
      when :opened
        '*'
      else
        raise NotImplementedError
      end
    end

    def toggle_bomb_flag!
      if marked_as_bomb?
        self.force_color = nil
        self.status = :initial
      else
        self.force_color = COLOR_WHITE
        self.status = :marked_as_bomb
      end
    end

    def open!(*)
      self.status = :opened
    end

    %i[initial marked_as_bomb opened].each do |method|
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
        color_when_opened
      end
    end

    private

    def color_when_opened
      force_color.nil? ? COLOR_RED : force_color
    end
  end
end
