# frozen_string_literal: true

module Minesweeper
  class CellState

    attr_accessor :color, :view, :status

    def initialize(color:, status:, view:)
      @view = view
      @color = color
      @status = status
    end

    def opened?
      status == :opened
    end

    def marked_as_bomb?
      status == :marked_as_bomb
    end
  end
end
