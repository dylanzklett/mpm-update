class AddCountryToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :country, :string, default: 'USA'
  end
end
