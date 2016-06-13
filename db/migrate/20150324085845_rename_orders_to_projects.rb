class RenameOrdersToProjects < ActiveRecord::Migration
  def up
    rename_table :orders, :projects
  end

  def down
    rename_table :projects, :orders
  end
end
