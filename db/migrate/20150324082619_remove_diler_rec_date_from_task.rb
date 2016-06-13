class RemoveDilerRecDateFromTask < ActiveRecord::Migration
  def up
    remove_column :tasks, :diler_rec_date
  end

  def down
    add_column :tasks, :diler_rec_date, :date
  end
end
