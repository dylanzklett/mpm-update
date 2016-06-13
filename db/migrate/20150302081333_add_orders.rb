class AddOrders < ActiveRecord::Migration
  def change
    create_table(:orders) do |t|
      t.string :building_number
      t.string :room
      t.integer :width
      t.integer :height
      t.boolean :multiple
      t.boolean :inside
      t.string :wall_type
      t.string :fabric_color
      t.string :trough_color
      t.integer :center_support
      t.integer :end_bracket
      t.integer :quantity
      t.references :customer

      t.timestamps null: false
    end

    add_index :orders, :customer_id
  end
end
