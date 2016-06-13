class AddCustomerNumberToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :customer_number, :string
    add_column :orders, :sales_number, :string
  end
end
