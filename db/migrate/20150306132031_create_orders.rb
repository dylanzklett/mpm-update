class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :state
      t.references :customer
      t.decimal :price, precision: 10, scale: 3
      t.decimal :discount, precision: 10, scale: 3

      t.timestamps null: false
    end

    add_index :orders, :customer_id
  end
end
