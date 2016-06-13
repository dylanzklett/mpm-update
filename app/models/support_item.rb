class SupportItem < ActiveRecord::Base
  belongs_to :task

  has_one :inventory_history_item, dependent: :destroy

  validates :name, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  after_save :set_inventory_history_item

  private
  def set_inventory_history_item
    self.inventory_history_item.try(:destroy)

    inventory_item = InventoryItem.where(manufacturer_id: task.manufacturer_id, name: self.name.downcase).first

    if inventory_item
      inventory_item.inventory_history_items.create event: 'deletion',
                                                    whodunnit: AuthorizationData.current_user.try(:id),
                                                    amount: self.quantity,
                                                    support_item_id: self.id
    end
  end
end
