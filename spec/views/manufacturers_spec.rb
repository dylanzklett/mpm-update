require 'rails_helper'

feature 'Manufacturers', js: true, type: :feature do
  let(:admin){ create :admin }
  let!(:manufacturer){ create :manufacturer }

  before do
    login_as admin
  end

  context '#index' do
    before do
      visit manufacturers_path
    end

    it { expect(page).to have_content(manufacturer.email) }
    it { expect(page).to have_content(manufacturer.title) }
  end

  context '#create' do
    let(:attrs) {{
        email: 'valid@email.com',
        title: 'New Title',
        phone: '0123456789',
        address: 'NY4 15 First'
    }}


    before do
      visit new_manufacturer_path
    end

    it 'allow to create manufacturer' do
      fill_in 'manufacturer_email', with: attrs[:email]
      fill_in 'manufacturer_title', with: attrs[:title]
      fill_in 'manufacturer_phone', with: attrs[:phone]
      fill_in 'manufacturer_address', with: attrs[:address]
      click_button 'Create Manufacturer'
      expect(page).to have_content(attrs[:email])
      expect(page).to have_content(attrs[:title])
      expect(page).to have_content(attrs[:phone])
      expect(page).to have_content(attrs[:address])
    end

    it 'show validation error' do
      fill_in 'manufacturer_email', with: 'invalid'
      fill_in 'manufacturer_title', with: attrs[:title]
      click_button 'Create Manufacturer'
      expect(page).to have_field('manufacturer_title', with: attrs[:title])
      expect(page).to have_content('Email is invalid')
    end
  end

  context '#edit' do
    before do
      visit edit_manufacturer_path(manufacturer)
    end

    it { expect(page).to have_field('manufacturer_email', with: manufacturer.email) }
    it { expect(page).to have_field('manufacturer_title', with: manufacturer.title) }
  end

  context '#update' do
    let(:attrs) {{
        email: 'valid@email.com',
        title: 'New Title',
        phone: '0123456789',
        address: 'NY4 15 First'
    }}


    before do
      visit edit_manufacturer_path(manufacturer)
    end

    it 'allow to update manufacturer' do
      fill_in 'manufacturer_email', with: attrs[:email]
      fill_in 'manufacturer_title', with: attrs[:title]
      fill_in 'manufacturer_phone', with: attrs[:phone]
      fill_in 'manufacturer_address', with: attrs[:address]
      click_button 'Update Manufacturer'
      expect(page).to have_content(attrs[:email])
      expect(page).to have_content(attrs[:title])
      expect(page).to have_content(attrs[:phone])
      expect(page).to have_content(attrs[:address])
    end

    it 'show validation error' do
      fill_in 'manufacturer_email', with: 'invalid'
      fill_in 'manufacturer_title', with: attrs[:title]
      click_button 'Update Manufacturer'
      expect(page).to have_field('manufacturer_title', with: attrs[:title])
      expect(page).to have_content('Email is invalid')
    end
  end

  context '#show' do
    before do
      visit manufacturer_path(manufacturer)
    end

    it { expect(page).to have_content(manufacturer.email) }
    it { expect(page).to have_content(manufacturer.title) }
  end

  context '#destroy' do
    before do
      visit manufacturer_path(manufacturer)
    end

    it 'allow to destroy manufacturer' do
      click_link 'Delete'
      expect(page).to have_no_content(manufacturer.email)
      expect(page).to have_no_content(manufacturer.title)
    end
  end
end
