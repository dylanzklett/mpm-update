class MoveDiscountToOrderFromCuratin < ActiveRecord::Migration
  def up
    remove_column :curtains, :discount
  end

  def down
    add_column :curtains, :discount, :decimal, precision: 10, scale: 3
  end
end
