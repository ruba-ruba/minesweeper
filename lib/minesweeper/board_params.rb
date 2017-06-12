module Minesweeper
  Sequel::Model.db = Sequel.sqlite
  Sequel::Model.strict_param_setting = false
  Sequel::Model.db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS board_params (
      id integer PRIMARY KEY,
      height integer,
      width integer,
      level varchar(255)
    );
  SQL

  class BoardParams < Sequel::Model
    plugin :validation_helpers

    def validate
      super
      validates_integer %i[height width]
      validates_includes %w[beginner advanced expert], :level
    end
  end
end
