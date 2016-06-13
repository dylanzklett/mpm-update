class CreateTaskItems < ActiveRecord::Migration
  def change
    create_table :task_items do |t|
      t.references :task
      t.integer :quantity

      t.float :trough_size
      t.string :trough_color

      t.float :width_per_curt
      t.float :finished_lenght
      t.string :pattern_color

      t.string :room
      t.float :width
      t.float :height
    end
  end
end
