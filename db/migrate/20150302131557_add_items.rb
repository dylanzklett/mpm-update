class AddItems < ActiveRecord::Migration
  def change
    create_table(:items) do |t|
      t.string :name
      t.integer :quantity
      t.decimal :price
      t.references :order

      t.timestamps null: false
    end

    add_index :items, :name
  end
end
