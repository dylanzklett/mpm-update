require 'rails_helper'

feature 'Manufacturers', js: true, type: :feature do
  let(:admin){ create :admin }
  let!(:manufacturer){ create :manufacturer }

  before do
    login_as admin
  end

  context '#index' do
    let(:manufacturers_page) { ManufacturersPage.new }

    before do
      manufacturers_page.load
    end

    it { expect(page).to have_content(manufacturer.email) }
    it { expect(page).to have_content(manufacturer.title) }
    it { expect(manufacturers_page.man_table.visible?).to be_truthy}
  end

  context '#create' do
    let(:man_new_page) { ManufacturerNewPage.new }
    let(:attrs) {{
        email: 'valid@email.com',
        title: 'New Title',
        phone: '0123456789',
        address: 'NY4 15 First'
    }}

    before do
      man_new_page.load
    end

    it { expect(man_new_page.form_visible?).to be_truthy }

    it 'allow to create manufacturer' do
      man_new_page.man_email.set attrs[:email]
      man_new_page.man_title.set attrs[:title]
      man_new_page.man_phone.set attrs[:phone]
      man_new_page.man_address.set attrs[:address]
      man_new_page.submit_btn.click
      expect(page).to have_content(attrs[:email])
      expect(page).to have_content(attrs[:title])
      expect(page).to have_content(attrs[:phone])
      expect(page).to have_content(attrs[:address])
    end

    it 'show validation error' do
      man_new_page.man_email.set 'invalid'
      man_new_page.man_title.set attrs[:title]
      man_new_page.submit_btn.click
      expect(man_new_page.man_title.value).to eq(attrs[:title])
      expect(man_new_page.error_block.text).to eq('Email is invalid')
    end
  end

  context '#edit' do
    let(:man_edit_page) { ManufacturerEditPage.new }

    before do
      man_edit_page.load(mid: manufacturer.id)
    end

    it { expect(man_edit_page.man_email.value).to eq(manufacturer.email) }
    it { expect(man_edit_page.man_title.value).to eq(manufacturer.title) }
  end

  context '#update' do
    let(:man_edit_page) { ManufacturerEditPage.new }
    let(:attrs) {{
        email: 'valid@email.com',
        title: 'New Title',
        phone: '0123456789',
        address: 'NY4 15 First'
    }}

    before do
      man_edit_page.load(mid: manufacturer.id)
    end

    it 'allow to update manufacturer' do
      man_edit_page.man_email.set attrs[:email]
      man_edit_page.man_title.set attrs[:title]
      man_edit_page.man_phone.set attrs[:phone]
      man_edit_page.man_address.set attrs[:address]
      man_edit_page.submit_btn.click
      expect(page).to have_content(attrs[:email])
      expect(page).to have_content(attrs[:title])
      expect(page).to have_content(attrs[:phone])
      expect(page).to have_content(attrs[:address])
    end

    it 'show validation error' do
      man_edit_page.man_email.set 'invalid'
      man_edit_page.man_title.set attrs[:title]
      man_edit_page.submit_btn.click
      expect(man_edit_page.man_title.value).to eq(attrs[:title])
      expect(man_edit_page.error_block.text).to eq('Email is invalid')
    end
  end

  context '#show' do
    let(:man_page) { ManufacturerInfoPage.new }

    before do
      man_page.load(mid: manufacturer.id)
    end

    it { expect(page).to have_content(manufacturer.email) }
    it { expect(page).to have_content(manufacturer.title) }
    it { expect(man_page.man_visible?).to be_truthy }
  end

  context '#destroy' do
    let(:man_page) { ManufacturerInfoPage.new }

    before do
      man_page.load(mid: manufacturer.id)
    end

    it 'allow to destroy manufacturer' do
      man_page.delete_man.click
      expect(page).to have_no_content(manufacturer.email)
      expect(page).to have_no_content(manufacturer.title)
    end
  end
end
