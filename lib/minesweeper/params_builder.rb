# frozen_string_literal: true

module Minesweeper
  # used for reading / creating board params.
  class ParamsBuilder
    extend Forwardable

    DEFAULTS = { height: 10, width: 10, level: 'advanced' }.freeze

    attr_reader :flush_params, :ui

    def initialize(flush_params)
      @flush_params = flush_params
      @ui = Minesweeper::Ui
    end

    def_delegators :entry, :height, :width, :level

    def prepare
      entry && entry.delete if flush_params
      entry || build
    end

    private

    def entry
      ::Minesweeper::BoardParams.first
    end

    def build(y_position = 4)
      ui.params_message
      ui.setpos(y_position, 42)
      str = ui.getstr
      params =
        if str.casecmp('y').zero?
          DEFAULTS
        else
          { height: ask_y, width: ask_x, level: ask_level }
        end
      board_params = ::Minesweeper::BoardParams.new(params)
      validate_and_save(board_params)
    end

    def validate_and_save(instance)
      if instance.valid?
        instance.save
        instance
      else
        ui.validation_errors(instance.errors)
        build(instance.errors.count + 1)
      end
    end

    def ask_x
      ui.col_num
      x = ui.getstr
      max_x = ui.maxx / Minesweeper::Board::STEP
      x.to_i > max_x ? max_x : x
    end

    def ask_y
      ui.row_num
      y = ui.getstr
      y.to_i > ui.maxy ? ui.maxy - 1 : y
    end

    def ask_level
      ui.level
      ui.getstr
    end
  end
end
