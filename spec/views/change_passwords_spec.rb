require 'rails_helper'

feature 'Change password', js: true, type: :feature do
  let(:admin){ create :admin }

  before do
    login_as admin
    visit root_path
    click_link admin.email
    expect(page).to have_field('user_email', with: admin.email)
    click_link 'Change password'
  end

  it 'allow to change password' do
    new_pass = 'newpassword'
    fill_in 'user_password', with: new_pass
    fill_in 'user_password_confirmation', with: new_pass
    click_button 'Change password'
    click_link 'Logout'
    fill_in 'user_email', with: admin.email
    fill_in 'user_password', with: new_pass
    click_button 'Log in'
    expect(page).to have_content('Dashboard')
  end

  it 'generate error' do
    new_pass = 'new'
    fill_in 'user_password', with: new_pass
    fill_in 'user_password_confirmation', with: new_pass
    click_button 'Change password'
    expect(page).to have_content('Password is too short (minimum is 8 characters)')
  end
end
