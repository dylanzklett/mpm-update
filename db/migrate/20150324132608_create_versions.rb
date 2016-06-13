class CreateVersions < ActiveRecord::Migration
  def change
    create_table :project_versions do |t|
      t.references :project,   :null => false
      t.string     :event,     :null => false
      t.string     :whodunnit
      t.text       :object
      t.text       :object_changes
      t.datetime   :created_at
    end
    add_index :project_versions, [:project_id]
  end
end
