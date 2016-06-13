class AddSettings < ActiveRecord::Migration
  def change
    create_table(:settings) do |t|
      t.string :code
      t.text   :value

      t.timestamps null: false
    end
  end
end
