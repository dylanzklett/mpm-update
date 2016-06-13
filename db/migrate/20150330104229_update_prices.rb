class UpdatePrices < ActiveRecord::Migration
  def up
    change_column :curtains, :price, :decimal, precision: 10, scale: 3
    change_column :items, :price, :decimal, precision: 10, scale: 3
  end

  def down
    change_column :items, :price, :decimal
    change_column :curtains, :price, :decimal
  end
end
