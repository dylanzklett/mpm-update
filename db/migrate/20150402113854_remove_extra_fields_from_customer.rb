class RemoveExtraFieldsFromCustomer < ActiveRecord::Migration
  def up
    remove_column :customers, :first_name
    remove_column :customers, :last_name
    remove_column :customers, :first_title
    remove_column :customers, :second_title
    remove_column :customers, :first_address
    remove_column :customers, :second_address
    remove_column :customers, :city
    remove_column :customers, :state
    remove_column :customers, :zip
    remove_column :customers, :phone_o
    remove_column :customers, :phone_c
  end
  def down
    add_column :customers, :first_name, :string
    add_column :customers, :last_name, :string
    add_column :customers, :first_title, :string
    add_column :customers, :second_title, :string
    add_column :customers, :first_address, :string
    add_column :customers, :second_address, :string
    add_column :customers, :city, :string
    add_column :customers, :state, :string
    add_column :customers, :zip, :string
    add_column :customers, :phone_o, :string
    add_column :customers, :phone_c, :string
  end
end
