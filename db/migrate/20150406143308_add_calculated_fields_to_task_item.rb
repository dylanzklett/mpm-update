class AddCalculatedFieldsToTaskItem < ActiveRecord::Migration
  def change
    add_column :task_items, :calculated_fabric,   :float
    add_column :task_items, :calculated_weight,   :float
    add_column :task_items, :calculated_labor,    :float
    add_column :task_items, :calculated_shirring, :float
    add_column :task_items, :calculated_tape,     :float
  end
end
