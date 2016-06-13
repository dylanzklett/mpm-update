require 'rails_helper'

feature 'Users', js: true, type: :feature do
  let(:admin){ create :admin }
  let!(:user){ create :user }

  before do
    login_as admin
  end

  context '#index' do
    before do
      visit users_path
    end

    it { expect(page).to have_content(admin.email) }
    it { expect(page).to have_content(user.email) }
  end

  context '#create' do
    let(:attrs) {{
      email: 'valid@email.com',
      pass: 'password'
    }}


    before do
      visit new_user_path
    end

    it 'allow to create user' do
      fill_in 'user_email', with: attrs[:email]
      fill_in 'user_password', with: attrs[:pass]
      fill_in 'user_password_confirmation', with: attrs[:pass]
      click_button 'Create User'
      expect(page).to have_content(attrs[:email])
    end

    it 'show validation error' do
      fill_in 'user_email', with: attrs[:email]
      fill_in 'user_password', with: 'pass'
      fill_in 'user_password_confirmation', with: 'other_pass'
      click_button 'Create User'
      expect(page).to have_field('user_email', with: attrs[:email])
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end

  context '#show' do
    before do
      visit user_path(user)
    end

    it { expect(page).to have_content(user.email) }
  end

  context '#edit' do
    before do
      visit edit_user_path(user)
    end

    it { expect(page).to have_field('user_email', with: user.email) }
  end

  context '#update' do
    before do
      visit edit_user_path(user)
    end

    it 'allow to change email' do
      new_email = 'valid@email.com'
      fill_in 'user_email', with: new_email
      click_button 'Update User'
      expect(page).to have_content(new_email)
    end

    it 'show validation error' do
      fill_in 'user_email', with: 'invalid_email'
      click_button 'Update User'
      expect(page).to have_content('Email is invalid')
    end
  end

  context '#destroy' do
    before do
      visit user_path(user)
    end

    it 'allow to destroy user email' do
      click_link 'Delete'
      expect(page).to have_no_content(user.email)
    end
  end
end
