class AddStartAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :start_at, :date
  end
end
