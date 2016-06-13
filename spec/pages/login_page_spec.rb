require 'rails_helper'

feature 'Login Page', js: true, type: :feature do

  let(:login_page) { LoginPage.new }

  describe 'Login' do

    let(:admin) { create :admin }
    let(:user) { create :user }

    before do
      login_page.load
    end

    it 'page verify' do
      expect(login_page.layout_visible?).to be_truthy
      expect(login_page.login_form_visible?).to be_truthy
    end

    it 'as admin' do
      login_page.login_with(admin.email, admin.password)
      expect(login_page.profile.text).to eq(admin.email)
      expect(login_page.header_visible?).to be_truthy
      expect(login_page.admin?).to be_truthy
    end

    it 'as user' do
      login_page.login_with(user.email, user.password)
      expect(login_page.profile.text).to eq(user.email)
      expect(login_page.header_visible?).to be_truthy
      expect(login_page.admin?).to be_falsey
    end

    it 'with incorrect data' do
      login_page.login_with('fail@example.com', 'password')
      expect(login_page.alert_error.visible?).to be_truthy
    end
  end
end
