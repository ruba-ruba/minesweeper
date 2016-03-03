module Minesweeper
  class Cell
    attr_accessor :status, :bomb

    def initialize(status: :initial, bomb: false)
      @status, @bomb = status, bomb
    end

    def make_it_bomb
      if bomb
        false
      else
        self.bomb = true
      end
    end

    def draw
      print '_'
    end
  end
end