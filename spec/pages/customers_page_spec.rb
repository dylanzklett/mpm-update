require 'rails_helper'

feature 'Customer', js: true, type: :feature do
  let(:admin) { create :admin }
  let!(:customer){ create :customer, sales: admin }

  before do
    login_as admin
  end

  context '#index' do
    let(:customers_page) { CustomersPage.new }

    before do
      customers_page.load
    end

    it { expect(page).to have_content(customer.email) }
    it { expect(page).to have_content(customer.first_name) }
    it { expect(page).to have_content(customer.city) }
  end

  context '#create' do
    let(:customer_new_page) { CustomerNewPage.new }
    let(:attrs) {{
        email: 'valid@email.com',
        first_name: 'first_name',
        city: 'Tokyo',
        first_title: 'FirstTitle',
        phone_o: '9876543210'
    }}

    before do
      customer_new_page.load
    end

    it 'allow to create customer' do
      expect(customer_new_page.customer_form_visible?).to be_truthy
      customer_new_page.customer_email.set attrs[:email]
      customer_new_page.first_name.set attrs[:first_name]
      customer_new_page.city.set attrs[:city]
      customer_new_page.first_title.set attrs[:first_title]
      customer_new_page.phone_o.set attrs[:phone_o]
      customer_new_page.submit_btn.click
      expect(page).to have_content(attrs[:email])
      expect(page).to have_content(attrs[:first_name])
      expect(page).to have_content(attrs[:city])
      expect(page).to have_content(attrs[:first_title])
      expect(page).to have_content(attrs[:phone_o])
    end

    it 'allow to create customer with project' do
      expect(customer_new_page.customer_form_visible?).to be_truthy
      customer_new_page.customer_email.set attrs[:email]
      customer_new_page.first_name.set attrs[:first_name]
      customer_new_page.city.set attrs[:city]
      customer_new_page.first_title.set attrs[:first_title]
      customer_new_page.phone_o.set attrs[:phone_o]
      customer_new_page.with_project_btn.click
      expect(page).to have_content(attrs[:email])
      expect(page).to have_button('Make propose')
    end

    it 'show validation error' do
      customer_new_page.customer_email.set 'invalid email'
      customer_new_page.first_name.set attrs[:first_name]
      customer_new_page.submit_btn.click
      expect(customer_new_page.first_name.value).to eq(attrs[:first_name])
      expect(customer_new_page.has_errors?).to be_truthy
    end
  end

  context '#show' do
    let(:customer_info_page) { CustomerInfoPage.new }

    before do
      customer_info_page.load(cid: customer.id)
    end

    it { expect(page).to have_content(customer.email) }
    it { expect(customer_info_page.customer_buttons_visible?).to be_truthy }
    it { expect(customer_info_page.recent_projects.visible?).to be_truthy }
    it { expect(customer_info_page.has_delete_project?).to be_falsey }
  end

  context '#edit' do
    let(:customer_edit_page) { CustomerEditPage.new }

    before do
      customer_edit_page.load(cid: customer.id)
    end

    it { expect(customer_edit_page.customer_email.value).to eq(customer.email)}
    it { expect(customer_edit_page.customer_form_visible?).to be_truthy }
  end

  context '#update' do
    let(:customer_edit_page) { CustomerEditPage.new }
    let(:attrs) {{
        email: 'valid@email.com',
        first_name: 'first_name',
        city: 'Tokyo',
        first_title: 'FirstTitle',
        phone_o: '9876543210'
    }}

    before do
      customer_edit_page.load(cid: customer.id)
    end

    it 'allow to update customer' do
      expect(customer_edit_page.customer_form_visible?).to be_truthy
      customer_edit_page.customer_email.set attrs[:email]
      customer_edit_page.first_name.set attrs[:first_name]
      customer_edit_page.city.set attrs[:city]
      customer_edit_page.first_title.set attrs[:first_title]
      customer_edit_page.phone_o.set attrs[:phone_o]
      customer_edit_page.submit_btn.click
      expect(page).to have_content(attrs[:email])
      expect(page).to have_content(attrs[:first_name])
      expect(page).to have_content(attrs[:city])
      expect(page).to have_content(attrs[:first_title])
      expect(page).to have_content(attrs[:phone_o])
    end

    it 'show validation error' do
      customer_edit_page.customer_email.set 'invalid email'
      customer_edit_page.submit_btn.click
      expect(customer_edit_page.has_errors?).to be_truthy
    end
  end

  context '#destroy' do
    let(:customer_info_page) { CustomerInfoPage.new }

    before do
      customer_info_page.load(cid: customer.id)
    end

    it 'allow to destroy user email' do
      customer_info_page.delete_cus.click
      expect(page).to have_no_content(customer.email)
    end
  end
end
