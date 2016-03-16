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

    def draw_board
      window.clear
      board.each_index do |row_index|
        (0..(width*3-1)).each_slice(3).with_index do |cell_ary, index| # dummy staff
          cell = board[row_index][index]
          window.setpos(row_index, cell_ary[0])
          window.addstr cell.draw
        end
      end
      window.refresh
      window.setpos(0,1)
    end

    def debug(args = {})
      window.setpos(20, 20)
      str = ""
      args.each{|k,a| str << "| #{k} #{a} |"}
      window.addstr(str)
      window.setpos(cury,curx)
    end

    def play(stdy=nil, stdx=nil)
      draw_board
      window.setpos(stdy, stdx) if stdx && stdy
      noecho

      while true
        ch = window.getch
        case ch
        when KEY_UP
          move_up
        when KEY_DOWN
          move_down
        when KEY_LEFT
          move_left
        when KEY_RIGHT
          move_right
        when 10 # ENTER
          open_cell(cury,curx)
          play(cury,curx)
        end
      end
    rescue GameWon, GameOver => e
      end_game(e)
      exit
    end

    def fill_board
      height.times do
        board << Array.new(width) { Cell.new }
      end
    end

    def open_cell(y,x)
      x = x / 3 # original cell, cos it takes 3 digits to render a cell
      cell = board[y][x]
      surrounding_bombs = number_of_boms_nearby(y,x)
      cell.open(surrounding_bombs)
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
          surrounding_bombs = number_of_boms_nearby(row_index,cell_index)
          cell.open(surrounding_bombs)
        end
      end
    end

    def move_up
      if cury >= 1
        window.setpos(cury-1,curx)
      end
    end

    def move_down
      unless cury+1 >= height
        window.setpos(cury+1,curx)
      end
    end

    def move_left
      unless curx <= 2
        window.setpos(cury,curx-3)
      end
    end

    def move_right
      unless curx >= (width*3-2)
        window.setpos(cury,curx+3)
      end
    end

    def end_game(e)
      open_all_cells
      draw_board
      window.setpos(height+3, 0)
      window.addstr e.message
      window.setpos(height+4, 0)
      window.addstr "press any key to exit"
      if window.getch
        window.close
      end
    end

    protected

    def number_of_boms_nearby(y,x)
      bombs_around(y,x) + top_row_bombs(y,x) + bottom_row_bombs(y,x)
    end

    def bombs_around(y,x)
      row = board[y]
      working_cell = row[x]
      cells =
        if working_cell == row.first
          row[1..1]
        elsif working_cell == row.last
          row[-2..-2]
        else
          [ row[x-1], row[x+1] ]
        end
      cells.count(&:bomb?)
    end

    def top_row_bombs(y,x)
      return 0 if y < 1
      row = board[y-1]
      bombs_around_in_row(row, x)
    end

    def bottom_row_bombs(y,x)
      return 0 if y >= height-1 # normalized height
      row = board[y+1]
      bombs_around_in_row(row, x)
    end

    def bombs_around_in_row(row, x)
      working_cell = row[x]
      cells =
        if working_cell == row.first
          row[0..1]
        elsif working_cell == row.last
          row[-2..-1]
        else
          row[x-1..x+1]
        end
      cells.count(&:bomb?)
    end

    def number_of_cells
      height * width
    end
  end
end