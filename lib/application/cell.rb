module Minesweeper
  class Cell

    attr_accessor :status, :bomb, :pointer

    alias bomb? bomb

    def initialize(status: :initial, bomb: false)
      @status, @bomb = status, bomb
      @pointer = nil
    end

    def make_it_bomb
      if bomb?
        false
      else
        self.bomb = true
      end
    end

    def draw(window)
      case status
      when :initial
        window.addstr(' ')
      when :marked_as_bomb
        window.attron(color_pair(COLOR_MAGENTA)) { window.addstr 'b' }
      when :opened
        color = bomb? ? COLOR_RED : COLOR_CYAN
        window.attron(color_pair(color)) { window.addstr "#{pointer}" }
      else
        raise NotImplementedError
      end
    end

    # user can mark / unmark cell as bomb
    def trigger_bomb_flag!
      self.status =
        if status == :marked_as_bomb
          :initial
        else
          :marked_as_bomb
        end
    end

    # remove zero stub
    def open!(number_of_boms_nearby = 0)
      self.status  = :opened
      self.pointer =
        if bomb?
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
  end
end
