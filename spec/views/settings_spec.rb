require 'rails_helper'

feature 'Settings', js: true, type: :feature do
  let(:admin){ create :admin }

  before do
    login_as admin
    visit settings_path
  end

  context '#index' do
    it { expect(page).to have_field('unit_setting_value', with: '20.0 in') }
  end

  context '#update' do
    it '#fabric_color' do
      setting = Setting.where(code: 'fabric_color').first
      colors = 'Black, White'
      within "#edit_setting_#{setting.id}" do
        fill_in 'setting_value', with: colors
        click_button 'update'
      end
      visit settings_path
      within "#edit_setting_#{setting.id}" do
        expect(page).to have_field('setting_value', with: colors)
      end
    end

    it '#installation_price' do
      setting = Setting.where(code: 'installation_price').first
      within "#edit_setting_#{setting.id}" do
        fill_in 'setting_value', with: 60
        click_button 'update'
      end
      visit settings_path
      within "#edit_setting_#{setting.id}" do
        expect(page).to have_field('setting_value', with: 60)
      end
    end

    it '#width_multiplicity' do
      setting = Setting.where(code: 'width_multiplicity').first
      width = '20 in'
      within "#edit_unit_setting_#{setting.id}" do
        fill_in 'unit_setting_value', with: width
        click_button 'update'
      end
      visit settings_path
      within "#edit_unit_setting_#{setting.id}" do
        expect(page).to have_field('unit_setting_value', with: '20.0 in')
      end
    end

    it '#width_multiplicity have format' do
      setting = Setting.where(code: 'width_multiplicity').first
      width = '20 3 in'
      within "#edit_unit_setting_#{setting.id}" do
        fill_in 'unit_setting_value', with: width
        click_button 'update'
      end
      expect(page).to have_content('Value is invalid')
    end

    it '#multiplicity_items' do
      setting = Setting.where(code: 'multiplicity_items').first
      within "#edit_setting_#{setting.id}" do
        click_link 'Add Item'
        fill_in 'Name', with: 'First item'
        fill_in 'Quantity', with: '2'
        fill_in 'Price', with: '3'
        click_button 'update'
      end
      visit settings_path
      within "#edit_setting_#{setting.id}" do
        expect(page).to have_field('Name', with: 'First item')
        expect(page).to have_field('Quantity', with: '2')
        expect(page).to have_field('Price', with: '3')
      end
    end
  end

end
