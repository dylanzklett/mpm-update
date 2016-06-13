class CreateInventoryHistoryItem < ActiveRecord::Migration
  def change
    create_table :inventory_history_items do |t|
      t.references :inventory_item, null: false
      t.references :support_item
      t.string     :event,          null: false
      t.string     :whodunnit
      t.float      :amount

      t.timestamps null: false
    end
  end
end
