require 'rails_helper'

RSpec.describe Manufacturer, type: :model do
  let(:manufacturer) { create :manufacturer, manufacturer_type: 'drape'}

  it {expect(manufacturer.get_type).to eql 'Drapery'}
end
