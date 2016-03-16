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
        noecho
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
    rescue GameWon, GameOver => e
      open_all_cells
      draw_board
      window.setpos(height+3, 0)
      window.addstr e.message
      window.setpos(height+4, 0)
      window.addstr "press any key to exit"
      window.getch
    end

    def fill_board
      height.times do
        board << Array.new(width) { Cell.new }
      end
      self
    end

    def open_cell(y,x)
      # binding.pry
      x = x / 3 # original cell
      cell = board[y][x]
      surrounding_bombs = number_of_boms_nearby(y,x)
      cell.open()
      # raise GameOver if cell.bomb
      raise GameWon  if opened_all_available_cells?
    end

    private

    def opened_all_available_cells?
      board.flatten(1).select{|cell| !cell.bomb}.all?{|cell| cell.opened?}
    end

    def open_all_cells
      board.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          cell.open()
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

    def number_of_boms_nearby(y,x)
      top_row_cells
    end

    def top_row_cells
    end

    def number_of_cells
      height * width
    end
  end
end