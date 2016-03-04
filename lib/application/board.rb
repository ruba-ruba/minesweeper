module Minesweeper

  class GameOver < StandardError
    def message
      "You Lost"
    end
  end

  class GameWon < StandardError
    def message
      "You Won"
    end
  end

  class Board
    attr_reader :height, :width, :level, :board

    def initialize(height: 9, width: 9, level: :beginner)
      @height = height.to_i
      @width  = width.to_i
      @level  = level
      @board  = []
    end

    def draw
      board.each do |row|
        row.each do |cell|
          cell.draw
        end && puts
      end
    end

    def fill_board
      height.times do
        board << Array.new(width) { Cell.new }
      end
      self
    end

    def play
      ARGF.each do |line|
        x, y = line.strip.split
        unless x && y 
          puts 'two coordinates needed'
          play
        end
        if x.to_i > width || y.to_i > height
          puts 'coordinates out of valid range'
          play
        end
        open_cell(x.to_i-1, y.to_i-1)
        puts "opened cell with x: #{x.to_i-1}, y: #{y.to_i-1}"
        self.draw
      end
    rescue GameOver, GameWon => e 
      puts
      open_all_cells && draw
      puts e.message
      exit
    end

    def open_cell(x,y)
      cell = board[x][y]
      surrounding_bombs = number_of_boms_nearby(x,y)
      cell.open(surrounding_bombs)
      raise GameOver if cell.bomb
      raise GameWon  if opened_all_available_cells? 
    end

    private

    def opened_all_available_cells?
      board.flatten(1).select{|cell| !cell.bomb}.all?{|cell| cell.opened?}
    end
    
    def open_all_cells
      board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          cell.open(number_of_boms_nearby(cell_index,row_index))
        end
      end
    end

    protected

    def number_of_boms_nearby(x,y)
      left_cell    = board[x][y-1]
      right_cell   = board[x][y+1]
      top_cell     = board.fetch(x-1, [])[y]
      bottom_cell  = board.fetch(x+1, [])[y]
      left_top     = board.fetch(x-1, [])[y-1]
      right_top    = board.fetch(x-1, [])[y+1]
      left_bottom  = board.fetch(x+1, [])[y-1]
      right_bottom = board.fetch(x+1, [])[y+1]
      cells = [left_cell, right_cell, top_cell, bottom_cell, left_top, right_top, left_bottom, right_bottom]
      cells.compact.select{|x| x.bomb}.count
    end

    def number_of_cells
      height * width
    end
  end
end