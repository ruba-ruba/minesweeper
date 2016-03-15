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
    require 'forwardable'

    extend Forwardable

    def_delegators :@window, :curx, :cury  

    attr_reader :height, :width, :level, :board, :window

    def initialize(height: 9, width: 9, level: :beginner, window: nil)
      @height = (height.to_i) || 9
      @width  = (width.to_i)  || 9
      @level  = level         || :beginner
      @board  = []
      @window = window
      fill_board
    end

    # def draw
    #   board.each do |row|
    #     row.each do |cell|
    #       cell.draw
    #     end && puts
    #   end
    # end


    def draw_board
      window.clear
      board.each_index do |row_index|
        (0..(width*3-1)).each_slice(3).with_index do |cell_ary, index| # dummy staff
          cell = board[row_index][index]
          # debug({row_index: row_index, index: index-1})
          window.setpos(row_index, cell_ary[0])
          window.addstr cell.draw 
        end
      end
      window.refresh
      window.setpos(0,1)
    end

    def debug(args = {})
      x = curx
      y = cury
      window.setpos(20, 20)
      str = ""
      args.each{|k,a| str << "| #{k} #{a} |"}
      window.addstr(str)
      window.setpos(y,x)
    end

    def play(stdy=nil, stdx=nil)
      draw_board
      window.setpos(stdy, stdx) if stdx && stdy

      while true
        x = curx
        y = cury
        window.keypad = true
        ch =  window.getch
        case ch
        when KEY_UP
          move_up
        when KEY_DOWN
          move_down
        when KEY_LEFT
          move_left
        when KEY_RIGHT
          move_right
        when 10
          open_cell(y,x)
          play(y,x)
        end
        window.refresh
      end
    end

    def fill_board
      height.times do
        board << Array.new(width) { Cell.new }
      end
      self
    end

    # def play
    #   ARGF.each do |line|
    #     x, y = line.strip.split
    #     if line.strip.match(/exit|end/)
    #       raise GameOver
    #     end
    #     unless x && y
    #       puts 'two coordinates needed'
    #       play
    #     end
    #     if x.to_i > width || y.to_i > height || x.to_i.zero? || y.to_i.zero?
    #       puts 'coordinates out of valid range'
    #       play
    #     end
    #     open_cell(x.to_i-1, y.to_i-1)
    #     puts "opened cell with x: #{x}, y: #{y}"
    #     self.draw
    #   end
    # rescue GameOver, GameWon => e
    #   puts
    #   open_all_cells && draw
    #   puts e.message
    #   exit
    # end

    def open_cell(y,x)
      # binding.pry
      x = x / 3 # original cell
      cell = board[y][x]
      # surrounding_bombs = number_of_boms_nearby(x,y)
      cell.open()
      # raise GameOver if cell.bomb
      # raise GameWon  if opened_all_available_cells?
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

    def move_up
      x = curx
      y = cury
      if y >= 1
        window.setpos(y-1,x)
      end
    end

    def move_down
      x = curx
      y = cury
      unless y+1 >= height
        window.setpos(y+1,x)
      end
    end

    def move_left
      x = curx
      y = cury
      # not for now
      # if x <= 2
      #   window.setpos(y-1,(width*3)-1)
      # end 
      # if x >= width*3+3
      #   window.setpos(y,x-2)
      unless x <= 2  
        window.setpos(y,x-3)
      end
    end

    def move_right
      x = curx
      y = cury
      unless x >= (width*3-2)
        window.setpos(y,x+3)
      end
    end

    protected

    def number_of_boms_nearby(x,y)
      left_cell    = board[y][x-1] unless board[y].first == board[y][x]
      right_cell   = board[y][x+1] unless board[y].last  == board[y][x]

      left_top, top_cell, right_top  = get_row_elements(board[y-1], x)
      left_bottom, bottom_cell, right_bottom = get_row_elements(board[y+1], x)

      cells = [left_cell, right_cell, top_cell, bottom_cell, left_top, right_top, left_bottom, right_bottom]
      cells.compact.select{|x| x.bomb}.count
    end

    def get_row_elements(row, x)
      return if row.nil?
      # return if there are not row above or below
      return if board.first == row || board.last == row
      first_el = x.zero? ? x : x-1
      last_el  = (row[x] == row.last) ? x : x+1
      row[first_el..last_el]
    end

    def number_of_cells
      height * width
    end
  end
end