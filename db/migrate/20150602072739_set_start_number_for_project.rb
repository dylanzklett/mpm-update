class SetStartNumberForProject < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER SEQUENCE projects_id_seq RESTART WITH 7500;
    SQL
  end

  def down
  end
end
