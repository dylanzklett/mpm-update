require 'rails_helper'

RSpec.describe Curtain, :type => :model do
  let!(:setting) { create :unit_setting, :width_multiplicity }
  let!(:setting2) { create :setting, :price_matrix }
  let!(:setting3) { create :setting, :trough_step }
  let!(:setting4) { create :setting, :trough_matrix }
  let(:curtain) { create :curtain, width: 15.2, height: 15.2 }
  let(:curtain2) { create :curtain, width: 56.2, height: 56.2 }

  it { expect(curtain.width).to eql 15.2 }
  it { expect(curtain.height).to eql 15.2 }

  it { expect(curtain.width_in('cm')).to eql UnitConverter.converting(15.2, 'mm', 'cm') }
  it { expect(curtain.height_in('cm')).to eql UnitConverter.converting(15.2, 'mm', 'cm') }

  context '#calculate_price' do
    it { expect(curtain.send(:calculate_price)).to eql(Setting.price_for(curtain.width, curtain.height)) }
    it { expect(curtain2.send(:calculate_price)).to eql(Setting.price_for(curtain2.width, curtain2.height)) }
  end

  context 'convertion to imperial' do
    let(:curtain_imperial) { create :curtain, width: 15.2, height: 23, metric: 'Imperial' }

    it 'check new size' do
      expect(curtain_imperial.width).to eql UnitConverter.converting 15.2, 'in', 'mm'
      expect(curtain_imperial.height).to eql UnitConverter.converting 23, 'in', 'mm'
    end
  end

  context 'Inside/Outside' do
    it 'expects inout be Inside when inside is true' do
      curtain = build :curtain, inside: true
      expect(curtain.inout).to eql 'Inside'
    end

    it 'expects inout be Outside when inside is false' do
      curtain = build :curtain, inside: false
      expect(curtain.inout).to eql 'Outside'
    end
  end
end
