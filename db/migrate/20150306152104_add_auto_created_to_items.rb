class AddAutoCreatedToItems < ActiveRecord::Migration
  def change
    add_column :items, :auto_create, :boolean, default: false
  end
end
