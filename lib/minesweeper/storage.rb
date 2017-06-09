require 'singleton'

module Minesweeper
  class Storage
    include Singleton

    DB = Sequel.sqlite
    DB.execute <<-SQL
      CREATE TABLE IF NOT EXISTS board_params (
        height integer,
        width integer,
        level varchar(255)
      );
    SQL

    def read
      table.first
    end

    def flush
      table.delete
    end

    def insert(**args)
      table.insert(args)
    end

    private

    def table
      DB[:board_params]
    end
  end
end
