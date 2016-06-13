class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 3
      t.references :manufacturer

      t.timestamps null: false
    end
  end
end
