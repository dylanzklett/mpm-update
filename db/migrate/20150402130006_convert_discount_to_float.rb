class ConvertDiscountToFloat < ActiveRecord::Migration
  def up
    change_column :projects, :discount, :float
  end

  def down
    change_column :projects, :discount, :decimal, precision: 10, scale: 3
  end
end
