class ChangeWidthAndHeight < ActiveRecord::Migration
  def up
    change_column :curtains, :width, :float
    change_column :curtains, :height, :float
  end
  def down
    change_column :curtains, :height, :decimal, precision: 10, scale: 3
    change_column :curtains, :width, :decimal, precision: 10, scale: 3
  end
end
