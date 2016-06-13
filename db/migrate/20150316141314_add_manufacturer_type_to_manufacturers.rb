class AddManufacturerTypeToManufacturers < ActiveRecord::Migration
  def change
    add_column :manufacturers, :manufacturer_type, :string
  end
end
