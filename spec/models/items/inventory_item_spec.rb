require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  let!(:inventory_item) { create :inventory_item, amount: 10, name: 'Inventory', manufacturer_id: 5 }

  it { expect(inventory_item.name).to eq 'inventory' }

  context 'initialize with first addition' do
    it { expect(inventory_item.additions).to eql 10.0 }
    it { expect(inventory_item.deletions).to eql 0.0 }
    it { expect(inventory_item.balance).to eql 10.0 }
  end

  context 'when create supports item' do
    SUPPORT_ITEM1_QUANTITY = 3.2
    SUPPORT_ITEM2_QUANTITY = 4

    let(:task) { create(:task, manufacturer_id: inventory_item.manufacturer_id) }

    it 'expects to calculate new balance with one support item' do
      expect {
        create :support_item, task: task, name: 'inventory', quantity: SUPPORT_ITEM1_QUANTITY
      }.to change{ inventory_item.balance }.from(inventory_item.balance).to(inventory_item.additions - SUPPORT_ITEM1_QUANTITY)
    end

    it 'expects to calculate new balance with one support item' do
      expect {
        create :support_item, task: task, name: 'inventory', quantity: SUPPORT_ITEM2_QUANTITY
      }.to change{ inventory_item.balance }.from(inventory_item.balance).to(inventory_item.additions - SUPPORT_ITEM2_QUANTITY)
    end
  end
end
