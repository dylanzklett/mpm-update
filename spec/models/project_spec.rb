require 'rails_helper'

RSpec.describe Project, :type => :model do
  let(:project){ create :project, customer: create(:customer), sales: create(:admin) }
  let!(:installation_price) { create :setting, :installation_price }
  let!(:price_setting) { create :setting, :price_matrix }

  it { expect(project.state).to eql('quotes') }
  it { expect(project.versioned_name).to eql project.id }

  context '#propose' do
    before do
      project.propose
    end
    it { expect(project.state).to eql('proposals') }
    it { expect(project.versions.count).to eql(1) }
    it { expect(project.versions.last.event).to eql('initialize') }
  end

  context '#ordered' do
    before do
      project.propose
      project.ordered
    end
    it { expect(project.state).to eql('orders') }
  end

  context '#active' do
    before do
      project.propose
      project.ordered
      project.active
    end
    it { expect(project.state).to eql('in_process') }
  end

  context '#close' do
    before do
      project.propose
      project.ordered
      project.active
      project.close
    end
    it { expect(project.state).to eql('closed') }
  end

  context '#items_price' do
    let!(:item1) { create :item, project: project, quantity: 2, price: 15.7 }
    let!(:item2) { create :item, project: project, quantity: 3, price: 12.4 }
    let!(:item_project) { project.reload }

    it { expect(item_project.items_price).to eql(item1.full_price + item2.full_price) }
  end

  context '#calculated_price' do
    let!(:setting) { create :unit_setting, :width_multiplicity }
    let!(:setting2) { create :setting, :price_matrix }
    let(:project){ create :project, customer: (create :customer), sales: create(:admin),
                                    items: [
                                      create(:item, quantity: 2, price: 15.7),
                                      create(:item, quantity: 3, price: 12.4)
                                    ],
                                    curtains: [
                                      create(:curtain, quantity: 3, width: 56.2, height: 56.2)
                                    ]
                  }

    it 'calculate price correctly' do
      expect(project.calculated_price.to_f.round(2)).to eql(
        (project.items.inject(0){|acc, item| acc + item.full_price } +
         project.curtains.inject(0){|acc, curtains| acc + curtains.full_price }
        ).to_f.round(2)
      )
    end
  end

  context '#fix_price' do
    let!(:setting) { create :unit_setting, :width_multiplicity }
    let!(:setting2) { create :setting, :price_matrix }
    let(:project){ create :project, customer: (create :customer), sales: create(:admin),
                                    items: [
                                      create(:item, quantity: 2, price: 15.7),
                                      create(:item, quantity: 3, price: 12.4)
                                    ],
                                    curtains: [
                                      create(:curtain, quantity: 3, width: 56.2, height: 56.2)
                                    ]
                  }

    it 'create version' do
      init_price = project.price
      expect(project.versions.count).to eql(0)
      project.propose
      expect(project.versions.count).to eql(1)
      project.items.destroy_all
      expect{project.save}.to change{project.price}.from(init_price).to(project.calculated_price)
      expect(project.versions.count).to eql(2)
      expect(project.versions.last.event).to eql('Price change')
      expect(project.versioned_name).to eql "#{project.id}A"
    end


  end

  context 'fix_price_with' do
    let!(:setting) { create :unit_setting, :width_multiplicity }
    let!(:setting2) { create :setting, :price_matrix }
    let(:project){ create :project, customer: (create :customer), sales: create(:admin), state: 'orders',
                                    items: [
                                      create(:item, quantity: 2, price: 15.7),
                                      create(:item, quantity: 3, price: 12.4)
                                    ],
                                    curtains: [
                                      create(:curtain, quantity: 3, width: 56.2, height: 56.2)
                                    ]
                  }

    it 'create version' do
      project.items = []
      project.fix_price_with 'list cleaned'
      expect(project.versions.last.event).to eql 'list cleaned'
    end
  end

  context 'populate item' do
    let!(:setting) {
      create :setting, :multiplicity_items,
        value: [
          { name: 'first', quantity: 2, price: 30.3 },
          { name: 'second', quantity: 3, price: 30.3 }
        ].to_json
    }

    let!(:setting2) { create :unit_setting, :width_multiplicity }
    let(:project){ create :project, customer: create(:customer), sales: create(:admin) }
    let!(:curtain) { create :curtain, project: project, width: 76.2, height: 76.2, quantity: 1, metric: 'Imperial' }

    before do
      project.populate_default_items
    end

    it 'add item from settings' do
      expect(project.items.size).to eql(3)
    end

    it 'add item quantity should expanded according to multiplicity' do
      num = (curtain.width / setting2.value.to_f).ceil
      line_items = project.items.order(:id)
      expect(line_items.first.quantity).to eql(2 * num)
      expect(line_items.second.quantity).to eql(3 * num)
    end

    it 'add item quantity should expanded according to multiplicity' do
      new_curtain = project.curtains.create!(width: 76.2, height: 76.2, quantity: 1)
      project.populate_default_items
      expect(project.items.size).to eql(3)
      num = (curtain.width / setting2.value.to_f).ceil
      line_items = project.items.order(:id)
      expect(line_items.first.quantity).to eql(2 * num * 2)
      expect(line_items.second.quantity).to eql(3 * num * 2)
    end
  end

  context 'populate instalation item' do
    let!(:setting2) { create :unit_setting, :width_multiplicity }
    let(:project){ create :project, customer: create(:customer), sales: create(:admin) }
    let!(:curtain) { create :curtain, project: project, width: 76.2, height: 76.2, quantity: 3 }

    before do
      project.populate_default_items
    end

    it 'add item for instalation' do
      expect(project.items.size).to eql(1)
      install = project.items.first
      expect(install.quantity).to eql(Unit('76.2 mm').convert_to('ft').scalar.ceil*3)
    end
  end

  context 'restore' do
    let!(:setting) { create :unit_setting, :width_multiplicity }
    let!(:setting2){ create :setting, :price_matrix }
    let!(:project) { create :project, customer: (create :customer), sales: create(:admin),
                            curtains: [
                              create(:curtain, quantity: 3, width: 56.2, height: 56.2)
                            ]
                    }

    it 'restore version' do
      init_price = project.price.to_f
      expect(project.versions.count).to eql(0)
      project.propose
      expect(project.versions.count).to eql(1)
      project.curtains.destroy_all
      expect{project.save}.to change{project.price}.from(init_price).to(project.calculated_price)
      expect(project.versions.count).to eql(2)
      project.restore(project.versions.first)
      expect(project.versions.count).to eql(3)
      expect(project.versions.last.event).to eql("restore ##{project.id}")
      expect(project.price).to eql init_price
    end
  end

  context '#search_by' do
    let(:customer){ create :customer, :with_profile, profile_attributes:
                                        { first_name: 'Foo', first_address: 'Ukraine'} }
    let(:customer2){ create :customer, :with_profile, profile_attributes:
                                        { first_name: 'Fog', first_address: 'Ukraine'} }
    let!(:project1){ create :project, customer: customer, sales: create(:admin) }
    let!(:project2){ create :project, customer: customer2, sales: create(:admin) }

    it 'expect to find project by customer fields' do
      result = described_class.search_by(customer.first_name)

      expect(result).to include(project1)
      expect(result).to_not include(project2)
    end

    it 'expect to find project by multipl customer fields' do
      result = described_class.search_by("#{customer.first_name} #{customer2.first_name}")

      expect(result).to include(project1)
      expect(result).to include(project2)
    end
  end
end
