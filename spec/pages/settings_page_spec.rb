require 'rails_helper'

feature 'Settings', js: true, type: :feature do
  let(:settings_page) { SettingsPage.new }
  let(:admin){ create :admin }

  before do
    login_as admin
    settings_page.load
  end

  context '#index' do
    it { expect(settings_page.setting_values_visible?).to be_truthy }
    it { expect(page).to have_field('unit_setting_value', with: '20.0 in') }
  end

  context '#update' do
    it '#fabric_color' do
      colors = 'Black, White'
      settings_page.fabric_color.set colors
      settings_page.fc_update.click
      expect(settings_page.fabric_color.value).to eq(colors)
    end

    it '#installation_price' do
      settings_page.installation_price.set 60
      settings_page.ip_update.click
      expect(settings_page.installation_price.value).to eq('60')
    end

    it '#width_multiplicity' do
      width = '20 in'
      settings_page.multiplicity.set width
      settings_page.m_update.click
      expect(settings_page.multiplicity.value).to eq('20.0 in')
    end

    it '#width_multiplicity have format' do
      width = '20 3 in'
      settings_page.multiplicity.set width
      settings_page.m_update.click
      expect(settings_page.alert_error.text).to eq('×Value is invalid')
    end

    it '#multiplicity_items' do
      settings_page.add_item.click
      settings_page.i_name.set 'First item'
      settings_page.i_qty.set '2'
      settings_page.i_price.set '3'
      settings_page.i_update.click
      expect(settings_page.i_name.value).to eq('First item')
      expect(settings_page.i_qty.value).to eq('2')
      expect(settings_page.i_price.value).to eq('3')
    end
  end
end
