class RemoveFieldsFromTasks < ActiveRecord::Migration
  def up
    remove_column :tasks, :name
    remove_column :tasks, :due_date
  end

  def down
    add_column :tasks, :name, :string
    add_column :tasks, :due_date, :date
  end
end
