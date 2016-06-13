require 'rails_helper'

RSpec.describe UnitSetting, type: :model do
  let!(:unit_setting) { create :unit_setting, :width_multiplicity, value: '20.43 in' }

  it { expect(unit_setting.value).to eql Unit('20.43 in').convert_to('mm').to_s }
  it { expect(unit_setting.convert_for_show).to eql '20.43 in' }
end
