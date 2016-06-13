class ChangeOrderIdToProjectId < ActiveRecord::Migration
  def up
    rename_column :tasks, :order_id, :project_id
    rename_column :curtains, :order_id, :project_id
    rename_column :items, :order_id, :project_id
  end
  def down
    rename_column :items, :project_id, :order_id
    rename_column :curtains, :project_id, :order_id
    rename_column :tasks, :project_id, :order_id
  end
end
