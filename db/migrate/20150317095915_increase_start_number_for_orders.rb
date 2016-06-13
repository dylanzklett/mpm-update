class IncreaseStartNumberForOrders < ActiveRecord::Migration
  def up
    execute("UPDATE orders SET id = id + 4000;")
    execute("ALTER SEQUENCE orders_id_seq RESTART WITH 4100;")
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
