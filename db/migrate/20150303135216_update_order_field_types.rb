class UpdateOrderFieldTypes < ActiveRecord::Migration
  def up
    change_column :orders, :width, :decimal, precision: 10, scale: 3
    change_column :orders, :height, :decimal, precision: 10, scale: 3
  end

  def down
    change_column :orders, :height, :decimal, precision: 10, scale: 3
    change_column :orders, :width, :decimal, precision: 10, scale: 3
  end
end
