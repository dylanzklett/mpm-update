class RenameSidemarkToCustomerPo < ActiveRecord::Migration
  def up
    rename_column :tasks, :sidemarks, :customer_po
  end

  def down
    rename_column :tasks, :customer_po, :sidemarks
  end
end
