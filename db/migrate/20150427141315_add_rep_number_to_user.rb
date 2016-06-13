class AddRepNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :rep_number, :string
  end
end
