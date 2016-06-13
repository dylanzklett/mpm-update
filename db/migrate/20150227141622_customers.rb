class Customers < ActiveRecord::Migration
  def change
     create_table(:customers) do |t|
       t.string :email
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
       t.references :sales

       t.timestamps null: false
     end

     add_index :customers, :email
     add_index :customers, :first_name
     add_index :customers, :last_name
     add_index :customers, :first_address
     add_index :customers, :second_address
     add_index :customers, :city
     add_index :customers, :state
     add_index :customers, :phone_o
     add_index :customers, :phone_c
     add_index :customers, :sales_id
  end
end
