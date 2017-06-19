# frozen_string_literal: true

module Minesweeper
  class BaseCell
    extend Forwardable

    def_delegators :@state, :view, :color, :opened?, :marked_as_bomb?

    attr_reader :state

    def initialize
      @state = initial_state
    end

    def bomb?
      raise NotImplementedError, 'defined in subclass'
    end

    def toggle_bomb_flag!
      return if opened?
      if state.marked_as_bomb?
        state.view = ' '
        state.color = COLOR_MAGENTA
        state.status = :initial
      else
        state.view = '*'
        state.color = COLOR_MAGENTA
        state.status = :marked_as_bomb
      end
    end

    def open!(*)
      raise NotImplementedError, 'defined in subclass'
    end

    private

    def initial_state
      CellState.new(color: COLOR_MAGENTA, view: ' ', status: :initial)
    end
  end
end
