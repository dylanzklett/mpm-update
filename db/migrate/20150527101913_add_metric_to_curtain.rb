class AddMetricToCurtain < ActiveRecord::Migration
  def change
    add_column :curtains, :metric, :string, default: 'Imperial'
  end
end
