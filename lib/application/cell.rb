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
      when :opened
        "[#{pointer}]"
      else
        raise NotImplementedError
      end
    end

    # remove zero stub
    # rename to open! since it change status
    def open(number_of_boms_nearby = 0)
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
  end
end