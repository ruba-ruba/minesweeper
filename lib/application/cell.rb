module Minesweeper
  class Cell
    attr_accessor :status, :bomb, :pointer

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
        print '_'
      when :opened
        print "#{pointer}"
      else
        raise NotImplementedError
      end
    end

    def open(number_of_boms_nearby)
      self.status = :opened
      if bomb  
        self.pointer = "X"
      else
        self.pointer = number_of_boms_nearby
      end
    end

    def opened?
      self.status == :opened
    end
  end
end