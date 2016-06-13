class FixTypo < ActiveRecord::Migration
  def up
    rename_column :task_items, :finished_lenght, :finished_length
  end

  def down
    rename_column :task_items, :finished_length, :finished_length
  end
end
