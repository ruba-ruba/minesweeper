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

    ENTER = 10
    STEP = 3
    LEFT_RIGHT_PADDING = 2

    def_delegators :@window, :curx, :cury

    attr_reader :height, :width, :board, :window, :bomb_injector

    def initialize(height: , width: , bomb_injector: , window:)
      @height = height.to_i
      @width  = width.to_i
      @window = window
      @bomb_injector = bomb_injector
      @board  = []
    end

    def fill_with_cells
      height.times do
        board << Array.new(width) { Cell.new }
      end
    end

    def inject_bombs
      bomb_injector.inject(self)
    end

    def play(stdy = nil, stdx = nil)
      window.keypad = true
      draw_board
      window.setpos(stdy, stdx) if stdx && stdy
      noecho

      loop do
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
        when ENTER
          open_cell(cury, curx)
          play(cury, curx)
        when ' '
          trigger_bomb_flag(cury, curx)
          play(cury, curx)
        end
      end
    rescue GameWon, GameOver => e
      end_game(e)
      exit
    end

    private

    def draw_board
      window.clear
      board.each_index do |row_index|
        (0..(width*3-1)).each_slice(3).with_index do |cell_ary, index|
          cell = board[row_index][index]
          window.setpos(row_index, cell_ary[0])
          window.attron(color_pair(COLOR_BLUE)) { window.addstr '[' }
          window.attron(color_pair(cell.color)) { window.addstr cell.draw }
          window.attron(color_pair(COLOR_BLUE)) { window.addstr ']' }
        end
      end
      window.refresh
      window.setpos(0, 1)
    end

    def debug(args = {})
      window.setpos(20, 20)
      str = ''
      args.each { |k, a| str << "| #{k} #{a} |" }
      window.addstr(str)
      window.setpos(cury, curx)
    end

    def open_cell(y, x)
      cell_x = x / 3 # / 3 because rendered cell 3 chars
      open_original(y, cell_x)
    end

    def trigger_bomb_flag(y, x)
      cell_x = x / 3 # / 3 because rendered cell 3 chars
      cell = board[y][cell_x]
      cell.toggle_bomb_flag!
      raise GameWon if game_won?
    end

    def open_original(y, x)
      cell = board[y][x]
      return if cell.opened? || cell.marked_as_bomb?
      surrounding_bombs = number_of_boms_nearby(y, x)
      cell.open!(surrounding_bombs)
      raise GameOver if cell.bomb?
      raise GameWon  if game_won?
      open_zero_cells(y, x) if surrounding_bombs == 0
    end

    def open_zero_cells(y, x)
      # open left
      open_original(y, x-1) if x > 0
      # open right
      open_original(y, x+1) if x < board[y].index(board[y].last)
      # open top
      open_original(y-1, x) if y > 0
      # open bottom
      open_original(y+1, x) if y < board.index(board.last)
    end

    def game_won?
      cells.all?(&:opened?) &&
        bombs.all?(&:marked_as_bomb?)
    end

    def reveal_bombs
      bombs.each(&:open!)
    end

    def move_up
      if cury >= 1
        window.setpos(cury-1, curx)
      end
    end

    def move_down
      unless cury+1 >= height
        window.setpos(cury+1, curx)
      end
    end

    def move_left
      unless curx <= LEFT_RIGHT_PADDING
        window.setpos(cury, curx - STEP)
      end
    end

    def move_right
      unless curx >= (width*3 - LEFT_RIGHT_PADDING)
        window.setpos(cury, curx + STEP)
      end
    end

    def end_game(e)
      found_bombs_count = found_bombs.count
      reveal_bombs
      draw_board
      window.setpos(height+3, 0)
      window.addstr e.message
      window.setpos(height+5, 0)
      window.addstr <<-STR
Game Stats: you have found #{found_bombs_count} out of #{bombs.count} bombs

- `R` to replay with same parameters
- `Enter` to start a new game
- any other key to exit
      STR
      case window.getch
      when ENTER
        echo
        Minesweeper::Application.new
      when 'r', 'R'
        board = Minesweeper::BoardBuilder.from_board(self).build
        board.play
      end
    end

    def number_of_boms_nearby(y, x)
      bombs_around(y,x) + top_row_bombs(y, x) + bottom_row_bombs(y, x)
    end

    def bombs_around(y, x)
      row = board[y]
      working_cell = row[x]
      if working_cell == row.first
        row[1..1]
      elsif working_cell == row.last
        row[-2..-2]
      else
        [row[x-1], row[x+1]]
      end.count(&:bomb?)
    end

    def top_row_bombs(y, x)
      return 0 if y < 1
      row = board[y-1]
      bombs_around_in_row(row, x)
    end

    def bottom_row_bombs(y, x)
      return 0 if y >= height-1 # normalized height
      row = board[y+1]
      bombs_around_in_row(row, x)
    end

    def bombs_around_in_row(row, x)
      working_cell = row[x]
      if working_cell == row.first
        row[0..1]
      elsif working_cell == row.last
        row[-2..-1]
      else
        row[x-1..x+1]
      end.count(&:bomb?)
    end

    def cells
      board.flatten(1).reject(&:bomb?)
    end

    public

    # stats
    def bombs
      board.flatten(1).select(&:bomb?)
    end

    # stats
    def found_bombs
      bombs.select(&:marked_as_bomb?)
    end

    def number_of_cells
      height * width
    end
  end
end
