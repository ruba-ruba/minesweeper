module Minesweeper
  class Cell

    attr_accessor :status, :bomb, :pointer

    alias_method :bomb?, :bomb

    def initialize(status: :initial, bomb: false)
      @status, @bomb, number = status, bomb
      @pointer = nil
    end

    def make_it_bomb
      if bomb
        false
      else
        self.bomb = true
      end
    end

    def draw
      case status
      when :initial
        "[ ]"
      when :marked_as_bomb
        "[b]"
      when :opened
        "[#{pointer}]"
      else
        raise NotImplementedError
      end
    end

    # user can mark / unmark cell as bomb
    def trigger_bomb_flag!
      if status == :marked_as_bomb
        self.status = :initial
      else
        self.status = :marked_as_bomb
      end
    end

    # remove zero stub
    def open!(number_of_boms_nearby = 0)
      self.status  = :opened
      self.pointer =
        if bomb
          "*"
        else
          number_of_boms_nearby
        end
    end

    def opened?
      self.status == :opened
    end

    def marked_as_bomb?
      self.status == :marked_as_bomb
    end
  end
end