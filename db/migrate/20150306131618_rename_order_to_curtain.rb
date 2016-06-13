class RenameOrderToCurtain < ActiveRecord::Migration
  def change
    rename_table :orders, :curtains
  end
end
