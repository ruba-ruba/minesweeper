module Minesweeper
  class Cell
    attr_accessor :status, :bomb, :pointer

    alias bomb? bomb

    def initialize(status: :initial, bomb: false)
      @status = status
      @bomb = bomb
      @pointer = nil
    end

    def make_it_bomb!
      return false if bomb?
      self.bomb = true
    end

    def draw(window)
      case status
      when :initial
        window.addstr(' ')
      when :marked_as_bomb
        window.attron(color_pair(color)) { window.addstr 'b' }
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
      return if bomb? && marked_as_bomb?
      self.status  = :opened
      self.pointer =
        if bomb? && marked_as_bomb? # can not happen
          '+'
        elsif bomb?
          '*'
        else
          number_of_boms_nearby
        end
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
        bomb? ? COLOR_RED : COLOR_CYAN
      end
    end
  end
end
