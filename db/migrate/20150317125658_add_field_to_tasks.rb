class AddFieldToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :ship_via, :string
    add_column :tasks, :ship_to, :text
    add_column :tasks, :instructions, :text
    add_column :tasks, :mitech_po, :string
    add_column :tasks, :date_wanted, :date
    add_column :tasks, :mitech_rec_date, :date
    add_column :tasks, :pref_ship_method, :string
    add_column :tasks, :diler_rec_date, :date
    add_column :tasks, :sidemarks, :string
    add_column :tasks, :type, :string
    add_column :tasks, :order_id, :integer
  end
end
