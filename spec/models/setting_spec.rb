require 'rails_helper'

RSpec.describe Setting, type: :model do
  context '#items_attributes=' do
    let(:item_hash) { {name: 'Item1', quantity: '10', price: '2', unit: 'ft'} }
    let(:blank_hash) { {name: '', unit: '', quantity: '', price: '', '_destroy' => '1'} }

    let(:item_attributes) do
      {
          1 => ActionController::Parameters.new(item_hash),
          2 => ActionController::Parameters.new(blank_hash)
      }
    end

    let(:expected) { [item_hash].to_json }

    let(:setting) { create :setting, items_attributes: item_attributes }
    it { expect(setting.value).to eql expected }
    it { expect(setting.convert_for_show).to eql expected }
  end

  context 'getting values' do
    [:fabric_color, :trough_color, :center_support, :end_bracket, :multiplicity_items, :installation_price,
     :price_matrix, :trough_step, :trough_matrix].each do |setting_type|
      let!(setting_type) { create :setting, setting_type }
    end

    let!(:width_multiplicity) { create :unit_setting, :width_multiplicity }

    it 'should get array value' do
      %i[fabric_color trough_color center_support end_bracket].each do |setting_type|
        expect(described_class.send(setting_type)).to eql send(setting_type).value.split(',').map(&:strip)
      end
    end

    it { expect(described_class.width_multiplicity).to eq width_multiplicity.value }
    it { expect(described_class.installation_price).to eq installation_price.value.to_f }
    it { expect(described_class.trough_step).to eq trough_step.value }

    it { expect(described_class.multiplicity_items.code).to eq 'multiplicity_items' }
    it { expect(described_class.price_matrix.code).to eq 'price_matrix' }
    it { expect(described_class.trough_matrix.code).to eq 'trough_matrix' }


    it { expect(described_class.get_by('trough_matrix').code).to eq 'trough_matrix' }
  end

  context '#convert_to' do
    let!(:setting) { create :setting, value: '20 in' }

    it { expect(setting.convert_to('mm')).to eql setting.value.to_unit.convert_to('mm').scalar.to_f }

  end
end
