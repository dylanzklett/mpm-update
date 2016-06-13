class CreateInventoryItem < ActiveRecord::Migration
  def change
    create_table :inventory_items do |t|
      t.references :manufacturer
      t.string :name
      t.string :description
      t.string :unit

      t.timestamps null: false
    end
  end
end
