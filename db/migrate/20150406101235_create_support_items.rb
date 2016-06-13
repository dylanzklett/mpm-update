class CreateSupportItems < ActiveRecord::Migration
  def change
    create_table(:support_items) do |t|
      t.references :task

      t.string :name
      t.string :unit
      t.float :quantity
      t.decimal :price, precision: 10, scale: 3

      t.timestamps null: false
    end

    add_index :support_items, :name
  end
end
