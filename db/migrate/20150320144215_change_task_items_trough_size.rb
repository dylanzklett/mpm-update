class ChangeTaskItemsTroughSize < ActiveRecord::Migration
  def up
    change_column :task_items, :trough_size, :string
  end

  def down
    change_column :task_items, :trough_size, :float
  end
end
