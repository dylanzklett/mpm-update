require 'rails_helper'

feature 'Manufacturers', js: true, type: :feature do
  let(:admin){ create :admin }
  let(:manufacturer){ create :manufacturer }
  let!(:service){ create :service, manufacturer: manufacturer }


  before do
    login_as admin
  end

  context '#index' do
    before do
      visit manufacturer_path(manufacturer)
    end

    it { expect(page).to have_content('Services') }
  end

  context '#create' do
    let(:attrs) {{
        name: 'service',
        price: 15.99
    }}


    before do
      visit new_manufacturer_service_path(manufacturer)
    end

    it 'allow to create service' do
      fill_in 'service_name', with: attrs[:name]
      fill_in 'service_price', with: attrs[:price]
      click_button 'Create Service'
      expect(page).to have_content(attrs[:name])
      expect(page).to have_content(attrs[:price])
    end
  end

  context '#edit' do
    before do
      visit edit_manufacturer_service_path(manufacturer, service)
    end

    it { expect(page).to have_field('service_name', with: service.name) }
    it { expect(page).to have_field('service_price', with: service.price.to_f) }
  end

  context '#update' do
    let(:attrs) {{
        name: 'new_service',
        price: 122.88
    }}


    before do
      visit edit_manufacturer_service_path(manufacturer, service)
    end

    it 'allow to update service' do
      fill_in 'service_name', with: attrs[:name]
      fill_in 'service_price', with: attrs[:price]
      click_button 'Update Service'
      expect(page).to have_content(attrs[:name])
      expect(page).to have_content(attrs[:price])
    end

  end

  context '#destroy' do
    before do
      visit manufacturer_path(manufacturer)
    end

    it 'allow to destroy service' do
      within 'table.services' do
        click_link 'Delete'
      end
      expect(page).to have_css("table.services tr", :count => 1)
    end
  end
end
