require 'rails_helper'

feature 'Profile', js: true, type: :feature do
  let(:admin) { create :admin }
  let(:profile_page) { ProfilePage.new }

  before do
    login_as admin
    profile_page.load
    expect(profile_page.user_email.value).to eq(admin.email)
    expect(profile_page.user_form_visible?).to be_truthy
  end

  context 'Email' do
    it 'allow to change' do
      new_email = 'new@email.com'
      profile_page.user_email.set new_email
      profile_page.submit_btn.click
      expect(page).to have_link(new_email)
    end

    it 'generate error' do
      new_email = 'new'
      profile_page.user_email.set new_email
      profile_page.submit_btn.click
      expect(page).to have_content('Email is invalid')
    end
  end

  context 'Password' do
    let(:change_password_page) { UserChangePasswordPage.new }
    let(:login_page) { LoginPage.new }

    before do
      change_password_page.load(uid: admin.id)
    end

    it 'allow to change' do
      new_pass = 'newpassword'
      change_password_page.change_password_to(new_pass, new_pass)
      change_password_page.logout.click
      login_page.load
      login_page.login_with(admin.email, new_pass)
      expect(page).to have_content('Dashboard')
    end

    it 'generate error' do
      new_pass = 'new'
      change_password_page.change_password_to(new_pass, new_pass)
      expect(change_password_page.error_block.text).to eq('Password is too short (minimum is 8 characters)')
    end
  end
end
