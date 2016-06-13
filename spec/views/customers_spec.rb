require 'rails_helper'

feature 'Customers', js: true, type: :feature do
  let(:admin){ create :admin }
  let!(:customer){ create :customer, sales: admin }

  before do
    login_as admin
  end

  context '#index' do
    before do
      visit customers_path
    end

    it { expect(page).to have_content(customer.email) }
    it { expect(page).to have_content(customer.first_name) }
    it { expect(page).to have_content(customer.city) }
  end

  context '#create' do
    let(:attrs) {{
        email: 'valid@email.com',
        first_name: 'first_name',
        city: 'Tokyo',
        first_title: 'FirstTitle',
        phone_o: '9876543210'
    }}

    before do
      visit new_customer_path
    end

    it 'allow to create customer' do
      fill_in 'customer_email', with: attrs[:email]
      fill_in 'customer_profile_attributes_first_name', with: attrs[:first_name]
      fill_in 'customer_profile_attributes_city', with: attrs[:city]
      fill_in 'customer_profile_attributes_first_title', with: attrs[:first_title]
      fill_in 'customer_profile_attributes_phone_o', with: attrs[:phone_o]
      click_button 'Create Customer'
      expect(page).to have_content(attrs[:email])
      expect(page).to have_content(attrs[:first_name])
      expect(page).to have_content(attrs[:city])
      expect(page).to have_content(attrs[:first_title])
      expect(page).to have_content(attrs[:phone_o])
    end

    it 'allow to create customer with project' do
      fill_in 'customer_email', with: attrs[:email]
      fill_in 'customer_profile_attributes_first_name', with: attrs[:first_name]
      fill_in 'customer_profile_attributes_city', with: attrs[:city]
      fill_in 'customer_profile_attributes_first_title', with: attrs[:first_title]
      fill_in 'customer_profile_attributes_phone_o', with: attrs[:phone_o]
      click_button 'Create customer and add new project'
      expect(page).to have_content(attrs[:email])
      expect(page).to have_button('Make propose')
    end

    it 'show validation error' do
      fill_in 'customer_email', with: 'invalid'
      fill_in 'customer_profile_attributes_first_name', with: attrs[:first_name]
      click_button 'Create Customer'
      expect(page).to have_field('customer_profile_attributes_first_name', with: attrs[:first_name])
      expect(page).to have_content("Email is invalid")
    end
  end

  context '#edit' do
    before do
      visit edit_customer_path(customer)
    end

    it { expect(page).to have_field('customer_email', with: customer.email) }
  end

  context '#update' do
    let(:attrs) {{
        email: 'valid@email.com',
        first_name: 'first_name',
        city: 'Tokyo',
        first_title: 'FirstTitle',
        phone_o: '9876543210'
    }}


    before do
      visit edit_customer_path(customer)
    end

    it 'allow to update customer' do
      fill_in 'customer_email', with: attrs[:email]
      fill_in 'customer_profile_attributes_first_name', with: attrs[:first_name]
      fill_in 'customer_profile_attributes_city', with: attrs[:city]
      fill_in 'customer_profile_attributes_first_title', with: attrs[:first_title]
      fill_in 'customer_profile_attributes_phone_o', with: attrs[:phone_o]
      click_button 'Update Customer'
      expect(page).to have_content(attrs[:email])
      expect(page).to have_content(attrs[:first_name])
      expect(page).to have_content(attrs[:city])
      expect(page).to have_content(attrs[:first_title])
      expect(page).to have_content(attrs[:phone_o])
    end

    it 'show validation error' do
      fill_in 'customer_email', with: 'invalid'
      click_button 'Update Customer'
      expect(page).to have_content("Email is invalid")
    end
  end

  context '#show' do
    before do
      visit customer_path(customer)
    end

    it { expect(page).to have_content(customer.email) }
  end

  context '#destroy' do
    before do
      visit customer_path(customer)
    end

    it 'allow to destroy customer' do
      click_link 'Delete'
      expect(page).to have_no_content(customer.email)
    end
  end
end
