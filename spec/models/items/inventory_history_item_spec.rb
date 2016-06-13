require 'rails_helper'

RSpec.describe InventoryHistoryItem, type: :model do
  let(:inventory_history_item) { create :inventory_history_item,  event: 'addition' }

  it {expect(inventory_history_item).to be_addition}
end
