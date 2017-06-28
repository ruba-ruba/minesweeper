# frozen_string_literal: true

module Minesweeper
  class Board
    extend Forwardable

    ENTER = 10
    STEP = 3
    LEFT_RIGHT_PADDING = 2
    SPACE = ' '

    def_delegators :@window, :curx, :cury
    def_delegators :board_params, :height, :width

    attr_reader :board_params, :cells, :window

    def initialize(board_params:, window:)
      @board_params = board_params
      @window = window
      @cells  = []
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
          open_cell
        when SPACE
          toggle_bomb_flag
        end
        play(cury, curx)
      end
    rescue GameWon, GameOver => e
      end_game(e)
      exit
    end

    private

    def draw_board
      window.clear
      cells.each_index do |row_index|
        (0..(width * 3 - 1)).each_slice(3).with_index do |cell_ary, index|
          cell = cells[row_index][index]
          window.setpos(row_index, cell_ary[0])
          window.attron(color_pair(COLOR_BLUE)) { window.addstr '[' }
          window.attron(color_pair(cell.color)) { window.addstr cell.view }
          window.attron(color_pair(COLOR_BLUE)) { window.addstr ']' }
        end
      end
      window.refresh
      window.setpos(0, 1)
    end

    def cell_x
      curx / STEP
    end

    def open_cell
      open_original(cury, cell_x)
    end

    def toggle_bomb_flag
      cell = cells[cury][cell_x]
      cell.toggle_bomb_flag!
      raise GameWon if game_won?
    end

    def open_original(y, x)
      cell = cells[y][x]
      return if cell.opened? || cell.marked_as_bomb?
      surrounding_bombs = number_of_boms_nearby(y, x)
      cell.open!(surrounding_bombs)
      raise GameOver if cell.bomb?
      raise GameWon  if game_won?
      open_zero_cells(y, x) if surrounding_bombs.zero?
    end

    def open_zero_cells(y, x)
      # open left
      open_original(y, x - 1) if x.positive?
      # open right
      open_original(y, x + 1) if x < cells[y].index(cells[y].last)
      # open top
      open_original(y - 1, x) if y.positive?
      # open bottom
      open_original(y + 1, x) if y < cells.index(cells.last)
    end

    def game_won?
      not_bombs.all?(&:opened?) &&
        bombs.all?(&:marked_as_bomb?)
    end

    def reveal_bombs
      bombs.each(&:open!)
    end

    def move_up
      return if cury.zero?
      window.setpos(cury - 1, curx)
    end

    def move_down
      return if cury + 1 >= height
      window.setpos(cury + 1, curx)
    end

    def move_left
      return if curx <= LEFT_RIGHT_PADDING
      window.setpos(cury, curx - STEP)
    end

    def move_right
      return if curx >= (width * 3 - LEFT_RIGHT_PADDING)
      window.setpos(cury, curx + STEP)
    end

    def end_game(e)
      found_bombs_count = found_bombs.count
      reveal_bombs
      draw_board
      window.setpos(height + 3, 0)
      window.addstr e.message
      window.setpos(height + 5, 0)
      window.addstr <<~STR
        Game Stats: you have found #{found_bombs_count} out of #{bombs.count} bombs

        - `R` to replay with same parameters
        - `Enter` to start a new game
        - any other key to exit
      STR
      start_or_restart_game
    end

    # used when user won/lose game & decided to begin anew
    # eventually will be moved to game initializer
    def start_or_restart_game
      case window.getch
      when ENTER
        echo
        game_initializer.start
      when 'r', 'R'
        game_initializer.restart
      end
    end

    def number_of_boms_nearby(y, x)
      bombs_around(y, x) + top_row_bombs(y, x) + bottom_row_bombs(y, x)
    end

    def bombs_around(y, x)
      row = cells[y]
      working_cell = row[x]
      if working_cell == row.first
        row[1..1]
      elsif working_cell == row.last
        row[-2..-2]
      else
        [row[x - 1], row[x + 1]]
      end.count(&:bomb?)
    end

    def top_row_bombs(y, x)
      return 0 if y < 1
      row = cells[y - 1]
      bombs_around_in_row(row, x)
    end

    def bottom_row_bombs(y, x)
      return 0 if y >= height - 1 # normalized height
      row = cells[y + 1]
      bombs_around_in_row(row, x)
    end

    def bombs_around_in_row(row, x)
      working_cell = row[x]
      if working_cell == row.first
        row[0..1]
      elsif working_cell == row.last
        row[-2..-1]
      else
        row[x - 1..x + 1]
      end.count(&:bomb?)
    end

    def not_bombs
      cells.flatten(1).reject(&:bomb?)
    end

    def game_initializer
      @game_initializer ||= Minesweeper::GameInitializer.new
    end

    public

    def bombs
      cells.flatten(1).select(&:bomb?)
    end

    def found_bombs
      bombs.select(&:marked_as_bomb?)
    end

    def number_of_cells
      cells.flatten.count
    end
  end
end
