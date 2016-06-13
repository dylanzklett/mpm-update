class AddTasks < ActiveRecord::Migration
  def change
    create_table(:tasks) do |t|
      t.string       :name
      t.date         :due_date
      t.string       :status
      t.references   :manufacturer

      t.timestamps null: false
    end
  end
end
