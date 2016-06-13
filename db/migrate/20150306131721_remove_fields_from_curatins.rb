class RemoveFieldsFromCuratins < ActiveRecord::Migration
  def up
    remove_column :curtains, :state
    remove_column :curtains, :customer_id
    remove_column :curtains, :multiple
    add_column :curtains, :discount, :decimal, precision: 10, scale: 3
    add_column :curtains, :order_id, :integer
  end

  def down
    remove_column :curtains, :order_id
    remove_column :curtains, :discount
    add_column :curtains, :multiple, :boolean
    add_column :curtains, :customer_id, :integer
    add_column :curtains, :state, :string
  end
end
