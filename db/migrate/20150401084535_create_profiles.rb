class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :person, polymorphic: true
      t.string :first_name
      t.string :last_name
      t.string :first_title
      t.string :second_title
      t.string :first_address
      t.string :second_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone_o
      t.string :phone_c

      t.timestamps null: false
    end

    add_index :profiles, :first_name
    add_index :profiles, :last_name
    add_index :profiles, :first_address
    add_index :profiles, :second_address
    add_index :profiles, :city
    add_index :profiles, :state
    add_index :profiles, :phone_o
    add_index :profiles, :phone_c
  end
end
