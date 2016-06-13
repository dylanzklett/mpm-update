require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:customer1){ create :customer, email: 'customer@email.com' }
  let(:customer2){ create :customer }
  let!(:profile){ create :profile, person: customer2, first_name: '', last_name: '' }

  it { expect(customer1.name_for_select).to  eql(customer1.profile.name_for_select) }
  it { expect(profile.name_for_select).to  eql("#{customer2.email} #{profile.city}") }

  it 'expects correct address for email' do
    profile = create :profile, person: customer1, first_name: 'Foo',
                     last_name: 'Bar', first_title: 'First', second_title: nil,
                     city: 'Dnepr', state: 'Ukraine'

    expect(profile.address_for_email).to eq "Foo Bar<br />First<br />Dnepr Ukraine<br />customer@email.com<br />#{profile.phone_o}"
  end
end
