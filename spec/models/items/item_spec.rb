require 'rails_helper'

RSpec.describe Item, :type => :model do
  let(:item){ create :item, quantity: 30, price: 13.9 }

  it { expect(item.full_price).to  eql((item.price * item.quantity).to_f) }
end
