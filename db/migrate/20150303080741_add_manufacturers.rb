class AddManufacturers < ActiveRecord::Migration
  def change
    create_table(:manufacturers) do |t|
      t.string :title
      t.string :email
      t.string :phone
      t.text   :address

      t.timestamps null: false
    end
  end
end
