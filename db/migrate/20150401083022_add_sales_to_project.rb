class AddSalesToProject < ActiveRecord::Migration
  def change
    add_column :projects, :sales_id, :integer
  end
end
