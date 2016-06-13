require 'rails_helper'

feature 'Profiles', js: true, type: :feature do
  let(:admin){ create :admin }

  before do
    login_as admin
    visit root_path
    click_link admin.email
    expect(page).to have_field('user_email', with: admin.email)
  end

  it 'allow to change email' do
    new_email = 'new@email.com'
    fill_in 'user_email', with: new_email
    click_button 'Update User'
    expect(page).to have_link(new_email)
  end

  it 'generate error' do
    new_email = 'new'
    fill_in 'user_email', with: new_email
    click_button 'Update User'
    expect(page).to have_content('Email is invalid')
  end
end
