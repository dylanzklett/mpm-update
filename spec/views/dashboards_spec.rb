require 'rails_helper'

feature 'Dashboard' do
  context 'Users link' do
    let(:admin){ create :admin }
    let(:user){ create :user }

    it 'show for admin' do
      sign_in admin
      visit root_path
      expect(page).to have_link('Users', href: users_path)
    end

    it 'not show for user' do
      sign_in user
      visit root_path
      expect(page).to have_no_link('Users', href: users_path)
    end
  end
end
